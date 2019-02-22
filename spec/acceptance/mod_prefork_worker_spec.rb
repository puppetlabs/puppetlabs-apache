require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'prefork_worker_spec.rb' do
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
      if os[:family] == 'debian' && os[:release].to_i == 8
        pending 'Should be enabled - Bug 760616 on Debian 8'
      elsif os[:family] == 'sles' && os[:release].to_i == 15
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
      if os[:family] == 'debian' && os[:release].to_i == 8
        pending 'Should be enabled - Bug 760616 on Debian 8'
      elsif os[:family] == 'sles' && os[:release].to_i == 15
        pending 'Should be enabled - MODULES-8379 `be_enabled` check does not currently work for apache2 on SLES 15'
      else
        it { is_expected.to be_enabled }
      end
    end
  end
end
