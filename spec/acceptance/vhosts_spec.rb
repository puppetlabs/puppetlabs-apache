# frozen_string_literal: true

require 'spec_helper_acceptance'
apache_hash = apache_settings_hash
describe 'apache::vhosts class' do
  context 'custom vhosts defined via class apache::vhosts' do
    pp = <<-MANIFEST
        host { 'custom.vhost1.com': ip => '127.0.0.1', }
        host { 'custom.vhost2.com': ip => '127.0.0.1', }
        class { 'apache::vhosts':
          vhosts => {
            'custom.vhost1.com' => {
                'docroot' => '/var/www/custom_vhost_1',
                'port' => '81',
            },
            'custom.vhost2.com' => {
                'docroot' => '/var/www/custom_vhost_2',
                'port' => '82',
            },
          },
        }
    MANIFEST
    it 'creates custom vhost config files' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/25-custom.vhost1.com.conf") do
      it { is_expected.to contain '<VirtualHost \*:81>' }
    end

    describe file("#{apache_hash['vhost_dir']}/25-custom.vhost2.com.conf") do
      it { is_expected.to contain '<VirtualHost \*:82>' }
    end
  end
end
