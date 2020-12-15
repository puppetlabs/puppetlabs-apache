require 'spec_helper_acceptance'

describe 'apache::mod::md', if: mod_supported_on_platform?('apache::mod::md') do
  pp = <<-MANIFEST
    class { 'apache':
    }
    apache::vhost { 'example.com':
      docroot => '/var/www/example.com',
      port    => 443,
      ssl     => true,
      mdomain => true,
    }
  MANIFEST

  it 'succeeds in configuring a virtual host using mod_md' do
    apply_manifest(pp, catch_failures: true)
  end
end
