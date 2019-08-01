require 'spec_helper_acceptance'
apache_hash = apache_settings_hash
describe 'apache::vhost define' do
  context 'no default vhosts' do
    pp = <<-MANIFEST
      class { 'apache':
        default_vhost => false,
        default_ssl_vhost => false,
        service_ensure => stopped,
      }
      if ($::osfamily == 'Suse' and $::operatingsystemrelease < '15') {
        exec { '/usr/bin/gensslcert':
          require => Class['apache'],
        }
      } elsif ($::osfamily == 'Suse' and $::operatingsystemrelease >= '15') {
        # In SLES 15, if not given a name, gensslcert defaults the name to be the hostname
        exec { '/usr/bin/gensslcert -n default':
          require => Class['apache'],
        }
      }
    MANIFEST
    it 'creates no default vhosts' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/15-default.conf") do
      it { is_expected.not_to be_file }
    end

    describe file("#{apache_hash['vhost_dir']}/15-default-ssl.conf") do
      it { is_expected.not_to be_file }
    end
  end

  context 'default vhost without ssl' do
    pp = <<-MANIFEST
      class { 'apache': }
    MANIFEST
    it 'creates a default vhost config' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/15-default.conf") do
      it { is_expected.to contain '<VirtualHost \*:80>' }
    end

    describe file("#{apache_hash['vhost_dir']}/15-default-ssl.conf") do
      it { is_expected.not_to be_file }
    end
  end

  context 'default vhost with ssl' do
    pp = <<-MANIFEST
      file { '#{apache_hash['run_dir']}':
        ensure  => 'directory',
        recurse => true,
      }

      class { 'apache':
        default_ssl_vhost => true,
        require => File['#{apache_hash['run_dir']}'],
      }
    MANIFEST
    it 'creates default vhost configs' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/15-default.conf") do
      it { is_expected.to contain '<VirtualHost \*:80>' }
    end

    describe file("#{apache_hash['vhost_dir']}/15-default-ssl.conf") do
      it { is_expected.to contain '<VirtualHost \*:443>' }
      it { is_expected.to contain 'SSLEngine on' }
    end
  end

  context 'new vhost on port 80' do
    pp = <<-MANIFEST
      class { 'apache': }
      file { '/var/www':
        ensure  => 'directory',
        recurse => true,
      }

      apache::vhost { 'first.example.com':
        port    => '80',
        docroot => '/var/www/first',
        require => File['/var/www'],
      }
    MANIFEST
    it 'configures an apache vhost' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/25-first.example.com.conf") do
      it { is_expected.to contain '<VirtualHost \*:80>' }
      it { is_expected.to contain 'ServerName first.example.com' }
    end
  end

  context 'new proxy vhost on port 80' do
    pp = <<-MANIFEST
      class { 'apache': }
      apache::vhost { 'proxy.example.com':
        port    => '80',
        docroot => '/var/www/proxy',
        proxy_pass => [
          { 'path' => '/foo', 'url' => 'http://backend-foo/'},
        ],
      proxy_preserve_host   => true,
      proxy_error_override  => true,
      }
    MANIFEST
    it 'configures an apache proxy vhost' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/25-proxy.example.com.conf") do
      it { is_expected.to contain '<VirtualHost \*:80>' }
      it { is_expected.to contain 'ServerName proxy.example.com' }
      it { is_expected.to contain 'ProxyPass' }
      it { is_expected.to contain 'ProxyPreserveHost On' }
      it { is_expected.to contain 'ProxyErrorOverride On' }
      it { is_expected.not_to contain 'ProxyAddHeaders' }
      it { is_expected.not_to contain "<Proxy \*>" }
    end
  end

  context 'new proxy vhost on port 80' do
    pp = <<-MANIFEST
      class { 'apache': }
      apache::vhost { 'proxy.example.com':
        port    => '80',
        docroot => '#{apache_hash['doc_root']}/proxy',
        proxy_pass_match => [
          { 'path' => '/foo', 'url' => 'http://backend-foo/'},
        ],
      proxy_preserve_host   => true,
      proxy_error_override  => true,
      }
    MANIFEST
    it 'configures an apache proxy vhost' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/25-proxy.example.com.conf") do
      it { is_expected.to contain '<VirtualHost \*:80>' }
      it { is_expected.to contain 'ServerName proxy.example.com' }
      it { is_expected.to contain 'ProxyPassMatch /foo http://backend-foo/' }
      it { is_expected.to contain 'ProxyPreserveHost On' }
      it { is_expected.to contain 'ProxyErrorOverride On' }
      it { is_expected.not_to contain 'ProxyAddHeaders' }
      it { is_expected.not_to contain "<Proxy \*>" }
    end
  end

  context 'new vhost with multiple IP addresses on multiple ports' do
    pp = <<-MANIFEST
      class { 'apache':
        default_vhost => false,
      }
      apache::vhost { 'example.com':
        port     => ['80', '8080'],
        ip       => ['127.0.0.1','127.0.0.2'],
        ip_based => true,
        docroot  => '/var/www/html',
      }
      host { 'host1.example.com': ip => '127.0.0.1', }
      host { 'host2.example.com': ip => '127.0.0.2', }
      file { '/var/www/html/index.html':
        ensure  => file,
        content => "Hello from vhost\\n",
      }
    MANIFEST
    it 'configures one apache vhost with 2 ip addresses and 2 ports' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe file("#{apache_hash['vhost_dir']}/25-example.com.conf") do
      it { is_expected.to contain '<VirtualHost 127.0.0.1:80 127.0.0.1:8080 127.0.0.2:80 127.0.0.2:8080>' }
      it { is_expected.to contain 'ServerName example.com' }
    end

    describe file(apache_hash['ports_file']) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Listen 127.0.0.1:80' }
      it { is_expected.to contain 'Listen 127.0.0.1:8080' }
      it { is_expected.to contain 'Listen 127.0.0.2:80' }
      it { is_expected.to contain 'Listen 127.0.0.2:8080' }
      it { is_expected.not_to contain 'NameVirtualHost 127.0.0.1:80' }
      it { is_expected.not_to contain 'NameVirtualHost 127.0.0.1:8080' }
      it { is_expected.not_to contain 'NameVirtualHost 127.0.0.2:80' }
      it { is_expected.not_to contain 'NameVirtualHost 127.0.0.2:8080' }
    end

    it 'answers to host1.example.com port 80' do
      run_shell('/usr/bin/curl host1.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end

    it 'answers to host1.example.com port 8080' do
      run_shell('/usr/bin/curl host1.example.com:8080', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end

    it 'answers to host2.example.com port 80' do
      run_shell('/usr/bin/curl host2.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end

    it 'answers to host2.example.com port 8080' do
      run_shell('/usr/bin/curl host2.example.com:8080', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end
  end

  context 'new vhost with IPv6 address on port 80', :ipv6 do
    pp = <<-MANIFEST
      class { 'apache':
        default_vhost  => false,
      }
      apache::vhost { 'example.com':
        port           => '80',
        ip             => '::1',
        ip_based       => true,
        docroot        => '/var/www/html',
      }
      host { 'ipv6.example.com': ip => '::1', }
      file { '/var/www/html/index.html':
        ensure  => file,
        content => "Hello from vhost\\n",
      }
    MANIFEST
    it 'configures one apache vhost with an ipv6 address' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe file("#{apache_hash['vhost_dir']}/25-example.com.conf") do
      it { is_expected.to contain '<VirtualHost [::1]:80>' }
      it { is_expected.to contain 'ServerName example.com' }
    end

    describe file(apache_hash['ports_file']) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Listen [::1]:80' }
      it { is_expected.not_to contain 'NameVirtualHost [::1]:80' }
    end

    it 'answers to ipv6.example.com' do
      run_shell('/usr/bin/curl ipv6.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end
  end

  context 'apache_directories' do
    let(:pp) do
      <<-MANIFEST
      class { 'apache': }

      if versioncmp('#{apache_hash['version']}', '2.4') >= 0 {
        $_files_match_directory = { 'path' => '(\.swp|\.bak|~)$', 'provider' => 'filesmatch', 'require' => 'all denied', }
      } else {
        $_files_match_directory = { 'path' => '(\.swp|\.bak|~)$', 'provider' => 'filesmatch', 'deny' => 'from all', }
      }

      $_directories = [
        { 'path' => '/var/www/files', },
        $_files_match_directory,
      ]

      apache::vhost { 'files.example.net':
        docroot     => '/var/www/files',
        directories => $_directories,
      }
      file { '/var/www/files/index.html':
        ensure  => file,
        content => "Hello World\\n",
      }
      file { '/var/www/files/index.html.bak':
        ensure  => file,
        content => "Hello World\\n",
      }
      host { 'files.example.net': ip => '127.0.0.1', }
    MANIFEST
    end

    describe 'readme example, adapted' do
      it 'configures a vhost with Files' do
        apply_manifest(pp, catch_failures: true)
      end

      describe service(apache_hash['service_name']) do
        it { is_expected.to be_enabled }
        it { is_expected.to be_running }
      end

      it 'answers to files.example.net #stdout' do
        expect(run_shell('/usr/bin/curl -sSf files.example.net:80/index.html').stdout).to eq("Hello World\n")
      end
      it 'answers to files.example.net #stderr' do
        result = run_shell('/usr/bin/curl -sSf files.example.net:80/index.html.bak', expect_failures: true)
        expect(result.stderr).to match(%r{curl: \(22\) The requested URL returned error: 403})
        expect(result.exit_code).to eq 22
      end
    end

    describe 'other Directory options' do
      pp_one = <<-MANIFEST
        class { 'apache': }

        if versioncmp($apache_version, '2.4') >= 0 {
          $_files_match_directory = { 'path' => 'private.html$', 'provider' => 'filesmatch', 'require' => 'all denied' }
        } else {
          $_files_match_directory = [
            { 'path' => 'private.html$', 'provider' => 'filesmatch', 'deny' => 'from all' },
            { 'path' => '/bar/bar.html', 'provider' => 'location', allow => [ 'from 127.0.0.1', ] },
          ]
        }

        $_directories = [
          { 'path' => '/var/www/files', },
          { 'path' => '/foo/', 'provider' => 'location', 'directoryindex' => 'notindex.html', },
          $_files_match_directory,
        ]

        apache::vhost { 'files.example.net':
          docroot     => '/var/www/files',
          directories => $_directories,
        }
        file { '/var/www/files/foo':
          ensure => directory,
        }
        file { '/var/www/files/foo/notindex.html':
          ensure  => file,
          content => "Hello Foo\\n",
        }
        file { '/var/www/files/private.html':
          ensure  => file,
          content => "Hello World\\n",
        }
        file { '/var/www/files/bar':
          ensure => directory,
        }
        file { '/var/www/files/bar/bar.html':
          ensure  => file,
          content => "Hello Bar\\n",
        }
        host { 'files.example.net': ip => '127.0.0.1', }
      MANIFEST
      it 'configures a vhost with multiple Directory sections' do
        apply_manifest(pp_one, catch_failures: true)
      end

      describe service(apache_hash['service_name']) do
        it { is_expected.to be_enabled }
        it { is_expected.to be_running }
      end

      it 'answers to files.example.net #stdout' do
        expect(run_shell('/usr/bin/curl -sSf files.example.net:80/').stdout).to eq("Hello World\n")
      end
      it 'answers to files.example.net #stdout foo' do
        expect(run_shell('/usr/bin/curl -sSf files.example.net:80/foo/').stdout).to eq("Hello Foo\n")
      end
      it 'answers to files.example.net #stderr' do
        result = run_shell('/usr/bin/curl -sSf files.example.net:80/private.html', expect_failures: true)
        expect(result.stderr).to match(%r{curl: \(22\) The requested URL returned error: 403})
        expect(result.exit_code).to eq 22
      end
      it 'answers to files.example.net #stdout bar' do
        expect(run_shell('/usr/bin/curl -sSf files.example.net:80/bar/bar.html').stdout).to eq("Hello Bar\n")
      end
    end

    describe 'SetHandler directive' do
      pp_two = <<-MANIFEST
        class { 'apache': }
        apache::mod { 'status': }
        host { 'files.example.net': ip => '127.0.0.1', }
        apache::vhost { 'files.example.net':
          docroot     => '/var/www/files',
          directories => [
            { path => '/var/www/files', },
            { path => '/server-status', provider => 'location', sethandler => 'server-status', },
          ],
        }
        file { '/var/www/files/index.html':
          ensure  => file,
          content => "Hello World\\n",
        }
      MANIFEST
      it 'configures a vhost with a SetHandler directive' do
        apply_manifest(pp_two, catch_failures: true)
      end

      describe service(apache_hash['service_name']) do
        it { is_expected.to be_enabled }
        it { is_expected.to be_running }
      end

      it 'answers to files.example.net #stdout' do
        expect(run_shell('/usr/bin/curl -sSf files.example.net:80/index.html').stdout).to eq("Hello World\n")
      end
      it 'answers to files.example.net #stdout regex' do
        expect(run_shell('/usr/bin/curl -sSf files.example.net:80/server-status?auto').stdout).to match(%r{Scoreboard: })
      end
    end

    describe 'Satisfy and Auth directive', unless: apache_hash['version'] == '2.4' do
      pp_two = <<-MANIFEST
        class { 'apache': }
        host { 'files.example.net': ip => '127.0.0.1', }
        apache::vhost { 'files.example.net':
          docroot     => '/var/www/files',
          directories => [
            {
              path => '/var/www/files/foo',
              auth_type => 'Basic',
              auth_name => 'Basic Auth',
              auth_user_file => '/var/www/htpasswd',
              auth_require => "valid-user",
            },
            {
              path => '/var/www/files/bar',
              auth_type => 'Basic',
              auth_name => 'Basic Auth',
              auth_user_file => '/var/www/htpasswd',
              auth_require => 'valid-user',
              satisfy => 'Any',
            },
            {
              path => '/var/www/files/baz',
              allow => 'from 10.10.10.10',
              auth_type => 'Basic',
              auth_name => 'Basic Auth',
              auth_user_file => '/var/www/htpasswd',
              auth_require => 'valid-user',
              satisfy => 'Any',
            },
          ],
        }
        file { '/var/www/files/foo':
          ensure => directory,
        }
        file { '/var/www/files/bar':
          ensure => directory,
        }
        file { '/var/www/files/baz':
          ensure => directory,
        }
        file { '/var/www/files/foo/index.html':
          ensure  => file,
          content => "Hello World\\n",
        }
        file { '/var/www/files/bar/index.html':
          ensure  => file,
          content => "Hello World\\n",
        }
        file { '/var/www/files/baz/index.html':
          ensure  => file,
          content => "Hello World\\n",
        }
        file { '/var/www/htpasswd':
          ensure  => file,
          content => "login:IZ7jMcLSx0oQk", # "password" as password
        }
      MANIFEST
      it 'configures a vhost with Satisfy and Auth directive' do
        apply_manifest(pp_two, catch_failures: true)
      end

      describe service(apache_hash['service_name']) do
        it { is_expected.to be_enabled }
        it { is_expected.to be_running }

        it 'answers to files.example.net' do
          result = run_shell('/usr/bin/curl -sSf files.example.net:80/foo/index.html', expect_failures: true)
          expect(result.stderr).to match(%r{curl: \(22\) The requested URL returned error: 401})
          expect(result.exit_code).to eq 22
          expect(run_shell('/usr/bin/curl -sSf -u login:password files.example.net:80/foo/index.html').stdout).to eq("Hello World\n")
          expect(run_shell('/usr/bin/curl -sSf files.example.net:80/bar/index.html').stdout).to eq("Hello World\n")
          expect(run_shell('/usr/bin/curl -sSf -u login:password files.example.net:80/bar/index.html').stdout).to eq("Hello World\n")
          result = run_shell('/usr/bin/curl -sSf files.example.net:80/baz/index.html', expect_failures: true)
          expect(result.stderr).to match(%r{curl: \(22\) The requested URL returned error: 401})
          expect(result.exit_code).to eq 22
          expect(run_shell('/usr/bin/curl -sSf -u login:password files.example.net:80/baz/index.html').stdout).to eq("Hello World\n")
        end
      end
    end
  end

  context 'virtual_docroot hosting separate sites' do
    pp = <<-MANIFEST
      class { 'apache': }
      apache::vhost { 'virt.example.com':
        vhost_name      => '*',
        serveraliases   => '*virt.example.com',
        port            => '80',
        docroot         => '/var/www/virt',
        virtual_docroot => '/var/www/virt/%1',
      }
      host { 'virt.example.com': ip => '127.0.0.1', }
      host { 'a.virt.example.com': ip => '127.0.0.1', }
      host { 'b.virt.example.com': ip => '127.0.0.1', }
      file { [ '/var/www/virt/a', '/var/www/virt/b', ]: ensure => directory, }
      file { '/var/www/virt/a/index.html': ensure  => file, content => "Hello from a.virt\\n", }
      file { '/var/www/virt/b/index.html': ensure  => file, content => "Hello from b.virt\\n", }
    MANIFEST
    it 'configures a vhost with VirtualDocumentRoot' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    it 'answers to a.virt.example.com' do
      run_shell('/usr/bin/curl a.virt.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from a.virt\n")
      end
    end

    it 'answers to b.virt.example.com' do
      run_shell('/usr/bin/curl b.virt.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from b.virt\n")
      end
    end
  end

  context 'proxy_pass for alternative vhost' do
    it 'configures a local vhost and a proxy vhost' do
      apply_manifest(%(
        class { 'apache': default_vhost => false, }
        apache::vhost { 'localhost':
          docroot => '/var/www/local',
          ip      => '127.0.0.1',
          port    => '8888',
        }
        apache::listen { '*:80': }
        apache::vhost { 'proxy.example.com':
          docroot    => '/var/www',
          port       => '80',
          add_listen => false,
          proxy_pass => {
            'path' => '/',
            'url'  => 'http://localhost:8888/subdir/',
          },
        }
        host { 'proxy.example.com': ip => '127.0.0.1', }
        file { ['/var/www/local', '/var/www/local/subdir']: ensure => directory, }
        file { '/var/www/local/subdir/index.html':
          ensure  => file,
          content => "Hello from localhost\\n",
        }
                     ), catch_failures: true)
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    it 'gets a response from the back end #stdout' do
      run_shell('/usr/bin/curl --max-redirs 0 proxy.example.com:80') do |r|
        expect(r.stdout).to eq("Hello from localhost\n")
      end
    end
    it 'gets a response from the back end #exit_code' do
      run_shell('/usr/bin/curl --max-redirs 0 proxy.example.com:80') do |r|
        expect(r.exit_code).to eq(0)
      end
    end
  end

  context 'proxy_pass_match for alternative vhost' do
    it 'configures a local vhost and a proxy vhost' do
      apply_manifest(%(
        class { 'apache': default_vhost => false, }
        apache::vhost { 'localhost':
          docroot => '/var/www/local',
          ip      => '127.0.0.1',
          port    => '8888',
        }
        apache::listen { '*:80': }
        apache::vhost { 'proxy.example.com':
          docroot    => '/var/www',
          port       => '80',
          add_listen => false,
          proxy_pass_match => {
            'path' => '/',
            'url'  => 'http://localhost:8888/subdir/',
          },
        }
        host { 'proxy.example.com': ip => '127.0.0.1', }
        file { ['/var/www/local', '/var/www/local/subdir']: ensure => directory, }
        file { '/var/www/local/subdir/index.html':
          ensure  => file,
          content => "Hello from localhost\\n",
        }
                    ), catch_failures: true)
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    it 'gets a response from the back end #stdout' do
      run_shell('/usr/bin/curl --max-redirs 0 proxy.example.com:80') do |r|
        expect(r.stdout).to eq("Hello from localhost\n")
      end
    end
    it 'gets a response from the back end #exit_code' do
      run_shell('/usr/bin/curl --max-redirs 0 proxy.example.com:80') do |r|
        expect(r.exit_code).to eq(0)
      end
    end
  end

  describe 'ip_based' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot    => '/tmp',
        ip_based   => true,
        servername => 'test.server',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file(apache_hash['ports_file']) do
      it { is_expected.to be_file }
      it { is_expected.not_to contain 'NameVirtualHost test.server' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ServerName test.server' }
    end
  end

  describe 'ip_based and no servername' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot    => '/tmp',
        ip_based   => true,
        servername => '',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file(apache_hash['ports_file']) do
      it { is_expected.to be_file }
      it { is_expected.not_to contain 'NameVirtualHost test.server' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.not_to contain 'ServerName' }
    end
  end

  describe 'add_listen' do
    pp = <<-MANIFEST
      class { 'apache': default_vhost => false }
      host { 'testlisten.server': ip => '127.0.0.1' }
      apache::listen { '81': }
      apache::vhost { 'testlisten.server':
        docroot    => '/tmp',
        port       => '80',
        add_listen => false,
        servername => 'testlisten.server',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file(apache_hash['ports_file']) do
      it { is_expected.to be_file }
      it { is_expected.not_to contain 'Listen 80' }
      it { is_expected.to contain 'Listen 81' }
    end
  end

  describe 'docroot' do
    pp = <<-MANIFEST
      user { 'test_owner': ensure => present, }
      group { 'test_group': ensure => present, }
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot       => '/tmp/test',
        docroot_owner => 'test_owner',
        docroot_group => 'test_group',
        docroot_mode  => '0750',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file('/tmp/test') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'test_owner' }
      it { is_expected.to be_grouped_into 'test_group' }
      it { is_expected.to be_mode 750 }
    end
  end

  describe 'default_vhost' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot    => '/tmp',
        default_vhost => true,
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file(apache_hash['ports_file']) do
      it { is_expected.to be_file }
    end

    describe file("#{apache_hash['vhost_dir']}/10-test.server.conf") do
      it { is_expected.to be_file }
    end
  end

  describe 'parameter tests' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.itk': ip => '127.0.0.1' }
      apache::vhost { 'test.itk':
        docroot  => '/tmp',
        itk      => { user => 'nobody', group => 'nobody' }
      }
      host { 'test.custom_fragment': ip => '127.0.0.1' }
      apache::vhost { 'test.custom_fragment':
        docroot  => '/tmp',
        custom_fragment => inline_template('#weird test string'),
      }
      apache::vhost { 'test.without_priority_prefix':
        priority => false,
        docroot => '/tmp'
      }
      apache::vhost { 'test.ssl_protool':
        docroot      => '/tmp',
        ssl          => true,
        ssl_protocol => ['All', '-SSLv2'],
      }
      apache::vhost { 'test.block':
        docroot  => '/tmp',
        block    => 'scm',
      }
      apache::vhost { 'test.setenv_setenvif':
        docroot  => '/tmp',
        setenv   => ['TEST /test'],
        setenvif => ['Request_URI "\.gif$" object_is_image=gif']
      }
      apache::vhost { 'test.rewrite':
        docroot          => '/tmp',
        rewrites => [
          { comment => 'test',
            rewrite_cond => '%{HTTP_USER_AGENT} ^Lynx/ [OR]',
            rewrite_rule => ['^index\.html$ welcome.html'],
            rewrite_map  => ['lc int:tolower'],
          }
        ],
      }
      apache::vhost { 'test.request_headers':
        docroot          => '/tmp',
        request_headers  => ['append MirrorID "mirror 12"'],
      }
      apache::vhost { 'test.redirect':
        docroot          => '/tmp',
        redirect_source  => ['/images'],
        redirect_dest    => ['http://test.server/'],
        redirect_status  => ['permanent'],
      }
      apache::vhost { 'test.no_proxy_uris':
        docroot          => '/tmp',
        proxy_dest       => 'http://test2',
        no_proxy_uris    => [ 'http://test2/test' ],
      }
      apache::vhost { 'test.proxy':
        docroot    => '/tmp',
        proxy_dest => 'test2',
      }
      apache::vhost { 'test.scriptaliases':
        docroot    => '/tmp',
        scriptaliases => [{ alias => '/myscript', path  => '/usr/share/myscript', }],
      }
      apache::vhost { 'test.aliases':
        docroot    => '/tmp',
        aliases => [
          { alias       => '/image'    , path => '/ftp/pub/image' }   ,
          { scriptalias => '/myscript' , path => '/usr/share/myscript' }
        ],
      }
      apache::vhost { 'test.access_logs':
        docroot            => '/tmp',
        logroot            => '/tmp',
        access_logs => [
          {'file' => 'log1'},
          {'file' => 'log2', 'env' => 'admin' },
          {'file' => '/var/tmp/log3', 'format' => '%h %l'},
          {'syslog' => 'syslog' }
        ]
      }
      apache::vhost { 'test.access_log_env_var':
        docroot            => '/tmp',
        logroot            => '/tmp',
        access_log_syslog  => 'syslog',
        access_log_env_var => 'admin',
      }
      apache::vhost { 'test.access_log_format':
        docroot    => '/tmp',
        logroot    => '/tmp',
        access_log_syslog => 'syslog',
        access_log_format => '%h %l',
      }
      apache::vhost { 'test.logroot':
        docroot    => '/tmp',
        logroot    => '/tmp',
      }
      apache::vhost { 'test.override':
        docroot    => '/tmp',
        override   => ['All'],
      }
      apache::vhost { 'test.options':
        docroot    => '/tmp',
        options    => ['Indexes','FollowSymLinks', 'ExecCGI'],
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/25-test.itk.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'AssignUserId nobody nobody' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.custom_fragment.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain '#weird test string' }
    end
    describe file("#{apache_hash['vhost_dir']}/test.without_priority_prefix.conf") do
      it { is_expected.to be_file }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.ssl_protool.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'SSLProtocol  *All -SSLv2' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.block.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain '<DirectoryMatch .*\.(svn|git|bzr|hg|ht)/.*>' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.setenv_setenvif.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'SetEnv TEST /test' }
      it { is_expected.to contain 'SetEnvIf Request_URI "\.gif$" object_is_image=gif' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.rewrite.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain '#test' }
      it { is_expected.to contain 'RewriteCond %{HTTP_USER_AGENT} ^Lynx/ [OR]' }
      it { is_expected.to contain 'RewriteRule ^index.html$ welcome.html' }
      it { is_expected.to contain 'RewriteMap lc int:tolower' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.request_headers.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'append MirrorID "mirror 12"' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.redirect.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Redirect permanent /images http://test.server/' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.no_proxy_uris.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ProxyPass        http://test2/test !' }
      it { is_expected.to contain 'ProxyPass        / http://test2/' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.proxy.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ProxyPass        / test2/' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.scriptaliases.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ScriptAlias /myscript "/usr/share/myscript"' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.aliases.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Alias /image "/ftp/pub/image"' }
      it { is_expected.to contain 'ScriptAlias /myscript "/usr/share/myscript"' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.access_logs.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'CustomLog "/tmp/log1" combined' }
      it { is_expected.to contain 'CustomLog "/tmp/log2" combined env=admin' }
      it { is_expected.to contain 'CustomLog "/var/tmp/log3" "%h %l"' }
      it { is_expected.to contain 'CustomLog "syslog" combined' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.access_log_env_var.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'CustomLog "syslog" combined env=admin' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.access_log_format.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'CustomLog "syslog" "%h %l"' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.logroot.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain '  CustomLog "/tmp' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.override.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'AllowOverride All' }
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.options.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Options Indexes FollowSymLinks ExecCGI' }
    end
  end

  ['access', 'error'].each do |logtype|
    case logtype
    when 'access'
      logname = 'CustomLog'
    when 'error'
      logname = 'ErrorLog'
    end

    describe "#{logtype}_log" do
      pp = <<-MANIFEST
        class { 'apache': }
        host { 'test.server': ip => '127.0.0.1' }
        apache::vhost { 'test.server':
          docroot    => '/tmp',
          logroot    => '/tmp',
          #{logtype}_log => false,
        }
      MANIFEST
      it 'applies cleanly' do
        apply_manifest(pp, catch_failures: true)
      end

      describe file("#{apache_hash['vhost_dir']}/25-test.server.conf") do
        it { is_expected.to be_file }
        it { is_expected.not_to contain "  #{logname} \"/tmp" }
      end
    end

    describe "#{logtype}_log_pipe" do
      pp = <<-MANIFEST
        class { 'apache': }
        host { 'test.server': ip => '127.0.0.1' }
        apache::vhost { 'test.server':
          docroot    => '/tmp',
          logroot    => '/tmp',
          #{logtype}_log_pipe => '|/bin/sh',
        }
      MANIFEST
      it 'applies cleanly' do
        apply_manifest(pp, catch_failures: true)
      end

      describe file("#{apache_hash['vhost_dir']}/25-test.server.conf") do
        it { is_expected.to be_file }
        it { is_expected.to contain "  #{logname} \"|/bin/sh" }
      end
    end

    describe "#{logtype}_log_syslog" do
      pp = <<-MANIFEST
        class { 'apache': }
        host { 'test.server': ip => '127.0.0.1' }
        apache::vhost { 'test.server':
          docroot    => '/tmp',
          logroot    => '/tmp',
          #{logtype}_log_syslog => 'syslog',
        }
      MANIFEST
      it 'applies cleanly' do
        apply_manifest(pp, catch_failures: true)
      end

      describe file("#{apache_hash['vhost_dir']}/25-test.server.conf") do
        it { is_expected.to be_file }
        it { is_expected.to contain "  #{logname} \"syslog\"" }
      end
    end
  end

  describe 'actions' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot => '/tmp',
        action  => 'php-fastcgi',
      }
    MANIFEST
    it 'applies cleanly' do
      pp += "\nclass { 'apache::mod::actions': }" if os[:family] =~ %r{debian|suse}
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Action php-fastcgi /cgi-bin virtual' }
    end
  end

  describe 'suphp' do
    pp = <<-MANIFEST
      class { 'apache': service_ensure => stopped, }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot          => '/tmp',
        suphp_addhandler => '#{apache_hash['suphp_handler']}',
        suphp_engine     => 'on',
        suphp_configpath => '#{apache_hash['suphp_configpath']}',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain "suPHP_AddHandler #{apache_hash['suphp_handler']}" }
      it { is_expected.to contain 'suPHP_Engine on' }
      it { is_expected.to contain "suPHP_ConfigPath \"#{apache_hash['suphp_configpath']}\"" }
    end
  end

  describe 'directory rewrite rules' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      if ! defined(Class['apache::mod::rewrite']) {
        include ::apache::mod::rewrite
      }
      apache::vhost { 'test.server':
        docroot      => '/tmp',
        directories  => [
          {
          path => '/tmp',
          rewrites => [
            {
            comment => 'Permalink Rewrites',
            rewrite_base => '/',
            },
            { rewrite_rule => [ '^index\\.php$ - [L]' ] },
            { rewrite_cond => [
              '%{REQUEST_FILENAME} !-f',
              '%{REQUEST_FILENAME} !-d',                                                                                             ],                                                                                                                     rewrite_rule => [ '. /index.php [L]' ],                                                                              }
            ],
          },
          ],
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain '#Permalink Rewrites' }
      it { is_expected.to contain 'RewriteEngine On' }
      it { is_expected.to contain 'RewriteBase /' }
      it { is_expected.to contain 'RewriteRule ^index\.php$ - [L]' }
      it { is_expected.to contain 'RewriteCond %{REQUEST_FILENAME} !-f' }
      it { is_expected.to contain 'RewriteCond %{REQUEST_FILENAME} !-d' }
      it { is_expected.to contain 'RewriteRule . /index.php [L]' }
    end
  end

  describe 'wsgi' do
    context 'filter on OS', unless: (os[:family] =~ %r{sles|redhat}) do
      pp = <<-MANIFEST
      class { 'apache': }
      class { 'apache::mod::wsgi': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot                     => '/tmp',
        wsgi_application_group      => '%{GLOBAL}',
        wsgi_daemon_process         => { 'wsgi' => { 'python-home' => '/usr' }, 'foo' => {} },
        wsgi_daemon_process_options => {processes => '2'},
        wsgi_import_script          => '/test1',
        wsgi_import_script_options  => { application-group => '%{GLOBAL}', process-group => 'wsgi' },
        wsgi_process_group          => 'nobody',
        wsgi_script_aliases         => { '/test' => '/test1' },
        wsgi_script_aliases_match   => { '/test/([^/*])' => '/test1' },
        wsgi_pass_authorization     => 'On',
        wsgi_chunked_request        => 'On',
      }
      MANIFEST
      it 'import_script applies cleanly' do
        apply_manifest(pp, catch_failures: true)
      end
      describe file("#{apache_hash['vhost_dir']}/25-test.server.conf") do
        it { is_expected.to be_file }
        it { is_expected.to contain 'WSGIApplicationGroup %{GLOBAL}' }
        it { is_expected.to contain 'WSGIDaemonProcess foo' }
        it { is_expected.to contain 'WSGIDaemonProcess wsgi python-home=/usr' }
        it { is_expected.to contain 'WSGIImportScript /test1 application-group=%{GLOBAL} process-group=wsgi' }
        it { is_expected.to contain 'WSGIProcessGroup nobody' }
        it { is_expected.to contain 'WSGIScriptAlias /test "/test1"' }
        it { is_expected.to contain 'WSGIPassAuthorization On' }
        it { is_expected.to contain 'WSGIChunkedRequest On' }
      end
    end
  end

  describe 'additional_includes' do
    pp = <<-MANIFEST
      if $::osfamily == 'RedHat' and "$::selinux" == "true" {
        $semanage_package = $::operatingsystemmajrelease ? {
          '5'     => 'policycoreutils',
          default => 'policycoreutils-python',
        }
        exec { 'set_apache_defaults':
          command => 'semanage fcontext -a -t httpd_sys_content_t "/apache_spec(/.*)?"',
          path    => '/bin:/usr/bin/:/sbin:/usr/sbin',
          require => Package[$semanage_package],
        }
        package { $semanage_package: ensure => installed }
        exec { 'restorecon_apache':
          command => 'restorecon -Rv /apache_spec',
          path    => '/bin:/usr/bin/:/sbin:/usr/sbin',
          before  => Service['httpd'],
          require => Class['apache'],
        }
      }
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      file { '/apache_spec': ensure => directory, }
      file { '/apache_spec/include': ensure => present, content => '#additional_includes' }
      apache::vhost { 'test.server':
        docroot             => '/apache_spec',
        additional_includes => '/apache_spec/include',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Include "/apache_spec/include"' }
    end
  end

  describe 'shibboleth parameters', if: (os[:family] == 'debian' && os[:release] != '7') do
    # Debian 7 is too old for ShibCompatValidUser
    pp = <<-MANIFEST
      class { 'apache': }
      class { 'apache::mod::shib': }
      apache::vhost { 'test.server':
        port    => '80',
        docroot => '/var/www/html',
        shib_compat_valid_user => 'On'
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end
    describe file("#{apache_hash['vhost_dir']}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ShibCompatValidUser On' }
    end
  end
end
