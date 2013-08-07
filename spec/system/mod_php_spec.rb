require 'spec_helper_system'

describe 'apache::mod::php class' do
  case node.facts['osfamily']
  when 'Debian'
    mod_dir = '/etc/apache2/mods-available'
    service_name = 'apache2'
  when 'RedHat'
    mod_dir = '/etc/httpd/conf.d'
    service_name = 'httpd'
  end

  context "default php config" do
    it 'succeeds in puppeting php' do
      puppet_apply(%{
        class { 'apache':
          mpm_module => 'prefork',
        }
        class { 'apache::mod::php': }
        apache::vhost { 'php.example.com':
          port    => '80',
          docroot => '/var/www/php',
        }
        host { 'php.example.com': ip => '127.0.0.1', }
        file { '/var/www/php/index.php':
          ensure  => file,
          content => "<?php phpinfo(); ?>\\n",
        }
      }) { |r| [0,2].should include r.exit_code}
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    describe file("#{mod_dir}/php5.conf") do
      it { should contain "DirectoryIndex index.php" }
    end

    it 'should answer to php.example.com' do
      shell("/usr/bin/curl php.example.com:80") do |r|
        r.stdout.should =~ /PHP Version/
        r.exit_code.should == 0
      end
    end
  end
end
