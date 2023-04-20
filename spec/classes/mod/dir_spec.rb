# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::dir', type: :class do
  ['Debian 11', 'RedHat 8', 'FreeBSD 9', 'Gentoo'].each do |os|
    context "default configuration with parameters on #{os}" do
      include_examples os

      context 'passing no parameters' do
        it { is_expected.to contain_class('apache::params') }
        it { is_expected.to contain_apache__mod('dir') }

        it do
          is_expected.to contain_file('dir.conf')
            .with_content(%r{^DirectoryIndex })
            .with_content(%r{ index\.html })
            .with_content(%r{ index\.html\.var })
            .with_content(%r{ index\.cgi })
            .with_content(%r{ index\.pl })
            .with_content(%r{ index\.php })
            .with_content(%r{ index\.xhtml$})
        end
      end
      context "passing indexes => ['example.txt','fearsome.aspx']" do
        let :params do
          { indexes: ['example.txt', 'fearsome.aspx'] }
        end

        it { is_expected.to contain_file('dir.conf').with_content(%r{ example\.txt }).with_content(%r{ fearsome\.aspx$}) }
      end
    end
  end
end
