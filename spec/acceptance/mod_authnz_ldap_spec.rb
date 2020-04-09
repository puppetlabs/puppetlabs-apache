require 'spec_helper_acceptance'
apache_hash = apache_settings_hash

# We need to restrict this test to RHEL 7.x, 8.x derived OSs as there are too many unique
# dependency issues to solve on all supported platforms.
describe 'apache::mod_authnz_ldap', if: os[:family] == 'redhat' && os[:release].to_i > 6 do
  context 'Default mod_authnz_ldap module installation' do
    pp = <<-MANIFEST
      class { 'apache': }
      class { 'apache::mod::authnz_ldap': }
      MANIFEST

    it 'succeeds in installing the mod_authnz_ldap module' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['mod_dir']}/authnz_ldap.load") do
      it { is_expected.to contain 'mod_authnz_ldap.so' }
    end
  end
end
