# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::log_forensic', type: :class do
  ['Debian 11', 'RedHat 8'].each do |os|
    context "on a #{os} OS" do
      include_examples os

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_class('apache::mod::log_forensic') }
      it { is_expected.to contain_apache__mod('log_forensic') }
      it { is_expected.to contain_file('log_forensic.load').with_content(%r{LoadModule log_forensic_module}) }
    end
  end
end
