# frozen_string_literal: true

require 'spec_helper_acceptance'
apache_hash = apache_settings_hash

describe 'apache::mod::security class', if: mod_supported_on_platform?('apache::mod::security') do
  context 'default mod security config' do
    pp = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::security': }
    MANIFEST
    it 'succeeds in puppeting mod security' do
      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'with vhost config' do
    pp = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::security': }
        apache::vhost { 'modsecurity.example.com':
          port    => 80,
          docroot => '#{apache_hash['doc_root']}',
        }
        host { 'modsecurity.example.com': ip => '127.0.0.1', }
    MANIFEST
    it 'succeeds in puppeting mod security' do
      apply_manifest(pp, catch_failures: true)
    end
  end
end
