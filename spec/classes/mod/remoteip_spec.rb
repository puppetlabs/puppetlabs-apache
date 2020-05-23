require 'spec_helper'

describe 'apache::mod::remoteip', type: :class do
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

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('remoteip') }
    it {
      is_expected.to contain_file('remoteip.conf').with('path' => '/etc/apache2/mods-available/remoteip.conf')
    }

    describe 'with header X-Forwarded-For' do
      let :params do
        { header: 'X-Forwarded-For' }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPHeader X-Forwarded-For$}) }
    end
    describe 'with internal_proxy => [ 10.42.17.8, 10.42.18.99 ]' do
      let :params do
        { internal_proxy: ['10.42.17.8', '10.42.18.99'] }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPInternalProxy 10.42.17.8$}) }
      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPInternalProxy 10.42.18.99$}) }
    end
    describe 'with IPv4 CIDR in internal_proxy => [ 192.168.1.0/24 ]' do
      let :params do
        { internal_proxy: ['192.168.1.0/24'] }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPInternalProxy 192.168.1.0/24$}) }
    end
    describe 'with IPv6 CIDR in internal_proxy => [ fd00:fd00:fd00:2000::/64 ]' do
      let :params do
        { internal_proxy: ['fd00:fd00:fd00:2000::/64'] }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPInternalProxy fd00:fd00:fd00:2000::/64$}) }
    end
    describe 'with proxy_ips => [ 10.42.17.8, 10.42.18.99 ]' do
      let :params do
        { proxy_ips: ['10.42.17.8', '10.42.18.99'] }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPInternalProxy 10.42.17.8$}) }
      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPInternalProxy 10.42.18.99$}) }
    end
    describe 'with IPv4 CIDR in proxy_ips => [ 192.168.1.0/24 ]' do
      let :params do
        { proxy_ips: ['192.168.1.0/24'] }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPInternalProxy 192.168.1.0/24$}) }
    end
    describe 'with IPv6 CIDR in proxy_ips => [ fd00:fd00:fd00:2000::/64 ]' do
      let :params do
        { proxy_ips: ['fd00:fd00:fd00:2000::/64'] }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPInternalProxy fd00:fd00:fd00:2000::/64$}) }
    end
    describe 'with trusted_proxy => [ 10.42.17.8, 10.42.18.99 ]' do
      let :params do
        { trusted_proxy: ['10.42.17.8', '10.42.18.99'] }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPTrustedProxy 10.42.17.8$}) }
      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPTrustedProxy 10.42.18.99$}) }
    end
    describe 'with trusted_proxy_ips => [ 10.42.17.8, 10.42.18.99 ]' do
      let :params do
        { trusted_proxy: ['10.42.17.8', '10.42.18.99'] }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPTrustedProxy 10.42.17.8$}) }
      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPTrustedProxy 10.42.18.99$}) }
    end
    describe 'with proxy_protocol_exceptions => [ 10.42.17.8, 10.42.18.99 ]' do
      let :params do
        { proxy_protocol_exceptions: ['10.42.17.8', '10.42.18.99'] }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPProxyProtocolExceptions 10.42.17.8$}) }
      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPProxyProtocolExceptions 10.42.18.99$}) }
    end
    describe 'with IPv4 CIDR in proxy_protocol_exceptions => [ 192.168.1.0/24 ]' do
      let :params do
        { proxy_protocol_exceptions: ['192.168.1.0/24'] }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPProxyProtocolExceptions 192.168.1.0/24$}) }
    end
    describe 'with IPv6 CIDR in proxy_protocol_exceptions => [ fd00:fd00:fd00:2000::/64 ]' do
      let :params do
        { proxy_protocol_exceptions: ['fd00:fd00:fd00:2000::/64'] }
      end

      it { is_expected.to contain_file('remoteip.conf').with_content(%r{^RemoteIPProxyProtocolExceptions fd00:fd00:fd00:2000::/64$}) }
    end
    describe 'with Apache version < 2.4' do
      let :params do
        { apache_version: '2.2' }
      end

      it { expect { catalogue }.to raise_error(Puppet::Error, %r{mod_remoteip is only available in Apache 2.4}) }
    end
  end
end
