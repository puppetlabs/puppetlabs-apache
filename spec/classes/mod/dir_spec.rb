# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::dir', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters on a Debian OS' do
    include_examples 'Debian 8'

    context 'passing no parameters' do
      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('dir') }
      it { is_expected.to contain_file('dir.conf').with_content(%r{^DirectoryIndex }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.html }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.html\.var }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.cgi }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.pl }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.php }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.xhtml$}) }
    end
    context "passing indexes => ['example.txt','fearsome.aspx']" do
      let :params do
        { indexes: ['example.txt', 'fearsome.aspx'] }
      end

      it { is_expected.to contain_file('dir.conf').with_content(%r{ example\.txt }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ fearsome\.aspx$}) }
    end
  end
  context 'default configuration with parameters on a RedHat OS' do
    include_examples 'RedHat 6'

    context 'passing no parameters' do
      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('dir') }
      it { is_expected.to contain_file('dir.conf').with_content(%r{^DirectoryIndex }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.html }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.html\.var }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.cgi }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.pl }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.php }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.xhtml$}) }
    end
    context "passing indexes => ['example.txt','fearsome.aspx']" do
      let :params do
        { indexes: ['example.txt', 'fearsome.aspx'] }
      end

      it { is_expected.to contain_file('dir.conf').with_content(%r{ example\.txt }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ fearsome\.aspx$}) }
    end
  end
  context 'default configuration with parameters on a FreeBSD OS' do
    include_examples 'FreeBSD 9'

    context 'passing no parameters' do
      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('dir') }
      it { is_expected.to contain_file('dir.conf').with_content(%r{^DirectoryIndex }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.html }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.html\.var }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.cgi }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.pl }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.php }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.xhtml$}) }
    end
    context "passing indexes => ['example.txt','fearsome.aspx']" do
      let :params do
        { indexes: ['example.txt', 'fearsome.aspx'] }
      end

      it { is_expected.to contain_file('dir.conf').with_content(%r{ example\.txt }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ fearsome\.aspx$}) }
    end
  end
  context 'default configuration with parameters on a Gentoo OS' do
    include_examples 'Gentoo'

    context 'passing no parameters' do
      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('dir') }
      it { is_expected.to contain_file('dir.conf').with_content(%r{^DirectoryIndex }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.html }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.html\.var }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.cgi }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.pl }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.php }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ index\.xhtml$}) }
    end
    context "passing indexes => ['example.txt','fearsome.aspx']" do
      let :params do
        { indexes: ['example.txt', 'fearsome.aspx'] }
      end

      it { is_expected.to contain_file('dir.conf').with_content(%r{ example\.txt }) }
      it { is_expected.to contain_file('dir.conf').with_content(%r{ fearsome\.aspx$}) }
    end
  end
end
