require 'spec_helper'

describe 'apache::mod::fastcgi', type: :class do
  it_behaves_like 'a mod class, without including apache'
  context 'on a Debian OS' do
    let :facts do
      {
        osfamily: 'Debian',
        operatingsystemrelease: '8',
        lsbdistcodename: 'squeze',
        operatingsystem: 'Debian',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('fastcgi') }
    it { is_expected.to contain_package('libapache2-mod-fastcgi') }
    it { is_expected.to contain_file('fastcgi.conf') }
  end
end
