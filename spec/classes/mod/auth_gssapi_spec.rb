# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::auth_gssapi', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian OS', :compile do
      include_examples 'Debian 11'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_class('apache::mod::authn_core') }
      it { is_expected.to contain_apache__mod('auth_gssapi') }
      it { is_expected.to contain_package('libapache2-mod-auth-gssapi') }
    end

    context 'on a RedHat OS', :compile do
      include_examples 'RedHat 8'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_class('apache::mod::authn_core') }
      it { is_expected.to contain_apache__mod('auth_gssapi') }
      it { is_expected.to contain_package('mod_auth_gssapi') }
    end

    context 'on a FreeBSD OS', :compile do
      include_examples 'FreeBSD 9'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_class('apache::mod::authn_core') }
      it { is_expected.to contain_apache__mod('auth_gssapi') }
      it { is_expected.to contain_package('www/mod_auth_gssapi') }
    end

    context 'on a Gentoo OS', :compile do
      include_examples 'Gentoo'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_class('apache::mod::authn_core') }
      it { is_expected.to contain_apache__mod('auth_gssapi') }
      it { is_expected.to contain_package('www-apache/mod_auth_gssapi') }
    end
  end
end
