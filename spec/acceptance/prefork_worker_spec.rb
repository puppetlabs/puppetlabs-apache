require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'prefork_worker_spec.rb' do
  case os[:family]
  when 'freebsd'
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
  end
end
