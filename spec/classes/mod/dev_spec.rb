# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::dev', type: :class do
  let(:pre_condition) do
    [
      'include apache',
    ]
  end

  it_behaves_like 'a mod class, without including apache'

  ['RedHat 6', 'Debian 8', 'FreeBSD 9'].each do |os|
    context "on a #{os} OS" do
      include_examples os

      it { is_expected.to contain_class('apache::dev') }
    end
  end
end
