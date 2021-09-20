# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::intercept_form_submit', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian OS' do
      include_examples 'Debian 11'

      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_package('libapache2-mod-intercept-form-submit') }
      it { is_expected.to contain_apache__mod('intercept_form_submit') }
    end # Debian

    context 'on a RedHat OS' do
      include_examples 'RedHat 6'

      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_package('mod_intercept_form_submit') }
      it { is_expected.to contain_apache__mod('intercept_form_submit') }
    end # Redhat
  end
end
