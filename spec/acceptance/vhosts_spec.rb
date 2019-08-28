require 'spec_helper_acceptance'
apache_hash = apache_settings_hash
describe 'apache::vhosts class' do
  context 'custom vhosts defined via class apache::vhosts' do
    pp = <<-MANIFEST
        class { 'apache::vhosts':
          vhosts => {
            'custom_vhost_1' => {
                'docroot' => '/var/www/custom_vhost_1',
                'port' => '81',
            },
            'custom_vhost_2' => {
                'docroot' => '/var/www/custom_vhost_2',
                'port' => '82',
            },
          },
        }
    MANIFEST
    it 'creates custom vhost config files' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/25-custom_vhost_1.conf") do
      it { is_expected.to contain '<VirtualHost \*:81>' }
    end

    describe file("#{apache_hash['vhost_dir']}/25-custom_vhost_2.conf") do
      it { is_expected.to contain '<VirtualHost \*:82>' }
    end
  end
end
