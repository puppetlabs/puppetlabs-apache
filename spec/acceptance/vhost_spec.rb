require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache::vhost define' do
  context 'no default vhosts' do
    pp = <<-MANIFEST
      class { 'apache':
        default_vhost => false,
        default_ssl_vhost => false,
        service_ensure => stopped,
      }
      if ($::osfamily == 'Suse') {
        exec { '/usr/bin/gensslcert':
          require => Class['apache'],
        }
      }
    MANIFEST
    it 'creates no default vhosts' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/15-default.conf") do
      it { is_expected.not_to be_file }
    end

    describe file("#{$vhost_dir}/15-default-ssl.conf") do
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

    describe file("#{$vhost_dir}/15-default.conf") do
      it { is_expected.to contain '<VirtualHost \*:80>' }
    end

    describe file("#{$vhost_dir}/15-default-ssl.conf") do
      it { is_expected.not_to be_file }
    end
  end

  context 'default vhost with ssl' do
    pp = <<-MANIFEST
      file { '#{$run_dir}':
        ensure  => 'directory',
        recurse => true,
      }

      class { 'apache':
        default_ssl_vhost => true,
        require => File['#{$run_dir}'],
      }
    MANIFEST
    it 'creates default vhost configs' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/15-default.conf") do
      it { is_expected.to contain '<VirtualHost \*:80>' }
    end

    describe file("#{$vhost_dir}/15-default-ssl.conf") do
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

    describe file("#{$vhost_dir}/25-first.example.com.conf") do
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

    describe file("#{$vhost_dir}/25-proxy.example.com.conf") do
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
        docroot => '#{$docroot}/proxy',
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

    describe file("#{$vhost_dir}/25-proxy.example.com.conf") do
      it { is_expected.to contain '<VirtualHost \*:80>' }
      it { is_expected.to contain 'ServerName proxy.example.com' }
      it { is_expected.to contain 'ProxyPassMatch /foo http://backend-foo/' }
      it { is_expected.to contain 'ProxyPreserveHost On' }
      it { is_expected.to contain 'ProxyErrorOverride On' }
      it { is_expected.not_to contain 'ProxyAddHeaders' }
      it { is_expected.not_to contain "<Proxy \*>" }
    end
  end

  context 'new vhost on port 80' do
    pp = <<-MANIFEST
      class { 'apache': }
      apache::vhost { 'first.example.com':
        port    => '80',
        docroot => '/var/www/first',
      }
      host { 'first.example.com': ip => '127.0.0.1', }
      file { '/var/www/first/index.html':
        ensure  => file,
        content => "Hello from first\\n",
      }
      apache::vhost { 'second.example.com':
        port    => '80',
        docroot => '/var/www/second',
      }
      host { 'second.example.com': ip => '127.0.0.1', }
      file { '/var/www/second/index.html':
        ensure  => file,
        content => "Hello from second\\n",
      }
    MANIFEST
    it 'configures two apache vhosts' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    it 'answers to first.example.com' do
      shell('/usr/bin/curl first.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from first\n")
      end
    end

    it 'answers to second.example.com' do
      shell('/usr/bin/curl second.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from second\n")
      end
    end
  end

  context 'new vhost with multiple IP addresses on port 80' do
    pp = <<-MANIFEST
      class { 'apache':
        default_vhost => false,
      }
      apache::vhost { 'example.com':
        port     => '80',
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
    it 'configures one apache vhost with 2 ip addresses' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe file("#{$vhost_dir}/25-example.com.conf") do
      it { is_expected.to contain '<VirtualHost 127.0.0.1:80 127.0.0.2:80>' }
      it { is_expected.to contain 'ServerName example.com' }
    end

    describe file($ports_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Listen 127.0.0.1:80' }
      it { is_expected.to contain 'Listen 127.0.0.2:80' }
      it { is_expected.not_to contain 'NameVirtualHost 127.0.0.1:80' }
      it { is_expected.not_to contain 'NameVirtualHost 127.0.0.2:80' }
    end

    it 'answers to host1.example.com' do
      shell('/usr/bin/curl host1.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end

    it 'answers to host2.example.com' do
      shell('/usr/bin/curl host2.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end
  end

  context 'new vhost with multiple ports on 1 IP address' do
    pp = <<-MANIFEST
      class { 'apache':
        default_vhost => false,
      }
      apache::vhost { 'example.com':
        port     => ['80','8080'],
        ip       => '127.0.0.1',
        ip_based => true,
        docroot  => '/var/www/html',
      }
      host { 'host1.example.com': ip => '127.0.0.1', }
      file { '/var/www/html/index.html':
        ensure  => file,
        content => "Hello from vhost\\n",
      }
    MANIFEST
    it 'configures one apache vhost with 2 ports' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe file("#{$vhost_dir}/25-example.com.conf") do
      it { is_expected.to contain '<VirtualHost 127.0.0.1:80 127.0.0.1:8080>' }
      it { is_expected.to contain 'ServerName example.com' }
    end

    describe file($ports_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Listen 127.0.0.1:80' }
      it { is_expected.to contain 'Listen 127.0.0.1:8080' }
      it { is_expected.not_to contain 'NameVirtualHost 127.0.0.1:80' }
      it { is_expected.not_to contain 'NameVirtualHost 127.0.0.1:8080' }
    end

    it 'answers to host1.example.com port 80' do
      shell('/usr/bin/curl host1.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end

    it 'answers to host1.example.com port 8080' do
      shell('/usr/bin/curl host1.example.com:8080', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
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

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe file("#{$vhost_dir}/25-example.com.conf") do
      it { is_expected.to contain '<VirtualHost 127.0.0.1:80 127.0.0.1:8080 127.0.0.2:80 127.0.0.2:8080>' }
      it { is_expected.to contain 'ServerName example.com' }
    end

    describe file($ports_file) do
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
      shell('/usr/bin/curl host1.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end

    it 'answers to host1.example.com port 8080' do
      shell('/usr/bin/curl host1.example.com:8080', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end

    it 'answers to host2.example.com port 80' do
      shell('/usr/bin/curl host2.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end

    it 'answers to host2.example.com port 8080' do
      shell('/usr/bin/curl host2.example.com:8080', acceptable_exit_codes: 0) do |r|
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

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe file("#{$vhost_dir}/25-example.com.conf") do
      it { is_expected.to contain '<VirtualHost [::1]:80>' }
      it { is_expected.to contain 'ServerName example.com' }
    end

    describe file($ports_file) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Listen [::1]:80' }
      it { is_expected.not_to contain 'NameVirtualHost [::1]:80' }
    end

    it 'answers to ipv6.example.com' do
      shell('/usr/bin/curl ipv6.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from vhost\n")
      end
    end
  end

  context 'apache_directories' do
    describe 'readme example, adapted' do
      pp = <<-MANIFEST
        class { 'apache': }

        if versioncmp($apache_version, '2.4') >= 0 {
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
      it 'configures a vhost with Files' do
        apply_manifest(pp, catch_failures: true)
      end

      describe service($service_name) do
        if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
          pending 'Should be enabled - Bug 760616 on Debian 8'
        else
          it { is_expected.to be_enabled }
        end
        it { is_expected.to be_running }
      end

      it 'answers to files.example.net #stdout' do
        expect(shell('/usr/bin/curl -sSf files.example.net:80/index.html').stdout).to eq("Hello World\n")
      end
      it 'answers to files.example.net #stderr' do
        expect(shell('/usr/bin/curl -sSf files.example.net:80/index.html.bak', acceptable_exit_codes: 22).stderr).to match(%r{curl: \(22\) The requested URL returned error: 403})
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

      describe service($service_name) do
        if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
          pending 'Should be enabled - Bug 760616 on Debian 8'
        else
          it { is_expected.to be_enabled }
        end
        it { is_expected.to be_running }
      end

      it 'answers to files.example.net #stdout' do
        expect(shell('/usr/bin/curl -sSf files.example.net:80/').stdout).to eq("Hello World\n")
      end
      it 'answers to files.example.net #stdout foo' do
        expect(shell('/usr/bin/curl -sSf files.example.net:80/foo/').stdout).to eq("Hello Foo\n")
      end
      it 'answers to files.example.net #stderr' do
        expect(shell('/usr/bin/curl -sSf files.example.net:80/private.html', acceptable_exit_codes: 22).stderr).to match(%r{curl: \(22\) The requested URL returned error: 403})
      end
      it 'answers to files.example.net #stdout bar' do
        expect(shell('/usr/bin/curl -sSf files.example.net:80/bar/bar.html').stdout).to eq("Hello Bar\n")
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

      describe service($service_name) do
        if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
          pending 'Should be enabled - Bug 760616 on Debian 8'
        else
          it { is_expected.to be_enabled }
        end
        it { is_expected.to be_running }
      end

      it 'answers to files.example.net #stdout' do
        expect(shell('/usr/bin/curl -sSf files.example.net:80/index.html').stdout).to eq("Hello World\n")
      end
      it 'answers to files.example.net #stdout regex' do
        expect(shell('/usr/bin/curl -sSf files.example.net:80/server-status?auto').stdout).to match(%r{Scoreboard: })
      end
    end

    describe 'Satisfy and Auth directive', unless: $apache_version == '2.4' do
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

      describe service($service_name) do
        if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
          pending 'Should be enabled - Bug 760616 on Debian 8'
        else
          it { is_expected.to be_enabled }
        end
        it { is_expected.to be_running }

        it 'answers to files.example.net' do
          shell('/usr/bin/curl -sSf files.example.net:80/foo/index.html', acceptable_exit_codes: 22).stderr.should match(%r{curl: \(22\) The requested URL returned error: 401})
          shell('/usr/bin/curl -sSf -u login:password files.example.net:80/foo/index.html').stdout.should eq("Hello World\n")
          shell('/usr/bin/curl -sSf files.example.net:80/bar/index.html').stdout.should eq("Hello World\n")
          shell('/usr/bin/curl -sSf -u login:password files.example.net:80/bar/index.html').stdout.should eq("Hello World\n")
          shell('/usr/bin/curl -sSf files.example.net:80/baz/index.html', acceptable_exit_codes: 22).stderr.should match(%r{curl: \(22\) The requested URL returned error: 401})
          shell('/usr/bin/curl -sSf -u login:password files.example.net:80/baz/index.html').stdout.should eq("Hello World\n")
        end
      end
    end
  end

  case fact('lsbdistcodename')
  when 'precise', 'wheezy'
    context 'vhost FallbackResource example' do
      pp = <<-MANIFEST
        class { 'apache': }
        apache::vhost { 'fallback.example.net':
          docroot         => '/var/www/fallback',
          fallbackresource => '/index.html'
        }
        file { '/var/www/fallback/index.html':
          ensure  => file,
          content => "Hello World\\n",
        }
        host { 'fallback.example.net': ip => '127.0.0.1', }
      MANIFEST
      it 'configures a vhost with FallbackResource' do
        apply_manifest(pp, catch_failures: true)
      end

      describe service($service_name) do
        if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
          pending 'Should be enabled - Bug 760616 on Debian 8'
        else
          it { is_expected.to be_enabled }
        end
        it { is_expected.to be_running }
      end

      it 'answers to fallback.example.net' do
        shell('/usr/bin/curl fallback.example.net:80/Does/Not/Exist') do |r|
          expect(r.stdout).to eq("Hello World\n")
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

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    it 'answers to a.virt.example.com' do
      shell('/usr/bin/curl a.virt.example.com:80', acceptable_exit_codes: 0) do |r|
        expect(r.stdout).to eq("Hello from a.virt\n")
      end
    end

    it 'answers to b.virt.example.com' do
      shell('/usr/bin/curl b.virt.example.com:80', acceptable_exit_codes: 0) do |r|
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

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    it 'gets a response from the back end #stdout' do
      shell('/usr/bin/curl --max-redirs 0 proxy.example.com:80') do |r|
        expect(r.stdout).to eq("Hello from localhost\n")
      end
    end
    it 'gets a response from the back end #exit_code' do
      shell('/usr/bin/curl --max-redirs 0 proxy.example.com:80') do |r|
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

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    it 'gets a response from the back end #stdout' do
      shell('/usr/bin/curl --max-redirs 0 proxy.example.com:80') do |r|
        expect(r.stdout).to eq("Hello from localhost\n")
      end
    end
    it 'gets a response from the back end #exit_code' do
      shell('/usr/bin/curl --max-redirs 0 proxy.example.com:80') do |r|
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

    describe file($ports_file) do
      it { is_expected.to be_file }
      it { is_expected.not_to contain 'NameVirtualHost test.server' }
    end
    describe file("#{$vhost_dir}/25-test.server.conf") do
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

    describe file($ports_file) do
      it { is_expected.to be_file }
      it { is_expected.not_to contain 'NameVirtualHost test.server' }
    end
    describe file("#{$vhost_dir}/25-test.server.conf") do
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

    describe file($ports_file) do
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

    describe file($ports_file) do
      it { is_expected.to be_file }
      if fact('osfamily') == 'RedHat' && fact('operatingsystemmajrelease') == '7' ||
         fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') =~ %r{(14\.04|16\.04)} ||
         fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8' ||
         fact('operatingsystem') == 'SLES' && fact('operatingsystemrelease') >= '12'
        it { is_expected.not_to contain 'NameVirtualHost test.server' }
      else
        it { is_expected.to contain 'NameVirtualHost test.server' }
      end
    end

    describe file("#{$vhost_dir}/10-test.server.conf") do
      it { is_expected.to be_file }
    end
  end

  describe 'options' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot    => '/tmp',
        options    => ['Indexes','FollowSymLinks', 'ExecCGI'],
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Options Indexes FollowSymLinks ExecCGI' }
    end
  end

  describe 'override' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot    => '/tmp',
        override   => ['All'],
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'AllowOverride All' }
    end
  end

  describe 'logroot' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot    => '/tmp',
        logroot    => '/tmp',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain '  CustomLog "/tmp' }
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

      describe file("#{$vhost_dir}/25-test.server.conf") do
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

      describe file("#{$vhost_dir}/25-test.server.conf") do
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

      describe file("#{$vhost_dir}/25-test.server.conf") do
        it { is_expected.to be_file }
        it { is_expected.to contain "  #{logname} \"syslog\"" }
      end
    end
  end

  describe 'access_log_format' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot    => '/tmp',
        logroot    => '/tmp',
        access_log_syslog => 'syslog',
        access_log_format => '%h %l',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'CustomLog "syslog" "%h %l"' }
    end
  end

  describe 'access_log_env_var' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot            => '/tmp',
        logroot            => '/tmp',
        access_log_syslog  => 'syslog',
        access_log_env_var => 'admin',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'CustomLog "syslog" combined env=admin' }
    end
  end

  describe 'multiple access_logs' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot            => '/tmp',
        logroot            => '/tmp',
        access_logs => [
          {'file' => 'log1'},
          {'file' => 'log2', 'env' => 'admin' },
          {'file' => '/var/tmp/log3', 'format' => '%h %l'},
          {'syslog' => 'syslog' }
        ]
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'CustomLog "/tmp/log1" combined' }
      it { is_expected.to contain 'CustomLog "/tmp/log2" combined env=admin' }
      it { is_expected.to contain 'CustomLog "/var/tmp/log3" "%h %l"' }
      it { is_expected.to contain 'CustomLog "syslog" combined' }
    end
  end

  describe 'aliases' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot    => '/tmp',
        aliases => [
          { alias       => '/image'    , path => '/ftp/pub/image' }   ,
          { scriptalias => '/myscript' , path => '/usr/share/myscript' }
        ],
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Alias /image "/ftp/pub/image"' }
      it { is_expected.to contain 'ScriptAlias /myscript "/usr/share/myscript"' }
    end
  end

  describe 'scriptaliases' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot    => '/tmp',
        scriptaliases => [{ alias => '/myscript', path  => '/usr/share/myscript', }],
      }
  MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ScriptAlias /myscript "/usr/share/myscript"' }
    end
  end

  describe 'proxy' do
    pp = <<-MANIFEST
      class { 'apache': service_ensure => stopped, }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot    => '/tmp',
        proxy_dest => 'test2',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ProxyPass        / test2/' }
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
      pp += "\nclass { 'apache::mod::actions': }" if fact('osfamily') == 'Debian' || fact('osfamily') == 'Suse'
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
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
        suphp_addhandler => '#{$suphp_handler}',
        suphp_engine     => 'on',
        suphp_configpath => '#{$suphp_configpath}',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain "suPHP_AddHandler #{$suphp_handler}" }
      it { is_expected.to contain 'suPHP_Engine on' }
      it { is_expected.to contain "suPHP_ConfigPath \"#{$suphp_configpath}\"" }
    end
  end

  describe 'rack_base_uris' do
    unless fact('osfamily') == 'RedHat' || fact('operatingsystem') == 'SLES'
      test = -> do
        pp = <<-MANIFEST
          class { 'apache': }
          host { 'test.server': ip => '127.0.0.1' }
          apache::vhost { 'test.server':
            docroot          => '/tmp',
            rack_base_uris  => ['/test'],
          }
        MANIFEST
        it 'applies cleanly' do
          apply_manifest(pp, catch_failures: true)
        end
        test.call
      end
    end
  end

  describe 'no_proxy_uris' do
    pp = <<-MANIFEST
      class { 'apache': service_ensure => stopped, }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot          => '/tmp',
        proxy_dest       => 'http://test2',
        no_proxy_uris    => [ 'http://test2/test' ],
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ProxyPass        http://test2/test !' }
      it { is_expected.to contain 'ProxyPass        / http://test2/' }
    end
  end

  describe 'redirect' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot          => '/tmp',
        redirect_source  => ['/images'],
        redirect_dest    => ['http://test.server/'],
        redirect_status  => ['permanent'],
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Redirect permanent /images http://test.server/' }
    end
  end

  describe 'request_headers' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot          => '/tmp',
        request_headers  => ['append MirrorID "mirror 12"'],
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'append MirrorID "mirror 12"' }
    end
  end

  describe 'rewrite rules' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot          => '/tmp',
        rewrites => [
          { comment => 'test',
            rewrite_cond => '%{HTTP_USER_AGENT} ^Lynx/ [OR]',
            rewrite_rule => ['^index\.html$ welcome.html'],
            rewrite_map  => ['lc int:tolower'],
          }
        ],
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain '#test' }
      it { is_expected.to contain 'RewriteCond %{HTTP_USER_AGENT} ^Lynx/ [OR]' }
      it { is_expected.to contain 'RewriteRule ^index.html$ welcome.html' }
      it { is_expected.to contain 'RewriteMap lc int:tolower' }
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

    describe file("#{$vhost_dir}/25-test.server.conf") do
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

  describe 'setenv/setenvif' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot  => '/tmp',
        setenv   => ['TEST /test'],
        setenvif => ['Request_URI "\.gif$" object_is_image=gif']
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'SetEnv TEST /test' }
      it { is_expected.to contain 'SetEnvIf Request_URI "\.gif$" object_is_image=gif' }
    end
  end

  describe 'block' do
    pp = <<-MANIFEST
        class { 'apache': }
        host { 'test.server': ip => '127.0.0.1' }
        apache::vhost { 'test.server':
          docroot  => '/tmp',
          block    => 'scm',
        }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain '<DirectoryMatch .*\.(svn|git|bzr|hg|ht)/.*>' }
    end
  end

  describe 'wsgi' do
    context 'on lucid', if: fact('lsbdistcodename') == 'lucid' do
      pp = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::wsgi': }
        host { 'test.server': ip => '127.0.0.1' }
        apache::vhost { 'test.server':
          docroot                     => '/tmp',
          wsgi_application_group      => '%{GLOBAL}',
          wsgi_daemon_process         => 'wsgi',
          wsgi_daemon_process_options => {processes => '2'},
          wsgi_process_group          => 'nobody',
          wsgi_script_aliases         => { '/test' => '/test1' },
          wsgi_script_aliases_match   => { '/test/([^/*])' => '/test1' },
          wsgi_pass_authorization     => 'On',
        }
      MANIFEST
      it 'import_script applies cleanly' do
        apply_manifest(pp, catch_failures: true)
      end
    end

    context 'on everything but lucid', unless: (fact('lsbdistcodename') == 'lucid' || fact('operatingsystem') == 'SLES') do
      pp = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::wsgi': }
        host { 'test.server': ip => '127.0.0.1' }
        apache::vhost { 'test.server':
          docroot                     => '/tmp',
          wsgi_application_group      => '%{GLOBAL}',
          wsgi_daemon_process         => 'wsgi',
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

      describe file("#{$vhost_dir}/25-test.server.conf") do
        it { is_expected.to be_file }
        it { is_expected.to contain 'WSGIApplicationGroup %{GLOBAL}' }
        it { is_expected.to contain 'WSGIDaemonProcess wsgi processes=2' }
        it { is_expected.to contain 'WSGIImportScript /test1 application-group=%{GLOBAL} process-group=wsgi' }
        it { is_expected.to contain 'WSGIProcessGroup nobody' }
        it { is_expected.to contain 'WSGIScriptAlias /test "/test1"' }
        it { is_expected.to contain 'WSGIPassAuthorization On' }
        it { is_expected.to contain 'WSGIChunkedRequest On' }
      end
    end
  end

  describe 'custom_fragment' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot  => '/tmp',
        custom_fragment => inline_template('#weird test string'),
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain '#weird test string' }
    end
  end

  describe 'itk' do
    pp = <<-MANIFEST
      class { 'apache': }
      host { 'test.server': ip => '127.0.0.1' }
      apache::vhost { 'test.server':
        docroot  => '/tmp',
        itk      => { user => 'nobody', group => 'nobody' }
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'AssignUserId nobody nobody' }
    end
  end

  # Limit testing to Debian, since Centos does not have fastcgi package.
  case fact('osfamily')
  when 'Debian'
    describe 'fastcgi' do
      pp_one = <<-MANIFEST
        $_os = $::operatingsystem

        if $_os == 'Ubuntu' {
          $_location = "http://archive.ubuntu.com/ubuntu/"
          $_security_location = "http://archive.ubuntu.com/ubuntu/"
          $_release = $::lsbdistcodename
          $_release_security = "${_release}-security"
          $_repos = "main universe multiverse"
        } else {
          $_location = "http://httpredir.debian.org/debian/"
          $_security_location = "http://security.debian.org/"
          $_release = $::lsbdistcodename
          $_release_security = "${_release}/updates"
          $_repos = "main contrib non-free"
        }

        include ::apt
        apt::source { "${_os}_${_release}":
          location    => $_location,
          release     => $_release,
          repos       => $_repos,
        }

        apt::source { "${_os}_${_release}-updates":
          location    => $_location,
          release     => "${_release}-updates",
          repos       => $_repos,
        }

        apt::source { "${_os}_${_release}-security":
          location    => $_security_location,
          release     => $_release_security,
          repos       => $_repos,
        }
      MANIFEST
      pp_two = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::fastcgi': }
        host { 'test.server': ip => '127.0.0.1' }
        apache::vhost { 'test.server':
          docroot        => '/tmp',
          fastcgi_server => 'localhost',
          fastcgi_socket => '/tmp/fast/1234',
          fastcgi_dir    => '/tmp/fast',
        }
      MANIFEST
      it 'applies cleanly' do
        # apt-get update may not run clean here. Should be OK.
        apply_manifest(pp_one, catch_failures: false)

        apply_manifest(pp_two, catch_failures: true, acceptable_exit_codes: [0, 2])
      end

      describe file("#{$vhost_dir}/25-test.server.conf") do
        it { is_expected.to be_file }
        it { is_expected.to contain 'FastCgiExternalServer localhost -socket /tmp/fast/1234' }
        it { is_expected.to contain '<Directory "/tmp/fast">' }
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

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Include "/apache_spec/include"' }
    end
  end

  describe 'virtualhost without priority prefix' do
    pp = <<-MANIFEST
      class { 'apache': }
      apache::vhost { 'test.server':
        priority => false,
        docroot => '/tmp'
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/test.server.conf") do
      it { is_expected.to be_file }
    end
  end

  describe 'SSLProtocol directive' do
    pp = <<-MANIFEST
      class { 'apache': }
      apache::vhost { 'test.server':
        docroot      => '/tmp',
        ssl          => true,
        ssl_protocol => ['All', '-SSLv2'],
      }
      apache::vhost { 'test2.server':
        docroot      => '/tmp',
        ssl          => true,
        ssl_protocol => 'All -SSLv2',
      }
    MANIFEST
    it 'applies cleanly' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'SSLProtocol  *All -SSLv2' }
    end

    describe file("#{$vhost_dir}/25-test2.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'SSLProtocol  *All -SSLv2' }
    end
  end

  describe 'shibboleth parameters', if: (fact('osfamily') == 'Debian' && fact('operatingsystemmajrelease') != '7') do
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
    describe file("#{$vhost_dir}/25-test.server.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ShibCompatValidUser On' }
    end
  end
end
