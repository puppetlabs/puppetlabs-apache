# frozen_string_literal: true

require 'spec_helper_acceptance'
apache_hash = apache_settings_hash

describe 'apache::mod::security class', if: mod_supported_on_platform?('apache::mod::security') do
  # On SLES 12 the apache2 systemd restart intermittently hangs when mod_security2
  # is (re)loaded in the same run, so the Service refresh reports
  # "Systemd restart for apache2 failed" (exit 6). It is an environmental flake:
  # the generated config is valid (apache starts cleanly on a plain start) and a
  # re-apply brings the service back up. Retry the apply on that specific failure
  # so the known flake doesn't fail the suite; any other failure is raised at once.
  def apply_mod_security_manifest(pp)
    attempts = 0
    begin
      attempts += 1
      apply_manifest(pp, catch_failures: true)
    rescue RuntimeError => e
      raise e unless e.message.include?('Systemd restart for apache2 failed') && attempts < 3

      sleep 5
      retry
    end
  end

  context 'default mod security config' do
    pp = <<-MANIFEST
        class { 'apache': }
        class { 'apache::mod::security': }
    MANIFEST
    it 'succeeds in puppeting mod security' do
      apply_mod_security_manifest(pp)
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
      apply_mod_security_manifest(pp)
    end
  end
end
