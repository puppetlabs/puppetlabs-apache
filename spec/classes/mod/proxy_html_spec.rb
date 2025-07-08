# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::proxy_html', type: :class do
  let :pre_condition do
    [
      'include apache::mod::proxy',
      'include apache::mod::proxy_http',
    ]
  end

  it_behaves_like 'a mod class, without including apache'
  context 'on a Debian OS' do
    shared_examples 'debian' do |loadfiles|
      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('proxy_html').with(loadfiles:) }
    end

    include_examples 'Debian 11'

    context 'on i386' do
      let(:facts) { override_facts(super(), os: { hardware: 'i386' }) }

      it { is_expected.to contain_apache__mod('xml2enc').with(loadfiles: nil) }

      it_behaves_like 'debian', ['/usr/lib/i386-linux-gnu/libxml2.so.2']
    end

    context 'on x64' do
      let(:facts) { override_facts(super(), os: { architecture: 'x86_64' }) }

      it { is_expected.to contain_apache__mod('xml2enc').with(loadfiles: nil) }

      it_behaves_like 'debian', ['/usr/lib/x86_64-linux-gnu/libxml2.so.2']
    end
  end

  context 'on a RedHat OS', :compile do
    include_examples 'RedHat 8'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('proxy_html').with(loadfiles: nil) }
    it { is_expected.to contain_package('mod_proxy_html') }
    it { is_expected.to contain_apache__mod('xml2enc').with(loadfiles: nil) }
  end

  context 'on a FreeBSD OS', :compile do
    include_examples 'FreeBSD 9'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('proxy_html').with(loadfiles: nil) }
    it { is_expected.to contain_apache__mod('xml2enc').with(loadfiles: nil) }
  end

  context 'on a Gentoo OS', :compile do
    include_examples 'Gentoo'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('proxy_html').with(loadfiles: nil) }
    it { is_expected.to contain_apache__mod('xml2enc').with(loadfiles: nil) }
    it { is_expected.to contain_package('www-apache/mod_proxy_html') }
  end
end
