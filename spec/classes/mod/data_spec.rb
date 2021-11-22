# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::data', type: :class do
  context 'on a Debian OS' do
    include_examples 'Debian 11'
    let :params do
      { apache_version: '2.4' }
    end

    it { is_expected.to contain_apache__mod('data') }

    describe 'with Apache version < 2.3' do
      let :params do
        { apache_version: '2.2' }
      end

      it { is_expected.to compile.and_raise_error(%r{mod_data is only available in Apache 2.3 and later}) }
    end
  end
end
