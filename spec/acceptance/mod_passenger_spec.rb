require 'spec_helper_acceptance'

describe 'apache::mod::passenger class', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  case fact('osfamily')
  when 'Debian'
    service_name = 'apache2'
    mod_dir = '/etc/apache2/mods-available/'
    conf_file = "#{mod_dir}passenger.conf"
    load_file = "#{mod_dir}passenger.load"
    passenger_root = '/usr'
    passenger_ruby = '/usr/bin/ruby'
    passenger_module_path = '/usr/lib/apache2/modules/mod_passenger.so'
    rackapp_user = 'www-data'
    rackapp_group = 'www-data'
  when 'RedHat'
    service_name = 'httpd'
    mod_dir = '/etc/httpd/conf.d/'
    conf_file = "#{mod_dir}passenger.conf"
    load_file = "#{mod_dir}passenger.load"
    passenger_root = '/usr/lib/ruby/gems/1.8/gems/passenger-3.0.19'
    passenger_ruby = '/usr/bin/ruby'
    passenger_module_path = 'modules/mod_passenger.so'
    rackapp_user = 'apache'
    rackapp_group = 'apache'
  end

  pp_rackapp = <<-EOS
          /* a simple ruby rack 'hellow world' app */
          file { '/var/www/passenger':
            ensure  => directory,
            owner   => '#{rackapp_user}',
            group   => '#{rackapp_group}',
            require => Class['apache::mod::passenger'],
          }
          file { '/var/www/passenger/config.ru':
            ensure  => file,
            owner   => '#{rackapp_user}',
            group   => '#{rackapp_group}',
            content => "app = proc { |env| [200, { \\"Content-Type\\" => \\"text/html\\" }, [\\"hello <b>world</b>\\"]] }\\nrun app",
            require => File['/var/www/passenger'] ,
          }
          apache::vhost { 'passenger.example.com':
            port    => '80',
            docroot => '/var/www/passenger/public',
            docroot_group => '#{rackapp_group}' ,
            docroot_owner => '#{rackapp_user}' ,
            custom_fragment => "PassengerRuby  #{passenger_ruby}\\nRailsEnv  development" ,
            require => File['/var/www/passenger/config.ru'] ,
          }
          host { 'passenger.example.com': ip => '127.0.0.1', }
  EOS

  case fact('osfamily')
  when 'Debian'
    context "default passenger config" do
      it 'succeeds in puppeting passenger' do
        pp = <<-EOS
          /* stock apache and mod_passenger */
          class { 'apache': }
          class { 'apache::mod::passenger': }
          #{pp_rackapp}
        EOS
        apply_manifest(pp, :catch_failures => true)
      end

      describe service(service_name) do
        it { should be_enabled }
        it { should be_running }
      end
      
      describe file(conf_file) do
        it { should contain "PassengerRoot \"#{passenger_root}\"" }
        it { should contain "PassengerRuby \"#{passenger_ruby}\"" }
      end

      describe file(load_file) do
        it { should contain "LoadModule passenger_module #{passenger_module_path}" }
      end

      it 'should output status via passenger-memory-stats' do
        shell("sudo /usr/sbin/passenger-memory-stats") do |r|
          r.stdout.should =~ /Apache processes/
          r.stdout.should =~ /Nginx processes/
          r.stdout.should =~ /Passenger processes/
          r.stdout.should =~ /### Processes: [0-9]+/
          r.stdout.should =~ /### Total private dirty RSS: [0-9\.]+ MB/
      
          r.exit_code.should == 0
        end
      end
      
      # passenger-status fails under stock ubuntu-server-12042-x64 + mod_passenger,
      # even when the passenger process is successfully installed and running
      unless fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') == '12.04'
        it 'should output status via passenger-status' do
          # xml output not available on ubunutu <= 10.04, so sticking with default pool output
          shell("sudo /usr/sbin/passenger-status") do |r|
            # spacing may vary
            r.stdout.should =~ /[\-]+ General information [\-]+/
            r.stdout.should =~ /max[ ]+= [0-9]+/
            r.stdout.should =~ /count[ ]+= [0-9]+/
            r.stdout.should =~ /active[ ]+= [0-9]+/
            r.stdout.should =~ /inactive[ ]+= [0-9]+/
            r.stdout.should =~ /Waiting on global queue: [0-9]+/
      
            r.exit_code.should == 0
          end
        end
      end
      
      it 'should answer to passenger.example.com' do
        shell("/usr/bin/curl passenger.example.com:80") do |r|
          r.stdout.should =~ /^hello <b>world<\/b>$/
          r.exit_code.should == 0
        end
      end
      
    end

  when 'RedHat'
    # no fedora 18 passenger package yet
    unless (fact('operatingsystem') == 'Fedora' and fact('operatingsystemrelease').to_f >= 18)

      context "default passenger config" do
        it 'succeeds in puppeting passenger' do
          pp = <<-EOS
            /* EPEL and passenger repositories */
            class { 'epel': }
            exec { 'passenger.repo GPG key':
              command => '/usr/bin/sudo /usr/bin/curl -o /etc/yum.repos.d/RPM-GPG-KEY-stealthymonkeys.asc http://passenger.stealthymonkeys.com/RPM-GPG-KEY-stealthymonkeys.asc',
              creates => '/etc/yum.repos.d/RPM-GPG-KEY-stealthymonkeys.asc',
            }
            file { 'passenger.repo GPG key':
              ensure  => file,
              path    => '/etc/yum.repos.d/RPM-GPG-KEY-stealthymonkeys.asc',
              require => Exec['passenger.repo GPG key'],
            }
            epel::rpm_gpg_key { 'passenger.stealthymonkeys.com':
              path    => '/etc/yum.repos.d/RPM-GPG-KEY-stealthymonkeys.asc',
              require => [
                Class['epel'],
                File['passenger.repo GPG key'],
              ]
            }
            yumrepo { 'passenger':
              baseurl         => 'http://passenger.stealthymonkeys.com/rhel/$releasever/$basearch' ,
              descr           => 'Red Hat Enterprise $releasever - Phusion Passenger',
              enabled         => 1,
              gpgcheck        => 1,
              gpgkey          => 'http://passenger.stealthymonkeys.com/RPM-GPG-KEY-stealthymonkeys.asc',
              mirrorlist      => 'http://passenger.stealthymonkeys.com/rhel/mirrors',
              require => [
                Epel::Rpm_gpg_key['passenger.stealthymonkeys.com'],
              ],
            }
            /* apache and mod_passenger */
            class { 'apache':
                require => [
                  Class['epel'],
              ],
            }
            class { 'apache::mod::passenger':
              require => [
                Yumrepo['passenger']
              ],
            }
            #{pp_rackapp}
          EOS
          apply_manifest(pp, :catch_failures => true)
        end

        describe service(service_name) do
          it { should be_enabled }
          it { should be_running }
        end
      
        describe file(conf_file) do
          it { should contain "PassengerRoot \"#{passenger_root}\"" }
          it { should contain "PassengerRuby \"#{passenger_ruby}\"" }
        end

        describe file(load_file) do
          it { should contain "LoadModule passenger_module #{passenger_module_path}" }
        end

        # note: passenger-memory-stats is not installed on Redhat

        it 'should output status via passenger-status' do
          shell("sudo /usr/bin/passenger-status") do |r|
            # spacing may vary
            r.stdout.should =~ /[\-]+ General information [\-]+/
            r.stdout.should =~ /max[ ]+= [0-9]+/
            r.stdout.should =~ /count[ ]+= [0-9]+/
            r.stdout.should =~ /active[ ]+= [0-9]+/
            r.stdout.should =~ /inactive[ ]+= [0-9]+/
            r.stdout.should =~ /Waiting on global queue: [0-9]+/
      
            r.exit_code.should == 0
          end
        end
      
        it 'should answer to passenger.example.com' do
          shell("/usr/bin/curl passenger.example.com:80") do |r|
            r.stdout.should =~ /^hello <b>world<\/b>$/
            r.exit_code.should == 0
          end
        end
      end

    end

  end
end
