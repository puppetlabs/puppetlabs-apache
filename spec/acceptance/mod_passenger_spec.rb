require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache::mod::passenger class', if: os[:family] == 'debian' do
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

  context 'default passenger config' do
    # We need to set passenger_instance_registry_dir on every sane distro
    # with systemd. Systemd can force processes into a seperate/private
    # tmpdir. This is the default for apache on Ubuntu 18.04. As a result,
    # passenger CLI tools can't find the config/socket, which defaults to /tmp
    # we enable it for ubuntu 16.04/18.04, centos7 and debian 9
    pp =  if ['7', '9', '16.04', '18.04'].include?('%g' % ('%.2f' % os[:release]))
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
