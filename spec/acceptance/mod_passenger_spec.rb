require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache::mod::passenger class', if: fact('osfamily') == 'Debian' do
  conf_file = "#{$mod_dir}/passenger.conf"
  load_file = "#{$mod_dir}/zpassenger.load"

  passenger_root = '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini'
  passenger_default_ruby = '/usr/bin/ruby'

  passenger_module_path = '/usr/lib/apache2/modules/mod_passenger.so'
  rackapp_user = 'www-data'
  rackapp_group = 'www-data'

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
    # We need to set passenger_instance_registry_dir on every sane distro
    # with systemd. Systemd can force processes into a seperate/private
    # tmpdir. This is the default for apache on Ubuntu 18.04. As a result,
    # passenger CLI tools can't find the config/socket, which defaults to /tmp
    # we enable it for ubuntu 16.04/18.04, centos7 and debian 9
    pp =  if ['7', '9', '16.04', '18.04'].include?(fact('operatingsystemmajrelease'))
            <<-MANIFEST
              /* stock apache and mod_passenger */
              class { 'apache': }
              class { 'apache::mod::passenger':
                passenger_instance_registry_dir => '/var/run',
              }
              #{pp_rackapp}
            MANIFEST
          else
            <<-MANIFEST
              /* stock apache and mod_passenger */
              class { 'apache': }
              class { 'apache::mod::passenger': }
              #{pp_rackapp}
            MANIFEST
          end
    it 'succeeds in puppeting passenger' do
      apply_manifest(pp, catch_failures: true)
    end

    describe service($service_name) do
      if fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      elsif fact('operatingsystem') == 'SLES' && fact('operatingsystemmajrelease') == '15'
        pending 'Should be enabled - MODULES-8379 `be_enabled` check does not currently work for apache2 on SLES 15'
      else
        it { is_expected.to be_enabled }
      end
      it { is_expected.to be_running }
    end

    describe file(conf_file) do
      it { is_expected.to contain %(PassengerRoot "#{passenger_root}") }
      it { is_expected.to contain %(PassengerDefaultRuby "#{passenger_default_ruby}") }
      it { is_expected.not_to contain '/PassengerRuby/' }
    end
    # rubocop:enable RSpec/RepeatedExample

    describe file(load_file) do
      it { is_expected.to contain "LoadModule passenger_module #{passenger_module_path}" }
    end

    expected_one = [%r{Apache processes}, %r{Nginx processes}, %r{Passenger processes}]
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

    it 'outputs status via passenger-status #General information' do
      shell('PATH=/usr/bin:$PATH PASSENGER_INSTANCE_REGISTRY_DIR=/var/run /usr/sbin/passenger-status') do |r|
        # spacing may vary
        expect(r.stdout).to match(%r{[\-]+ General information [\-]+})
      end
    end

    expected_two = [%r{Max pool size[ ]+: [0-9]+}, %r{Processes[ ]+: [0-9]+}, %r{Requests in top-level queue[ ]+: [0-9]+}]
    it 'outputs status via passenger-status #stdout' do
      shell('PATH=/usr/bin:$PATH PASSENGER_INSTANCE_REGISTRY_DIR=/var/run /usr/sbin/passenger-status') do |r|
        expected_two.each do |expect|
          expect(r.stdout).to match(expect)
        end
      end
    end
    it 'outputs status via passenger-status #exit_code' do
      shell('PATH=/usr/bin:$PATH PASSENGER_INSTANCE_REGISTRY_DIR=/var/run /usr/sbin/passenger-status') do |r|
        expect(r.exit_code).to eq(0)
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
