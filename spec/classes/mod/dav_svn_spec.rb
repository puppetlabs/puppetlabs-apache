require 'spec_helper'

describe 'apache::mod::dav_svn', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian OS' do
      let :facts do
        {
          lsbdistcodename: 'jessie',
          osfamily: 'Debian',
          operatingsystemrelease: '8',
          operatingsystemmajrelease: '8',
          operatingsystem: 'Debian',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

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
      let :facts do
        {
          osfamily: 'RedHat',
          operatingsystemrelease: '6',
          operatingsystemmajrelease: '6',
          operatingsystem: 'RedHat',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

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
      let :facts do
        {
          osfamily: 'FreeBSD',
          operatingsystemrelease: '9',
          operatingsystemmajrelease: '9',
          operatingsystem: 'FreeBSD',
          id: 'root',
          kernel: 'Linux',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

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
      let :facts do
        {
          id: 'root',
          operatingsystemrelease: '3.16.1-gentoo',
          kernel: 'Linux',
          osfamily: 'Gentoo',
          operatingsystem: 'Gentoo',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
          is_pe: false,
        }
      end

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
