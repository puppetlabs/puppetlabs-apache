# frozen_string_literal: true

require 'spec_helper_acceptance'
apache_hash = apache_settings_hash
describe 'apache class' do
  context 'default parameters' do
    let(:pp) { "class { 'apache': }" }

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end

    describe package(apache_hash['package_name']) do
      it { is_expected.to be_installed }
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(80) do
      it { is_expected.to be_listening }
    end
  end

  context 'custom site/mod dir parameters' do
    let(:pp) do
      <<-MANIFEST
        if $facts['os']['family'] == 'RedHat' and $facts['os']['selinux']['enabled'] {
          exec { 'set_apache_defaults':
            command => 'semanage fcontext --add -t httpd_config_t "/apache_spec/apache_custom(/.*)?"',
            unless  => 'semanage fcontext --list | grep /apache_spec/apache_custom | grep httpd_config_t',
            path    => '/bin:/usr/bin/:/sbin:/usr/sbin',
          }
          exec { 'restorecon_apache':
            command     => 'restorecon -Rv /apache_spec',
            path        => '/bin:/usr/bin/:/sbin:/usr/sbin',
            before      => Service['httpd'],
            require     => [File['/apache_spec/apache_custom'], Class['apache']],
            subscribe   => Exec['set_apache_defaults'],
            refreshonly => true,
          }
        }
        file { ['/apache_spec', '/apache_spec/apache_custom']:
          ensure => directory,
        }
        class { 'apache':
          mod_dir   => '/apache_spec/apache_custom/mods',
          vhost_dir => '/apache_spec/apache_custom/vhosts',
        }
      MANIFEST
    end

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
