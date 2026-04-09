# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::authnz_ldap', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_class('apache::mod::ldap') }
    it { is_expected.to contain_file('authnz_ldap.conf') }

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
        expect(subject).to compile.and_raise_error(%r{parameter 'verify_server_cert' expects a Boolean value, got String})
      end
    end
  end

  context 'default configuration with parameters on a RedHat OS' do
    on_supported_os.each do |os, os_facts|
      next unless os.start_with?('redhat')
      next if os.start_with?('redhat')

      context "On #{os}" do
        let :facts do
          os_facts
        end

        it { is_expected.to contain_class('apache::params') }
        it { is_expected.to contain_class('apache::mod::ldap') }
        it { is_expected.to contain_apache__mod('authnz_ldap') }

        if os_facts[:operatingsystemmajrelease].to_i >= 7
          it { is_expected.to contain_package('mod_ldap') }
        else
          it { is_expected.to contain_package('mod_authz_ldap') }
        end

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
            expect(subject).to compile.and_raise_error(%r{parameter 'verify_server_cert' expects a Boolean value, got String})
          end
        end

        context 'SCL', if: (os_facts[:operatingsystemmajrelease].to_i >= 6 && os_facts[:operatingsystemmajrelease].to_i < 8) do
          let(:pre_condition) do
            "class { 'apache::version':
              scl_httpd_version => '2.4',
              scl_php_version   => '7.0',
            }
            include apache"
          end

          it { is_expected.to contain_package('httpd24-mod_ldap') }
        end
      end
    end
  end
end
