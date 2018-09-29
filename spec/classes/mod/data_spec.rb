require 'spec_helper'

describe 'apache::mod::data', type: :class do
  context 'on a Debian OS' do
    let :facts do
      {
        osfamily: 'Debian',
        operatingsystemrelease: '8',
        lsbdistcodename: 'jessie',
        operatingsystem: 'Debian',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end
    let :params do
      { apache_version: '2.4' }
    end

    it { is_expected.to contain_apache__mod('data') }
  end
end
