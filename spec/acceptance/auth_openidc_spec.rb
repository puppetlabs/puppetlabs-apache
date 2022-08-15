# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'apache::mod::auth_openidc', if: mod_supported_on_platform?('apache::mod::auth_openidc') do
  pp = <<-MANIFEST
    include apache
    apache::vhost { 'example.com':
      docroot       => '/var/www/example.com',
      port          => 80,
      auth_oidc     => true,
      oidc_settings => {
        'ProviderMetadataURL'       => 'https://login.example.com/.well-known/openid-configuration',
        'ClientID'                  => 'test',
        'RedirectURI'               => 'https://login.example.com/redirect_uri',
        'ProviderTokenEndpointAuth' => 'client_secret_basic',
        'RemoteUserClaim'           => 'sub',
        'ClientSecret'              => 'aae053a9-4abf-4824-8956-e94b2af335c8',
        'CryptoPassphrase'          => '4ad1bb46-9979-450e-ae58-c696967df3cd',
       },
    }
  MANIFEST

  it 'succeeds in configuring a virtual host using mod_auth_openidc' do
    apply_manifest(pp, catch_failures: true)
  end

  it 'is idempotent' do
    apply_manifest(pp, catch_changes: true)
  end
end
