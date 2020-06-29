require 'spec_helper_acceptance'
apache_hash = apache_settings_hash

# We need to restrict this test to RHEL 7.x, 8.x derived OSs as there are too many unique
# dependency issues to solve on all supported platforms.
describe 'apache::mod_authnz_ldap', if: os[:family] == 'redhat' && os[:release].to_i > 6 do
  context 'Default mod_authnz_ldap module installation' do
    pp = if run_shell("grep 'Oracle Linux Server' /etc/os-release", expect_failures: true).exit_status == 0
           <<-MANIFEST
      yumrepo { 'ol7_optional_latest':
        name 	  => 'ol7_optional_latest',
        baseurl 	  => 'https://yum.oracle.com/repo/OracleLinux/OL7/optional/latest/x86_64/',
        gpgkey 	  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle',
        gpgcheck => 1,
        enabled	   => 1,
      }
      class { 'apache': }
      class { 'apache::mod::authnz_ldap': }
      MANIFEST
         else
           <<-MANIFEST
        package { 'epel-release':
          ensure => present,
        }
        class { 'apache': }
        class { 'apache::mod::authnz_ldap': }
        MANIFEST
         end

    it 'succeeds in installing the mod_authnz_ldap module' do
      apply_manifest(pp, catch_failures: true)
    end

    describe file("#{apache_hash['mod_dir']}/authnz_ldap.load") do
      it { is_expected.to contain 'mod_authnz_ldap.so' }
    end
  end
end
