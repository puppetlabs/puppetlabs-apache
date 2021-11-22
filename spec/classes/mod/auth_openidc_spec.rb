# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::auth_openidc', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian OS', :compile do
      include_examples 'Debian 11'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('auth_openidc') }
      it { is_expected.to contain_package('libapache2-mod-auth-openidc') }
    end
    context 'on a RedHat OS', :compile do
      include_examples 'RedHat 6'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('auth_openidc') }
      it { is_expected.to contain_package('mod_auth_openidc') }
    end
    context 'on a FreeBSD OS', :compile do
      include_examples 'FreeBSD 9'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('auth_openidc') }
      it { is_expected.to contain_package('www/mod_auth_openidc') }
    end
  end
  context 'overriding mod_packages' do
    context 'on a RedHat OS', :compile do
      include_examples 'RedHat 6'
      let :pre_condition do
        <<-MANIFEST
        include apache::params
        class { 'apache':
          mod_packages => merge($::apache::params::mod_packages, {
            'auth_openidc' => 'httpd24-mod_auth_openidc',
          })
        }
        MANIFEST
      end

      it { is_expected.to contain_apache__mod('auth_openidc') }
      it { is_expected.to contain_package('httpd24-mod_auth_openidc') }
      it { is_expected.not_to contain_package('mod_auth_openidc') }
    end
  end
end
