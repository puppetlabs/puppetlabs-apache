# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::lookup_identity', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian OS' do
      include_examples 'Debian 11'

      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_package('libapache2-mod-lookup-identity') }
      it { is_expected.to contain_apache__mod('lookup_identity') }
    end # Debian

    context 'on a RedHat OS' do
      include_examples 'RedHat 8'

      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_package('mod_lookup_identity') }
      it { is_expected.to contain_apache__mod('lookup_identity') }
    end # Redhat
  end
end
