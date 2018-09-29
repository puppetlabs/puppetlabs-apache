require 'spec_helper'

describe 'apache::mod::fcgid', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'on a Debian OS' do
    let :facts do
      {
        osfamily: 'Debian',
        operatingsystemrelease: '8',
        operatingsystemmajrelease: '8',
        lsbdistcodename: 'jessie',
        operatingsystem: 'Debian',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it {
      is_expected.to contain_apache__mod('fcgid').with('loadfile_name' => nil)
    }
    it { is_expected.to contain_package('libapache2-mod-fcgid') }
  end

  context 'on RHEL7' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystemrelease: '7',
        operatingsystemmajrelease: '7',
        operatingsystem: 'RedHat',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    describe 'without parameters' do
      it { is_expected.to contain_class('apache::params') }
      it {
        is_expected.to contain_apache__mod('fcgid').with('loadfile_name' => 'unixd_fcgid.load')
      }
      it { is_expected.to contain_package('mod_fcgid') }
    end
  end

  context 'on a FreeBSD OS' do
    let :facts do
      {
        osfamily: 'FreeBSD',
        operatingsystemrelease: '10',
        operatingsystemmajrelease: '10',
        operatingsystem: 'FreeBSD',
        id: 'root',
        kernel: 'FreeBSD',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it {
      is_expected.to contain_apache__mod('fcgid').with('loadfile_name' => 'unixd_fcgid.load')
    }
    it { is_expected.to contain_package('www/mod_fcgid') }
  end

  context 'on a Gentoo OS' do
    let :facts do
      {
        osfamily: 'Gentoo',
        operatingsystem: 'Gentoo',
        operatingsystemrelease: '3.16.1-gentoo',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it {
      is_expected.to contain_apache__mod('fcgid').with('loadfile_name' => nil)
    }
    it { is_expected.to contain_package('www-apache/mod_fcgid') }
  end
end
