# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::dav_svn', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian OS' do
      include_examples 'Debian 8'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('dav_svn') }
      it { is_expected.to contain_package('libapache2-svn') }
      it { is_expected.to contain_file('dav_svn.load').with_content(%r{LoadModule dav_svn_module}) }
      describe 'with parameters' do
        let :params do
          {
            'authz_svn_enabled' => true,
          }
        end

        it { is_expected.to contain_class('apache::params') }
        it { is_expected.to contain_apache__mod('dav_svn') }
        it { is_expected.to contain_package('libapache2-svn') }
        it { is_expected.to contain_apache__mod('authz_svn') }
        it { is_expected.to contain_file('authz_svn.load').with_content(%r{LoadModule authz_svn_module}) }
      end
    end
    context 'on a RedHat OS' do
      include_examples 'RedHat 6'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('dav_svn') }
      it { is_expected.to contain_package('mod_dav_svn') }
      it { is_expected.to contain_file('dav_svn.load').with_content(%r{LoadModule dav_svn_module}) }
      describe 'with parameters' do
        let :params do
          {
            'authz_svn_enabled' => true,
          }
        end

        it { is_expected.to contain_class('apache::params') }
        it { is_expected.to contain_apache__mod('dav_svn') }
        it { is_expected.to contain_package('mod_dav_svn') }
        it { is_expected.to contain_apache__mod('authz_svn') }
        it { is_expected.to contain_file('dav_svn_authz_svn.load').with_content(%r{LoadModule authz_svn_module}) }
      end
    end
    context 'on a FreeBSD OS' do
      include_examples 'FreeBSD 9'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('dav_svn') }
      it { is_expected.to contain_package('devel/subversion') }
      it { is_expected.to contain_file('dav_svn.load').with_content(%r{LoadModule dav_svn_module}) }

      describe 'with parameters' do
        let :params do
          {
            'authz_svn_enabled' => true,
          }
        end

        it { is_expected.to contain_class('apache::params') }
        it { is_expected.to contain_apache__mod('dav_svn') }
        it { is_expected.to contain_package('devel/subversion') }
        it { is_expected.to contain_apache__mod('authz_svn') }
        it { is_expected.to contain_file('dav_svn_authz_svn.load').with_content(%r{LoadModule authz_svn_module}) }
      end
    end
    context 'on a Gentoo OS', :compile do
      include_examples 'Gentoo'

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('dav_svn') }
      it { is_expected.to contain_package('dev-vcs/subversion') }
      it { is_expected.to contain_file('dav_svn.load').with_content(%r{LoadModule dav_svn_module}) }

      describe 'with parameters' do
        let :params do
          {
            'authz_svn_enabled' => true,
          }
        end

        it { is_expected.to contain_class('apache::params') }
        it { is_expected.to contain_apache__mod('dav_svn') }
        it { is_expected.to contain_package('dev-vcs/subversion') }
        it { is_expected.to contain_apache__mod('authz_svn') }
        it { is_expected.to contain_file('dav_svn_authz_svn.load').with_content(%r{LoadModule authz_svn_module}) }
      end
    end
  end
end
