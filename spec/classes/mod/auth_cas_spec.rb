# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::auth_cas', type: :class do
  context 'default params' do
    let :params do
      {
        cas_login_url: 'https://cas.example.com/login',
        cas_validate_url: 'https://cas.example.com/validate',
        cas_cookie_path: '/var/cache/apache2/mod_auth_cas/'
      }
    end

    it_behaves_like 'a mod class, without including apache'
  end

  context 'default configuration with parameters' do
    let :params do
      {
        cas_login_url: 'https://cas.example.com/login',
        cas_validate_url: 'https://cas.example.com/validate',
        cas_timeout: 1234,
        cas_idle_timeout: 4321
      }
    end

    context 'on a Debian OS', :compile do
      include_examples 'Debian 11'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_class('apache::mod::authn_core') }
      it { is_expected.to contain_apache__mod('auth_cas') }
      it { is_expected.to contain_package('libapache2-mod-auth-cas') }
      it { is_expected.to contain_file('auth_cas.conf').with_path('/etc/apache2/mods-available/auth_cas.conf') }
      it { is_expected.to contain_file('/var/cache/apache2/mod_auth_cas/').with_owner('www-data') }
      it { is_expected.to contain_file('auth_cas.conf').with_content(%r{CASTimeout 1234}) }
      it { is_expected.to contain_file('auth_cas.conf').with_content(%r{CASIdleTimeout 4321}) }
    end

    context 'on a RedHat OS', :compile do
      include_examples 'RedHat 8'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_class('apache::mod::authn_core') }
      it { is_expected.to contain_apache__mod('auth_cas') }
      it { is_expected.to contain_package('mod_auth_cas') }
      it { is_expected.to contain_file('auth_cas.conf').with_path('/etc/httpd/conf.modules.d/auth_cas.conf') }
      it { is_expected.to contain_file('/var/cache/mod_auth_cas/').with_owner('apache') }
      it { is_expected.to contain_file('auth_cas.conf').with_content(%r{CASTimeout 1234}) }
      it { is_expected.to contain_file('auth_cas.conf').with_content(%r{CASIdleTimeout 4321}) }
    end

    context 'vhost setup', :compile do
      let :pre_condition do
        "class { 'apache': } apache::vhost { 'test.server': docroot => '/var/www/html', cas_root_proxied_as => 'http://test.server', cas_cookie_path => '/my/cas/path'} "
      end

      include_examples 'RedHat 8'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_class('apache::mod::authn_core') }
      it { is_expected.to contain_apache__mod('auth_cas') }
      it { is_expected.to contain_package('mod_auth_cas') }
      it { is_expected.to contain_file('auth_cas.conf').with_path('/etc/httpd/conf.modules.d/auth_cas.conf') }
      it { is_expected.to contain_file('/var/cache/mod_auth_cas/').with_owner('apache') }

      it {
        expect(subject).to contain_concat__fragment('test.server-auth_cas').with(content: %r{^\s+CASRootProxiedAs http://test.server$})
        expect(subject).to contain_concat__fragment('test.server-auth_cas').with(content: %r{^\s+CASCookiePath /my/cas/path$})
      }
    end
  end
end
