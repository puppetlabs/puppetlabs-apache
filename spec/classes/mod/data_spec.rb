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

    describe 'with Apache version < 2.3' do
      let :params do
        { apache_version: '2.2' }
      end

      it 'fails' do
        expect { catalogue }.to raise_error(Puppet::Error, %r{mod_data is only available in Apache 2.3 and later})
      end
    end
  end
end
