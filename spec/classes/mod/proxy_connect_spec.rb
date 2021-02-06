# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::proxy_connect', type: :class do
  let :pre_condition do
    [
      'include apache::mod::proxy',
    ]
  end

  include_examples 'a mod class, without including apache'

  context 'with Apache version < 2.2' do
    let :params do
      {
        apache_version: '2.1',
      }
    end

    it { is_expected.not_to contain_apache__mod('proxy_connect') }
  end
  context 'with Apache version = 2.2' do
    let :params do
      {
        apache_version: '2.2',
      }
    end

    it { is_expected.to contain_apache__mod('proxy_connect') }
  end
  context 'with Apache version >= 2.4' do
    let :params do
      {
        apache_version: '2.4',
      }
    end

    it { is_expected.to contain_apache__mod('proxy_connect') }
  end
end
