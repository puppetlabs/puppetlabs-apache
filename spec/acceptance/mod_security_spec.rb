# frozen_string_literal: true

require 'spec_helper_acceptance'
apache_hash = apache_settings_hash

describe 'apache::mod::security class', if: mod_supported_on_platform?('apache::mod::security') do
  # When apache fails to (re)start, Puppet's systemd provider attaches
  # `journalctl -n 50 --since '5 minutes ago'`, which on SLES 12's systemd prints
  # the oldest 50 lines of that window, so the failed start itself is cut off.
  # Errors raised after the config is parsed (e.g. mod_unique_id's AH01564 when
  # the hostname doesn't resolve) only go to the apache error log anyway. Add
  # what's needed to diagnose the failure to the error.
  def apply_mod_security_manifest(pp)
    apply_manifest(pp, catch_failures: true)
  rescue RuntimeError => e
    raise unless e.message.match?(%r{Systemd (re)?start for apache2 failed})

    raise e.class, "#{e.message}\n#{apache_start_diagnostics}", e.backtrace
  end

  def apache_start_diagnostics
    commands = [
      'hostname',
      'getent ahostsv4 "$(hostname)"',
      'cat /etc/hosts /etc/resolv.conf',
      'systemctl status apache2 --no-pager -l',
      'journalctl -u apache2 --no-pager -n 30',
      'tail -n 30 /var/log/apache2/error.log',
      'ss -ltnp',
    ]
    # Never let a diagnostic command hide the original failure.
    diagnostics = commands.map do |command|
      result = run_shell(command, expect_failures: true)
      "====== #{command} (exit #{result.exit_code})\n#{result.stdout}#{result.stderr}"
    rescue StandardError => e
      "====== #{command} (diagnostic failed: #{e.message})"
    end
    diagnostics.join("\n")
  end

  # EXPERIMENT ONLY (MODULES-11990): record name-resolution state on every run,
  # pass or fail, so it can be correlated with the start failures. Do not merge.
  def resolution_probe(stage)
    commands = [
      'hostname; uname -n',
      'grep ^hosts: /etc/nsswitch.conf',
      'getent ahostsv4 "$(hostname)"',
      'getent ahosts "$(hostname)"',
      'cat /etc/hosts /etc/resolv.conf',
      'ls -l --time-style=full-iso /etc/hosts /etc/resolv.conf; date -u',
      '/opt/puppetlabs/bin/facter networking.hostname networking.fqdn',
      'rpm -q apache2 libapr1 glibc',
    ]
    output = commands.map { |command|
      result = run_shell(command, expect_failures: true)
      "== #{command} (exit #{result.exit_code})\n#{result.stdout}#{result.stderr}"
    }.join("\n")
    puts "MODULES-11990-PROBE #{stage} BEGIN\n#{output}\nMODULES-11990-PROBE #{stage} END"
  end

  before(:all) { resolution_probe('before') }
  after(:all) { resolution_probe('after') }

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
