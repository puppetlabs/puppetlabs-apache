# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::proxy_http2' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('apache::mod::proxy') }
      it { is_expected.to contain_apache__mod('proxy_http2') }
    end
  end
end
