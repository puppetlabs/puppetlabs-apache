# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::proxy', type: :class do
  it_behaves_like 'a mod class, without including apache'

  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let :facts do
        os_facts
      end

      it { is_expected.to contain_file('proxy.conf').with_content(%r{ProxyRequests Off}) }
      it { is_expected.to contain_file('proxy.conf').without_content(%r{ProxyTimeout}) }
      context 'with parameters set' do
        let(:params) do
          { proxy_timeout: 12_345 }
        end

        it { is_expected.to contain_file('proxy.conf').with_content(%r{ProxyTimeout 12345}) }
      end
    end
  end
end
