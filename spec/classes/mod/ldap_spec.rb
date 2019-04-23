require 'spec_helper'

describe 'apache::mod::ldap', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'on a Debian OS' do
    let :facts do
      {
        lsbdistcodename: 'jessie',
        osfamily: 'Debian',
        operatingsystemrelease: '8',
        id: 'root',
        kernel: 'Linux',
        operatingsystem: 'Debian',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_class('apache::mod::ldap') }
    it { is_expected.to contain_apache__mod('ldap') }

    context 'default ldap_trusted_global_cert_file' do
      it { is_expected.to contain_file('apache-mod-ldap.conf').without_content(%r{^LDAPTrustedGlobalCert}) }
    end

    context 'ldap_trusted_global_cert_file param' do
      let(:params) { { ldap_trusted_global_cert_file: 'ca.pem' } }

      it { is_expected.to contain_file('apache-mod-ldap.conf').with_content(%r{^LDAPTrustedGlobalCert CA_BASE64 ca\.pem$}) }
    end

    context 'set multiple ldap params' do
      let(:params) do
        {
          ldap_trusted_global_cert_file: 'ca.pem',
          ldap_trusted_global_cert_type: 'CA_DER',
          ldap_trusted_mode: 'TLS',
          ldap_shared_cache_size: '500000',
          ldap_cache_entries: '1024',
          ldap_cache_ttl: '600',
          ldap_opcache_entries: '1024',
          ldap_opcache_ttl: '600',
        }
      end

      it { is_expected.to contain_file('apache-mod-ldap.conf').with_content(%r{^LDAPTrustedGlobalCert CA_DER ca\.pem$}) }
      it { is_expected.to contain_file('apache-mod-ldap.conf').with_content(%r{^LDAPTrustedMode TLS$}) }
      it { is_expected.to contain_file('apache-mod-ldap.conf').with_content(%r{^LDAPSharedCacheSize 500000$}) }
      it { is_expected.to contain_file('apache-mod-ldap.conf').with_content(%r{^LDAPCacheEntries 1024$}) }
      it { is_expected.to contain_file('apache-mod-ldap.conf').with_content(%r{^LDAPCacheTTL 600$}) }
      it { is_expected.to contain_file('apache-mod-ldap.conf').with_content(%r{^LDAPOpCacheEntries 1024$}) }
      it { is_expected.to contain_file('apache-mod-ldap.conf').with_content(%r{^LDAPOpCacheTTL 600$}) }
    end
  end # Debian

  context 'on a RedHat OS' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystemrelease: '6',
        id: 'root',
        kernel: 'Linux',
        operatingsystem: 'RedHat',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_class('apache::mod::ldap') }
    it { is_expected.to contain_apache__mod('ldap') }

    context 'default ldap_trusted_global_cert_file' do
      it { is_expected.to contain_file('apache-mod-ldap.conf').without_content(%r{^LDAPTrustedGlobalCert}) }
    end

    context 'ldap_trusted_global_cert_file param' do
      let(:params) { { ldap_trusted_global_cert_file: 'ca.pem' } }

      it { is_expected.to contain_file('apache-mod-ldap.conf').with_content(%r{^LDAPTrustedGlobalCert CA_BASE64 ca\.pem$}) }
    end

    context 'ldap_trusted_global_cert_file and ldap_trusted_global_cert_type params' do
      let(:params) do
        {
          ldap_trusted_global_cert_file: 'ca.pem',
          ldap_trusted_global_cert_type: 'CA_DER',
        }
      end

      it { is_expected.to contain_file('apache-mod-ldap.conf').with_content(%r{^LDAPTrustedGlobalCert CA_DER ca\.pem$}) }
    end

    context 'SCL' do
      let(:pre_condition) do
        "class { 'apache::version':
          scl_httpd_version => '2.4',
          scl_php_version   => '7.0',
        }
        include apache"
      end

      it { is_expected.to contain_package('httpd24-mod_ldap') }
    end
  end # Redhat
end
