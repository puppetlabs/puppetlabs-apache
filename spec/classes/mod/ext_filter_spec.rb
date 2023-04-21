# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::ext_filter', type: :class do
  it_behaves_like 'a mod class, without including apache'
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    describe 'with no parameters' do
      it { is_expected.to contain_apache__mod('ext_filter') }
      it { is_expected.not_to contain_file('ext_filter.conf') }
    end

    describe 'with parameters' do
      let :params do
        { ext_filter_define: { 'filtA' => 'input=A output=B',
                               'filtB' => 'input=C cmd="C"' }  }
      end

      it { is_expected.to contain_file('ext_filter.conf').with_content(%r{^ExtFilterDefine\s+filtA\s+input=A output=B$}) }
      it { is_expected.to contain_file('ext_filter.conf').with_content(%r{^ExtFilterDefine\s+filtB\s+input=C cmd="C"$}) }
    end
  end

  context 'on a RedHat OS' do
    include_examples 'RedHat 8'

    describe 'with no parameters' do
      it { is_expected.to contain_apache__mod('ext_filter') }
      it { is_expected.not_to contain_file('ext_filter.conf') }
    end

    describe 'with parameters' do
      let :params do
        { ext_filter_define: { 'filtA' => 'input=A output=B',
                               'filtB' => 'input=C cmd="C"' }  }
      end

      it { is_expected.to contain_file('ext_filter.conf').with_path('/etc/httpd/conf.modules.d/ext_filter.conf') }
      it { is_expected.to contain_file('ext_filter.conf').with_content(%r{^ExtFilterDefine\s+filtA\s+input=A output=B$}) }
      it { is_expected.to contain_file('ext_filter.conf').with_content(%r{^ExtFilterDefine\s+filtB\s+input=C cmd="C"$}) }
    end
  end
end
