# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::authn_dbd', type: :class do
  context 'default params' do
    let :params do
      {
        authn_dbd_params: 'host=db_host port=3306 user=apache password=###### dbname=apache_auth',
      }
    end

    it_behaves_like 'a mod class, without including apache'
  end

  context 'default configuration with parameters' do
    let :params do
      {
        authn_dbd_params: 'host=db_host port=3306 user=apache password=###### dbname=apache_auth',
        authn_dbd_alias: 'db_authn',
        authn_dbd_query: 'SELECT password FROM authn WHERE username = %s',
      }
    end

    context 'on a Debian OS', :compile do
      include_examples 'Debian 11'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('authn_dbd') }
      it { is_expected.to contain_apache__mod('dbd') }
      it { is_expected.to contain_file('authn_dbd.conf').with_path('/etc/apache2/mods-available/authn_dbd.conf') }
    end

    context 'on a RedHat OS', :compile do
      include_examples 'RedHat 8'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('authn_dbd') }
      it { is_expected.to contain_apache__mod('dbd') }
      it { is_expected.to contain_file('authn_dbd.conf').with_path('/etc/httpd/conf.modules.d/authn_dbd.conf') }
    end
  end
end
