# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::proxy_connect', type: :class do
  let :pre_condition do
    [
      'include apache::mod::proxy',
    ]
  end

  it_behaves_like 'a mod class, without including apache'
  context 'on a Debian OS' do
    context 'with Apache version < 2.2' do
      include_examples 'Debian 7'
      let :params do
        {
          apache_version: '2.1',
        }
      end

      it { is_expected.not_to contain_apache__mod('proxy_connect') }
    end
    context 'with Apache version = 2.2' do
      include_examples 'Debian 7'
      let :params do
        {
          apache_version: '2.2',
        }
      end

      it { is_expected.to contain_apache__mod('proxy_connect') }
    end
    context 'with Apache version >= 2.4' do
      include_examples 'Debian 8'
      let :params do
        {
          apache_version: '2.4',
        }
      end

      it { is_expected.to contain_apache__mod('proxy_connect') }
    end
  end
end
