# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::authnz_pam', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian OS' do
      include_examples 'Debian 8'

      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_package('libapache2-mod-authnz-pam') }
      it { is_expected.to contain_apache__mod('authnz_pam') }
    end # Debian

    context 'on a RedHat OS' do
      include_examples 'RedHat 8'

      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_package('mod_authnz_pam') }
      it { is_expected.to contain_apache__mod('authnz_pam') }
    end # Redhat
  end
end
