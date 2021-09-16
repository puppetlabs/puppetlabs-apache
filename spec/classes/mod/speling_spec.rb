# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::speling', type: :class do
  it_behaves_like 'a mod class, without including apache'
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to contain_apache__mod('speling') }
  end

  context 'on a RedHat OS' do
    include_examples 'RedHat 6'

    it { is_expected.to contain_apache__mod('speling') }
  end
end
