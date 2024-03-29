# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::pagespeed', type: :class do
  context 'on a Debian OS' do
    include_examples 'Debian 11'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('pagespeed') }
    it { is_expected.to contain_package('mod-pagespeed-stable') }

    context 'when setting additional_configuration to a Hash' do
      let :params do
        { additional_configuration: { 'Key' => 'Value' } }
      end

      it { is_expected.to contain_file('pagespeed.conf').with_content %r{Key Value} }
    end

    context 'when setting additional_configuration to an Array' do
      let :params do
        { additional_configuration: ['Key Value'] }
      end

      it { is_expected.to contain_file('pagespeed.conf').with_content %r{Key Value} }
    end
  end

  context 'on a RedHat OS' do
    include_examples 'RedHat 8'

    it { is_expected.to contain_class('apache::params') }
    it { is_expected.to contain_apache__mod('pagespeed') }
    it { is_expected.to contain_package('mod-pagespeed-stable') }
    it { is_expected.to contain_file('pagespeed.conf') }
  end
end
