require 'spec_helper'

describe 'apache::dev', type: :class do
  let(:pre_condition) do
    [
      'include apache',
    ]
  end

  context 'on a Debian OS' do
    let :facts do
      {
        lsbdistcodename: 'jessie',
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        operatingsystemrelease: '6',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
        kernel: 'Linux',
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_package('libaprutil1-dev') }
    it { is_expected.to contain_package('libapr1-dev') }
    it { is_expected.to contain_package('apache2-prefork-dev') }
  end
  context 'on an Ubuntu 16 OS' do
    let :facts do
      {
        lsbdistrelease: '16.04',
        lsbdistcodename: 'xenial',
        osfamily: 'Debian',
        operatingsystem: 'Ubuntu',
        operatingsystemrelease: '16.04',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
        kernel: 'Linux',
      }
    end

    it { is_expected.to contain_package('apache2-dev') }
  end
  context 'on a RedHat OS' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        operatingsystemrelease: '6',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
        kernel: 'Linux',
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_package('httpd-devel') }
  end
  context 'on a FreeBSD OS' do
    let :facts do
      {
        osfamily: 'FreeBSD',
        operatingsystem: 'FreeBSD',
        operatingsystemrelease: '9',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
        kernel: 'FreeBSD',
      }
    end

    it { is_expected.to contain_class('apache::params') }
  end
  context 'on a Gentoo OS' do
    let :facts do
      {
        osfamily: 'Gentoo',
        operatingsystem: 'Gentoo',
        operatingsystemrelease: '3.16.1-gentoo',
        is_pe: false,
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
        kernel: 'Linux',
      }
    end

    it { is_expected.to contain_class('apache::params') }
  end
end
