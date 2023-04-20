# frozen_string_literal: true

require 'spec_helper'

describe 'apache::vhost::custom', type: :define do
  let :title do
    'rspec.example.com'
  end
  let(:params) do
    {
      content: 'foobar'
    }
  end

  describe 'os-dependent items' do
    context 'on RedHat based systems' do
      include_examples 'RedHat 8'

      it { is_expected.to compile }
    end
    context 'on Debian based systems' do
      include_examples 'Debian 11'

      it {
        is_expected.to contain_file('apache_rspec.example.com').with(
          ensure: 'present',
          content: 'foobar',
          path: '/etc/apache2/sites-available/25-rspec.example.com.conf',
        )
      }
      it {
        is_expected.to contain_file('25-rspec.example.com.conf symlink').with(
          ensure: 'link',
          path: '/etc/apache2/sites-enabled/25-rspec.example.com.conf',
          target: '/etc/apache2/sites-available/25-rspec.example.com.conf',
        )
      }
    end
    context 'on FreeBSD systems' do
      include_examples 'FreeBSD 9'

      it {
        is_expected.to contain_file('apache_rspec.example.com').with(
          ensure: 'present',
          content: 'foobar',
          path: '/usr/local/etc/apache24/Vhosts/25-rspec.example.com.conf',
        )
      }
    end
    context 'on Gentoo systems' do
      include_examples 'Gentoo'

      it {
        is_expected.to contain_file('apache_rspec.example.com').with(
          ensure: 'present',
          content: 'foobar',
          path: '/etc/apache2/vhosts.d/25-rspec.example.com.conf',
        )
      }
    end
  end
end
