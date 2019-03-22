require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'prefork_worker_spec.rb' do
  case host_inventory['facter']['os']['family']
  when 'FreeBSD'
    describe 'apache::mod::event class' do
      describe 'running puppet code' do
        # Using puppet_apply as a helper
        pp = <<-MANIFEEST
            class { 'apache':
              mpm_module => 'event',
            }
        MANIFEEST
        it 'works with no errors' do
          # Run it twice and test for idempotency
          apply_manifest(pp, catch_failures: true)
          expect(apply_manifest(pp, catch_failures: true).exit_code).to be_zero
        end
      end

      describe service($service_name) do
        it { is_expected.to be_running }
        if host_inventory['facter']['os']['name'] == 'Debian' && host_inventory['facter']['os']['release']['major'] == '8'
          pending 'Should be enabled - Bug 760616 on Debian 8'
        elsif host_inventory['facter']['os']['name'] == 'SLES' && host_inventory['facter']['os']['release']['major'] == '15'
          pending 'Should be enabled - MODULES-8379 `be_enabled` check does not currently work for apache2 on SLES 15'
        else
          it { is_expected.to be_enabled }
        end
      end
    end
  end

  describe 'apache::mod::worker class' do
    describe 'running puppet code' do
      # Using puppet_apply as a helper
      let(:pp) do
        <<-MANIFEEST
          class { 'apache':
            mpm_module => 'worker',
          }
        MANIFEEST
      end

      # Run it twice and test for idempotency
      it_behaves_like 'a idempotent resource'
    end

    describe service($service_name) do
      it { is_expected.to be_running }
      if host_inventory['facter']['os']['name'] == 'Debian' && host_inventory['facter']['os']['release']['major'] == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      elsif host_inventory['facter']['os']['name'] == 'SLES' && host_inventory['facter']['os']['release']['major'] == '15'
        pending 'Should be enabled - MODULES-8379 `be_enabled` check does not currently work for apache2 on SLES 15'
      else
        it { is_expected.to be_enabled }
      end
    end
  end

  describe 'apache::mod::prefork class' do
    describe 'running puppet code' do
      # Using puppet_apply as a helper
      let(:pp) do
        <<-MANIFEEST
          class { 'apache':
            mpm_module => 'prefork',
          }
        MANIFEEST
      end

      # Run it twice and test for idempotency
      it_behaves_like 'a idempotent resource'
    end

    describe service($service_name) do
      it { is_expected.to be_running }
      if host_inventory['facter']['os']['name'] == 'Debian' && host_inventory['facter']['os']['release']['major'] == '8'
        pending 'Should be enabled - Bug 760616 on Debian 8'
      elsif host_inventory['facter']['os']['name'] == 'SLES' && host_inventory['facter']['os']['release']['major'] == '15'
        pending 'Should be enabled - MODULES-8379 `be_enabled` check does not currently work for apache2 on SLES 15'
      else
        it { is_expected.to be_enabled }
      end
    end
  end
end
