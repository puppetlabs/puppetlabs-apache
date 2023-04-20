# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::expires', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'with expires active', :compile do
    include_examples 'Debian 11'

    it { is_expected.to contain_apache__mod('expires') }
    it { is_expected.to contain_file('expires.conf').with(content: %r{ExpiresActive On\n}) }
  end

  context 'with expires default', :compile do
    let :pre_condition do
      'class { apache: default_mods => false }'
    end
    let :params do
      {
        'expires_default' => 'access plus 1 month'
      }
    end

    include_examples 'RedHat 7'

    it { is_expected.to contain_apache__mod('expires') }

    it {
      expect(subject).to contain_file('expires.conf').with_content(
        "ExpiresActive On\n" \
        "ExpiresDefault \"access plus 1 month\"\n",
      )
    }
  end

  context 'with expires by type', :compile do
    let :pre_condition do
      'class { apache: default_mods => false }'
    end
    let :params do
      {
        'expires_by_type' => [
          { 'text/json' => 'mod plus 1 day' },
          { 'text/html' => 'access plus 1 year' },
        ]
      }
    end

    include_examples 'RedHat 7'

    it { is_expected.to contain_apache__mod('expires') }

    it {
      expect(subject).to contain_file('expires.conf').with_content(
        "ExpiresActive On\n" \
        "ExpiresByType text/json \"mod plus 1 day\"\n" \
        "ExpiresByType text/html \"access plus 1 year\"\n",
      )
    }
  end
end
