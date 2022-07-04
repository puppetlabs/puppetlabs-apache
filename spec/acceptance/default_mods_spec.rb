# frozen_string_literal: true

require 'spec_helper_acceptance'
apache_hash = apache_settings_hash
describe 'apache::default_mods class' do
  describe 'no default mods' do
    # Using puppet_apply as a helper
    let(:pp) do
      <<-MANIFEST
        class { 'apache':
          default_mods => false,
        }
      MANIFEST
    end

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_running }
    end
  end

  describe 'alternative default mods' do
    # Using puppet_apply as a helper
    let(:pp) do
      <<-MANIFEST
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
          docroot => '#{apache_hash['doc_root']}/defaults',
          aliases => [
            {
              alias => '/css',
              path  => '#{apache_hash['doc_root']}/css',
            },
          ],
          setenv  => 'TEST1 one',
        }
      MANIFEST
    end

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_running }
    end
  end

  describe 'change loadfile name' do
    let(:pp) do
      <<-MANIFEST
        class { 'apache': default_mods => false }
        ::apache::mod { 'auth_basic':
          loadfile_name => 'zz_auth_basic.load',
        }
      MANIFEST
    end

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_running }
    end

    describe file("#{apache_hash['mod_dir']}/zz_auth_basic.load") do
      it { is_expected.to be_file }
    end
  end
end
