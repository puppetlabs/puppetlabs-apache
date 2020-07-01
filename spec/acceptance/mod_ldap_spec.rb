require 'spec_helper_acceptance'
apache_hash = apache_settings_hash

describe 'apache::mod::ldap', unless: os[:family] == 'redhat' && os[:release].to_i >= 8 do
  context 'Default ldap module installation' do
    pp = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::ldap': }
    MANIFEST

    it 'succeeds in installing the ldap module' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['mod_dir']}/ldap.load") do
      it { is_expected.to contain 'mod_ldap.so' }
    end
  end
end
