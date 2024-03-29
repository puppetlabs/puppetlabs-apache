# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::rpaf', type: :class do
  it_behaves_like 'a mod class, without including apache'
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('rpaf') }
    it { is_expected.to contain_package('libapache2-mod-rpaf') }

    it {
      expect(subject).to contain_file('rpaf.conf').with('path' => '/etc/apache2/mods-available/rpaf.conf')
    }

    it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFenable On$}) }

    describe 'with sethostname => true' do
      let :params do
        { sethostname: 'true' }
      end

      it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFsethostname On$}) }
    end

    describe 'with proxy_ips => [ 10.42.17.8, 10.42.18.99 ]' do
      let :params do
        { proxy_ips: ['10.42.17.8', '10.42.18.99'] }
      end

      it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFproxy_ips 10.42.17.8 10.42.18.99$}) }
    end

    describe 'with header => X-Real-IP' do
      let :params do
        { header: 'X-Real-IP' }
      end

      it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFheader X-Real-IP$}) }
    end
  end

  context 'on a FreeBSD OS' do
    include_examples 'FreeBSD 9'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('rpaf') }
    it { is_expected.to contain_package('www/mod_rpaf2') }

    it {
      expect(subject).to contain_file('rpaf.conf').with('path' => '/usr/local/etc/apache24/Modules/rpaf.conf')
    }

    it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFenable On$}) }

    describe 'with sethostname => true' do
      let :params do
        { sethostname: 'true' }
      end

      it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFsethostname On$}) }
    end

    describe 'with proxy_ips => [ 10.42.17.8, 10.42.18.99 ]' do
      let :params do
        { proxy_ips: ['10.42.17.8', '10.42.18.99'] }
      end

      it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFproxy_ips 10.42.17.8 10.42.18.99$}) }
    end

    describe 'with header => X-Real-IP' do
      let :params do
        { header: 'X-Real-IP' }
      end

      it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFheader X-Real-IP$}) }
    end
  end

  context 'on a Gentoo OS' do
    include_examples 'Gentoo'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('rpaf') }
    it { is_expected.to contain_package('www-apache/mod_rpaf') }

    it {
      expect(subject).to contain_file('rpaf.conf').with('path' => '/etc/apache2/modules.d/rpaf.conf')
    }

    it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFenable On$}) }

    describe 'with sethostname => true' do
      let :params do
        { sethostname: 'true' }
      end

      it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFsethostname On$}) }
    end

    describe 'with proxy_ips => [ 10.42.17.8, 10.42.18.99 ]' do
      let :params do
        { proxy_ips: ['10.42.17.8', '10.42.18.99'] }
      end

      it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFproxy_ips 10.42.17.8 10.42.18.99$}) }
    end

    describe 'with header => X-Real-IP' do
      let :params do
        { header: 'X-Real-IP' }
      end

      it { is_expected.to contain_file('rpaf.conf').with_content(%r{^RPAFheader X-Real-IP$}) }
    end
  end
end
