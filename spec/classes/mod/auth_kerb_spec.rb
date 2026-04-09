# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::auth_kerb', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a RedHat OS', :compile do
      include_examples 'RedHat 8'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_class('apache::mod::authn_core') }
      it { is_expected.to contain_apache__mod('auth_kerb') }
      it { is_expected.to contain_package('mod_auth_kerb') }
    end

    context 'on a FreeBSD OS', :compile do
      include_examples 'FreeBSD 9'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_class('apache::mod::authn_core') }
      it { is_expected.to contain_apache__mod('auth_kerb') }
      it { is_expected.to contain_package('www/mod_auth_kerb2') }
    end

    context 'on a Gentoo OS', :compile do
      include_examples 'Gentoo'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_class('apache::mod::authn_core') }
      it { is_expected.to contain_apache__mod('auth_kerb') }
      it { is_expected.to contain_package('www-apache/mod_auth_kerb') }
    end
  end

  context 'overriding mod_packages' do
    context 'on a RedHat OS', :compile do
      include_examples 'RedHat 8'
      let :pre_condition do
        <<-MANIFEST
        include apache::params
        class { 'apache':
          mod_packages => merge($::apache::params::mod_packages, {
            'auth_kerb' => 'httpd24-mod_auth_kerb',
          })
        }
        MANIFEST
      end

      it { is_expected.to contain_class('apache::mod::authn_core') }
      it { is_expected.to contain_apache__mod('auth_kerb') }
      it { is_expected.to contain_package('httpd24-mod_auth_kerb') }
      it { is_expected.not_to contain_package('mod_auth_kerb') }
    end
  end
end
