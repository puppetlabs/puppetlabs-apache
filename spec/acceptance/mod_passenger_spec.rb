require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache::mod::passenger class' do
  case fact('osfamily')
  when 'Debian'
    conf_file = "#{$mod_dir}/passenger.conf"
    load_file = "#{$mod_dir}/zpassenger.load"

    case fact('operatingsystem')
    when 'Ubuntu'
      case fact('lsbdistrelease')
      when '14.04'
        passenger_root = '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini'
        passenger_default_ruby = '/usr/bin/ruby'
      when '16.04'
        passenger_root = '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini'
        passenger_default_ruby = '/usr/bin/ruby'
      else
        # Includes 10.04 and 12.04
        # This may or may not work on Ubuntu releases other than the above
        passenger_root = '/usr'
        passenger_ruby = '/usr/bin/ruby'
      end
    when 'Debian'
      case fact('lsbdistcodename')
      when 'jessie'
        passenger_root = '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini'
        passenger_default_ruby = '/usr/bin/ruby'
      else
        # Includes wheezy
        # This may or may not work on Debian releases other than the above
        passenger_root = '/usr'
        passenger_ruby = '/usr/bin/ruby'
      end
    end

    passenger_module_path = '/usr/lib/apache2/modules/mod_passenger.so'
    rackapp_user = 'www-data'
    rackapp_group = 'www-data'
  when 'RedHat'
    conf_file = "#{$mod_dir}/passenger.conf"
    load_file = "#{$mod_dir}/zpassenger.load"
    # sometimes installs as 3.0.12, sometimes as 3.0.19 - so just check for the stable part
    passenger_root = '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini'
    passenger_ruby = '/usr/bin/ruby'
    passenger_module_path = 'modules/mod_passenger.so'
    rackapp_user = 'apache'
    rackapp_group = 'apache'
  end

  pp_rackapp = <<-MANIFEST
    /* a simple ruby rack 'hello world' app */
    file { '/var/www/passenger':
      ensure => directory,
      owner  => '#{rackapp_user}',
      group  => '#{rackapp_group}',
    }
    file { '/var/www/passenger/config.ru':
      ensure  => file,
      owner   => '#{rackapp_user}',
      group   => '#{rackapp_group}',
      content => "app = proc { |env| [200, { \\"Content-Type\\" => \\"text/html\\" }, [\\"hello <b>world</b>\\"]] }\\nrun app",
    }
    apache::vhost { 'passenger.example.com':
      port          => '80',
      docroot       => '/var/www/passenger/public',
      docroot_group => '#{rackapp_group}',
      docroot_owner => '#{rackapp_user}',
      require       => File['/var/www/passenger/config.ru'],
    }
    host { 'passenger.example.com': ip => '127.0.0.1', }
  MANIFEST

  case fact('osfamily')
  when 'Debian'
    context 'passenger config with passenger_installed_version set' do
      pp_one = <<-MANIFEST
          class { 'apache': }
          class { 'apache::mod::passenger':
            passenger_installed_version     => '4.0.0',
            passenger_instance_registry_dir => '/some/path/to/nowhere'
          }
      MANIFEST
      it 'fails when an option is not valid for $passenger_installed_version' do
        apply_manifest(pp_one, expect_failures: true) do |r|
          expect(r.stderr).to match(%r{passenger_instance_registry_dir is not introduced until version 5.0.0})
        end
      end
      pp_two = <<-MANIFEST
          class { 'apache': }
          class { 'apache::mod::passenger':
            passenger_installed_version => '5.0.0',
            rails_autodetect            => 'on'
          }
      MANIFEST
      it 'fails when an option is removed' do
        apply_manifest(pp_two, expect_failures: true) do |r|
          expect(r.stderr).to match(%r{REMOVED PASSENGER OPTION})
        end
      end
      pp_three = <<-MANIFEST
          class { 'apache': }
          class { 'apache::mod::passenger':
            passenger_installed_version => '5.0.0',
            rails_ruby                  => '/some/path/to/ruby'
          }
      MANIFEST
      it 'warns when an option is deprecated' do
        apply_manifest(pp_three, catch_failures: true) do |r|
          expect(r.stderr).to match(%r{DEPRECATED PASSENGER OPTION})
        end
      end
    end
    context 'default passenger config' do
      pp = <<-MANIFEST
          /* stock apache and mod_passenger */
          class { 'apache': }
          class { 'apache::mod::passenger': }
          #{pp_rackapp}
      MANIFEST
      it 'succeeds in puppeting passenger' do
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

      describe file(conf_file) do
        it { is_expected.to contain %(PassengerRoot "#{passenger_root}") }
        case fact('operatingsystem')
        when 'Ubuntu'
          case fact('lsbdistrelease')
          when '14.04'
            it { is_expected.to contain %(PassengerDefaultRuby "#{passenger_default_ruby}") }
            it { is_expected.not_to contain '/PassengerRuby/' }
          when '16.04'
            it { is_expected.to contain %(PassengerDefaultRuby "#{passenger_default_ruby}") }
            it { is_expected.not_to contain '/PassengerRuby/' }
          else
            # Includes 10.04 and 12.04
            # This may or may not work on Ubuntu releases other than the above
            it { is_expected.to contain %(PassengerRuby "#{passenger_ruby}) }
            it { is_expected.not_to contain '/PassengerDefaultRuby/' }
          end
        when 'Debian'
          case fact('lsbdistcodename')
          when 'jessie'
            it { is_expected.to contain %(PassengerDefaultRuby "#{passenger_default_ruby}") }
            it { is_expected.not_to contain '/PassengerRuby/' }
          else
            # Includes wheezy
            # This may or may not work on Debian releases other than the above
            it { is_expected.to contain %(PassengerRuby "#{passenger_ruby}) }
            it { is_expected.not_to contain '/PassengerDefaultRuby/' }
          end
        end
      end
      # rubocop:enable RSpec/RepeatedExample

      describe file(load_file) do
        it { is_expected.to contain "LoadModule passenger_module #{passenger_module_path}" }
      end

      expected_one = [%r{Apache processes}, %r{Nginx processes}, %r{Passenger processes}]
      # passenger-memory-stats output on newer Debian/Ubuntu verions do not contain
      # these two lines
      unless (fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') == '14.04') ||
             (fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') == '16.04') ||
             (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8') ||
             (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '7')
        expected_one < [%r{### Processes: [0-9]+}, %r{### Total private dirty RSS: [0-9\.]+ MB}]
      end
      it 'outputs status via passenger-memory-stats #stdout' do
        expected_one.each do |expect|
          shell('PATH=/usr/bin:$PATH /usr/sbin/passenger-memory-stats') do |r|
            expect(r.stdout).to match(expect)
          end
        end
      end
      it 'outputs status via passenger-memory-stats #exit_code' do
        shell('PATH=/usr/bin:$PATH /usr/sbin/passenger-memory-stats') do |r|
          expect(r.exit_code).to eq(0)
        end
      end

      # passenger-status fails under stock ubuntu-server-12042-x64 + mod_passenger,
      # even when the passenger process is successfully installed and running
      unless fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') == '12.04'
        it 'outputs status via passenger-status #General information' do
          shell('PATH=/usr/bin:$PATH /usr/sbin/passenger-status') do |r|
            # spacing may vary
            expect(r.stdout).to match(%r{[\-]+ General information [\-]+})
          end
        end
        expected_two = if fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') == '14.04' ||
                          (fact('operatingsystem') == 'Ubuntu' && fact('operatingsystemrelease') == '16.04') ||
                          fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
                         [%r{Max pool size[ ]+: [0-9]+}, %r{Processes[ ]+: [0-9]+}, %r{Requests in top-level queue[ ]+: [0-9]+}]
                       else
                         [%r{max[ ]+= [0-9]+}, %r{count[ ]+= [0-9]+}, %r{active[ ]+= [0-9]+}, %r{inactive[ ]+= [0-9]+}, %r{Waiting on global queue: [0-9]+}]
                       end
        it 'outputs status via passenger-status #stdout' do
          shell('PATH=/usr/bin:$PATH /usr/sbin/passenger-status') do |r|
            expected_two.each do |expect|
              expect(r.stdout).to match(expect)
            end
          end
        end
        it 'outputs status via passenger-status #exit_code' do
          shell('PATH=/usr/bin:$PATH /usr/sbin/passenger-status') do |r|
            expect(r.exit_code).to eq(0)
          end
        end
      end

      it 'answers to passenger.example.com #stdout' do
        shell('/usr/bin/curl passenger.example.com:80') do |r|
          expect(r.stdout).to match(%r{^hello <b>world<\/b>$})
        end
      end
      it 'answers to passenger.example.com #exit_code' do
        shell('/usr/bin/curl passenger.example.com:80') do |r|
          expect(r.exit_code).to eq(0)
        end
      end
    end
  end
end
