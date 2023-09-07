# frozen_string_literal: true

require 'spec_helper_acceptance'
apache_hash = apache_settings_hash
describe 'apache::vhost define auth kerb' do
  context 'new vhost on port 80' do
    pp = <<-MANIFEST
      class { 'apache': }
      file { '/var/www':
        ensure  => 'directory',
        recurse => true,
      }

      apache::vhost { 'first.example.com':
        auth_kerb => true,
        ssl  => true,
        krb_method_negotiate   => 'on',
        krb_auth_realms        => ['EXAMPLE.ORG'],
        krb_local_user_mapping => 'on',
        directories            => [
          {
            path         => '/var/www/html',
            auth_name    => 'Kerberos Login',
            auth_type    => 'Kerberos',
            auth_require => 'valid-user',
          },
        ],
      }
    MANIFEST
    it 'configures an apache vhost' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['vhost_dir']}/25-first.example.com.conf") do
      it { is_expected.to contain '<VirtualHost \*:80>' }
      it { is_expected.to contain 'ServerName first.example.com' }
    end
  end
end
