require 'spec_helper_acceptance'

describe 'apache::mod::passenger class' do
  case fact('osfamily')
  when 'Debian'
    mod_dir      = '/etc/apache2/mods-available'
    service_name = 'apache2'
    passenger_conf_path = "#{mod_dir}/passenger.conf"
  when 'RedHat'
    mod_dir      = '/etc/httpd/conf.d'
    service_name = 'httpd'
    passenger_conf_path = "#{mod_dir}/passenger_extra.conf"
  when 'FreeBSD'
    mod_dir      = '/usr/local/etc/apache22/Modules'
    service_name = 'apache22'
    passenger_conf_path = "#{mod_dir}/passenger.conf"
  end

  context "default passenger config" do
    it 'succeeds in puppeting passenger' do
      pp= <<-EOS
        class { 'apache': }
        class { 'apache::mod::passenger': }
        apache::vhost { 'passenger.example.com':
          port    => '80',
          docroot => '/var/www/passenger/public',
          custom_fragment => "PassengerRuby  /usr/bin/ruby\\nRailsEnv  development" ,
        }
        host { 'passenger.example.com': ip => '127.0.0.1', }
        file { '/var/www/passenger':
          ensure  => directory,
        }
        file { '/var/www/passenger/tmp':
          ensure  => directory,
        }
        file { '/var/www/passenger/public':
          ensure  => directory,
        }
        file { '/var/www/passenger/config.ru':
          ensure  => file,
          content => "app = proc { |env| [200, { \\"Content-Type\\" => \\"text/html\\" }, [\\"hello <b>world</b>\\"]]
}\\nrun app",
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    describe file(passenger_conf_path) do
      it { should contain /^<IfModule mod_passenger\.c>$/ }
      it { should contain /^  PassengerRuby \/usr\/bin\/ruby$/ }
    end

    it 'should answer to passenger.example.com' do
      shell("/usr/bin/curl passenger.example.com:80") do |r|
        r.stdout.should =~ /hello <b>world<\/b>/
        r.exit_code.should == 0
      end
    end
  end

  context "customized passenger config" do
    it 'succeeds in puppeting passenger' do
      pp= <<-EOS
        class { 'apache': }
        class { 'apache::mod::passenger':
          mod_package_ensure => 'present',
          mod_id             => 'passenger_module',
          mod_lib            => 'mod_passenger.so',
          mod_lib_path       => $apache::params::lib_path,
          mod_path           => "${apache::params::lib_path}/mod_passenger.so",
        }
        apache::vhost { 'passenger.example.com':
          port    => '80',
          docroot => '/var/www/passenger/public',
          custom_fragment => "PassengerRuby  /usr/bin/ruby\\nRailsEnv  development" ,
        }
        host { 'passenger.example.com': ip => '127.0.0.1', }
        file { '/var/www/passenger':
          ensure  => directory,
        }
        file { '/var/www/passenger/tmp':
          ensure  => directory,
        }
        file { '/var/www/passenger/public':
          ensure  => directory,
        }
        file { '/var/www/passenger/config.ru':
          ensure  => file,
          content => "app = proc { |env| [200, { \\"Content-Type\\" => \\"text/html\\" }, [\\"hello <b>world</b>\\"]]
}\\nrun app",
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    describe file(passenger_conf_path) do
      it { should contain /^<IfModule mod_passenger\.c>$/ }
      it { should contain /^  PassengerRuby \/usr\/bin\/ruby$/ }
    end

    it 'should answer to passenger.example.com' do
      shell("/usr/bin/curl passenger.example.com:80") do |r|
        r.stdout.should =~ /hello <b>world<\/b>/
        r.exit_code.should == 0
      end
    end
  end
end
