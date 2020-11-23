require 'spec_helper_acceptance'
apache_hash = apache_settings_hash

describe 'apache::mod::apreq2', if: mod_supported_on_platform?('apache::mod::apreq2') do
  pp = <<-MANIFEST
    class { 'apache' : }
    class { 'apache::mod::apreq2': }
  MANIFEST

  it 'succeeds in installing the mod_authnz_apreq2 module' do
    apply_manifest(pp, catch_failures: true)
  end
end