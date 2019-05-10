require 'spec_helper'

describe 'apache::mod::authnz_ldap', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters on a Debian OS' do
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
    it { is_expected.to contain_apache__mod('authnz_ldap') }

    context 'default verify_server_cert' do
      it { is_expected.to contain_file('authnz_ldap.conf').with_content(%r{^LDAPVerifyServerCert On$}) }
    end

    context 'verify_server_cert = false' do
      let(:params) { { verify_server_cert: false } }

      it { is_expected.to contain_file('authnz_ldap.conf').with_content(%r{^LDAPVerifyServerCert Off$}) }
    end

    context 'verify_server_cert = wrong' do
      let(:params) { { verify_server_cert: 'wrong' } }

      it 'raises an error' do
        expect { is_expected.to raise_error Puppet::Error }
      end
    end
  end # Debian

  context 'default configuration with parameters on a RedHat OS' do
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
    it { is_expected.to contain_apache__mod('authnz_ldap') }

    context 'default verify_server_cert' do
      it { is_expected.to contain_file('authnz_ldap.conf').with_content(%r{^LDAPVerifyServerCert On$}) }
    end

    context 'verify_server_cert = false' do
      let(:params) { { verify_server_cert: false } }

      it { is_expected.to contain_file('authnz_ldap.conf').with_content(%r{^LDAPVerifyServerCert Off$}) }
    end

    context 'verify_server_cert = wrong' do
      let(:params) { { verify_server_cert: 'wrong' } }

      it 'raises an error' do
        expect { is_expected.to raise_error Puppet::Error }
      end
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
