# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::shib', type: :class do
  it_behaves_like 'a mod class, without including apache'
  context 'on a Debian OS' do
    include_examples 'Debian 8'

    describe 'with no parameters' do
      it { is_expected.to contain_apache__mod('shib2').with_id('mod_shib') }
    end
  end
  context 'on a RedHat OS' do
    include_examples 'RedHat 6'

    describe 'with no parameters' do
      it { is_expected.to contain_apache__mod('shib2').with_id('mod_shib') }
    end
  end
end
