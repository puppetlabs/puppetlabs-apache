require 'spec_helper_acceptance'

describe 'apache::vhost define' do
  case fact('osfamily')
  when 'RedHat'
    vhost_dir = '/etc/httpd/conf.d'
    package_name = 'httpd'
    service_name = 'httpd'
  when 'FreeBSD'
    vhost_dir = '/usr/local/etc/apache22/Vhosts'
    package_name = 'apache22'
    service_name = 'apache22'
  when 'Debian'
    vhost_dir = '/etc/apache2/sites-enabled'
    package_name = 'apache2'
    service_name = 'apache2'
  end

  context "default vhost without ssl" do
    it 'should create a default vhost config' do
      pp = <<-EOS
        class { 'apache': }
      EOS

      apply_manifest(pp, :catch_failures => true)
    end

    describe file("#{vhost_dir}/15-default.conf") do
      it { should contain '<VirtualHost \*:80>' }
    end

    describe file("#{vhost_dir}/15-default-ssl.conf") do
      it { should_not be_file }
    end
  end

  context 'default vhost with ssl' do
    it 'should create default vhost configs' do
      pp = <<-EOS
        class { 'apache':
          default_ssl_vhost => true,
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe file("#{vhost_dir}/15-default.conf") do
      it { should contain '<VirtualHost \*:80>' }
    end

    describe file("#{vhost_dir}/15-default-ssl.conf") do
      it { should contain '<VirtualHost \*:443>' }
      it { should contain "SSLEngine on" }
    end
  end

  context 'new vhost on port 80' do
    it 'should configure an apache vhost' do
      pp = <<-EOS
        class { 'apache': }
        apache::vhost { 'first.example.com':
          port    => '80',
          docroot => '/var/www/first',
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe file("#{vhost_dir}/25-first.example.com.conf") do
      it { should contain '<VirtualHost \*:80>' }
      it { should contain "ServerName first.example.com" }
    end
  end

  context 'new proxy vhost on port 80' do
    it 'should configure an apache proxy vhost' do
      pp = <<-EOS
        class { 'apache': }
        apache::vhost { 'proxy.example.com':
          port    => '80',
          docroot => '/var/www/proxy',
          proxy_pass => [
            { 'path' => '/foo', 'url' => 'http://backend-foo/'},
          ],
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe file("#{vhost_dir}/25-proxy.example.com.conf") do
      it { should contain '<VirtualHost \*:80>' }
      it { should contain "ServerName proxy.example.com" }
      it { should contain "ProxyPass" }
      it { should_not contain "<Proxy \*>" }
    end
  end

  context 'new vhost on port 80' do
    it 'should configure two apache vhosts' do
      pp = <<-EOS
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
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    it 'should answer to first.example.com' do
      shell("/usr/bin/curl first.example.com:80", {:acceptable_exit_codes => 0}) do |r|
        r.stdout.should == "Hello from first\n"
      end
    end

    it 'should answer to second.example.com' do
      shell("/usr/bin/curl second.example.com:80", {:acceptable_exit_codes => 0}) do |r|
        r.stdout.should == "Hello from second\n"
      end
    end
  end

  context 'apache_directories readme example, adapted' do
    it 'should configure a vhost with Files' do
      pp = <<-EOS
        class { 'apache': }
        apache::vhost { 'files.example.net':
          docroot     => '/var/www/files',
          directories => [
            { path => '~ (\.swp|\.bak|~)$', 'provider' => 'files', 'deny' => 'from all' },
          ],
        }
        file { '/var/www/files/index.html.bak':
          ensure  => file,
          content => "Hello World\\n",
        }
        host { 'files.example.net': ip => '127.0.0.1', }
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    it 'should answer to files.example.net' do
      shell("/usr/bin/curl -sSf files.example.net:80/index.html.bak", {:acceptable_exit_codes => 22}).stderr.should =~ /curl: \(22\) The requested URL returned error: 403/
    end

  end

  case fact('lsbdistcodename')
  when 'precise', 'wheezy'
    context 'vhost fallbackresouce example' do
      it 'should configure a vhost with Fallbackresource' do
        pp = <<-EOS
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
        EOS
        apply_manifest(pp, :catch_failures => true)
      end

      describe service(service_name) do
        it { should be_enabled }
        it { should be_running }
      end

      it 'should answer to fallback.example.net' do
        shell("/usr/bin/curl fallback.example.net:80/Does/Not/Exist") do |r|
          r.stdout.should == "Hello World\n"
        end
      end

    end
  else
    # The current stable RHEL release (6.4) comes with Apache httpd 2.2.15
    # That was released March 6, 2010.
    # FallbackResource was backported to 2.2.16, and released July 25, 2010.
    # Ubuntu Lucid (10.04) comes with apache2 2.2.14, released October 3, 2009.
    # https://svn.apache.org/repos/asf/httpd/httpd/branches/2.2.x/STATUS
  end

  context 'virtual_docroot hosting separate sites' do
    it 'should configure a vhost with VirtualDocumentRoot' do
      pp = <<-EOS
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
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    it 'should answer to a.virt.example.com' do
      shell("/usr/bin/curl a.virt.example.com:80", {:acceptable_exit_codes => 0}) do |r|
        r.stdout.should == "Hello from a.virt\n"
      end
    end

    it 'should answer to b.virt.example.com' do
      shell("/usr/bin/curl b.virt.example.com:80", {:acceptable_exit_codes => 0}) do |r|
        r.stdout.should == "Hello from b.virt\n"
      end
    end
  end

  context 'proxy_pass for alternative vhost' do
    it 'should configure a local vhost and a proxy vhost' do
      apply_manifest(%{
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
      }, :catch_failures => true)
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    it 'should get a response from the back end' do
      shell("/usr/bin/curl --max-redirs 0 proxy.example.com:80") do |r|
        r.stdout.should == "Hello from localhost\n"
        r.exit_code.should == 0
      end
    end
  end
end
