require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'apache::default_mods class' do
  describe 'no default mods' do
    # Using puppet_apply as a helper
    it 'should apply with no errors' do
      pp = <<-EOS
        class { 'apache':
          default_mods => false,
        }
      EOS

      # Run it twice and test for idempotency
      execute_manifest(pp, :catch_failures => true)
      expect(execute_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    describe service($service_name) do
      it { is_expected.to be_running }
    end
  end

  describe 'no default mods and failing' do
    # Using puppet_apply as a helper
    it 'should apply with errors' do
      pp = <<-EOS
        class { 'apache':
          default_mods => false,
        }
        apache::vhost { 'defaults.example.com':
          docroot => '/var/www/defaults',
          aliases => {
            alias => '/css',
            path  => '/var/www/css',
          },
          setenv  => 'TEST1 one',
        }
      EOS

      execute_manifest(pp, { :expect_failures => true })
    end

    # Are these the same?
    describe service($service_name) do
      it { is_expected.not_to be_running }
    end
    describe "service #{$service_name}" do
      it 'should not be running' do
        shell("pidof #{$service_name}", {:acceptable_exit_codes => 1})
      end
    end
  end

  describe 'alternative default mods' do
    # Using puppet_apply as a helper
    it 'should apply with no errors' do
      pp = <<-EOS
        class { 'apache':
          default_mods => [
            'info',
            'alias',
            'mime',
            'env',
            'expires',
          ],
        }
        apache::vhost { 'defaults.example.com':
          docroot => '/var/www/defaults',
          aliases => {
            alias => '/css',
            path  => '/var/www/css',
          },
          setenv  => 'TEST1 one',
        }
      EOS

      execute_manifest(pp, :catch_failures => true)
      shell('sleep 10')
      expect(execute_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    describe service($service_name) do
      it { is_expected.to be_running }
    end
  end

  describe 'change loadfile name' do
    it 'should apply with no errors' do
      pp = <<-EOS
        class { 'apache': default_mods => false }
        ::apache::mod { 'auth_basic':
          loadfile_name => 'zz_auth_basic.load',
        }
      EOS
      # Run it twice and test for idempotency
      execute_manifest(pp, :catch_failures => true)
      expect(execute_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    describe service($service_name) do
      it { is_expected.to be_running }
    end

    describe file("#{$mod_dir}/zz_auth_basic.load") do
      it { is_expected.to be_file }
    end
  end
end
