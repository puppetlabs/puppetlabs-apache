require 'spec_helper_acceptance'
require_relative './version.rb'

case fact('osfamily')
when 'FreeBSD'
  describe 'apache::mod::event class' do
    describe 'running puppet code' do
      # Using puppet_apply as a helper
      it 'should work with no errors' do
        pp = <<-EOS
          class { 'apache':
            mpm_module => 'event',
          }
        EOS

        # Run it twice and test for idempotency
        execute_manifest(pp, :catch_failures => true)
        expect(execute_manifest(pp, :catch_failures => true).exit_code).to be_zero
      end
    end

    describe service($service_name) do
      it { is_expected.to be_running }
      if (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8')
        pending 'Should be enabled - Bug 760616 on Debian 8'
      else
        it { should be_enabled }
      end
    end
  end
end

describe 'apache::mod::worker class' do
  describe 'running puppet code' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
        class { 'apache':
          mpm_module => 'worker',
        }
      EOS

      # Run it twice and test for idempotency
      execute_manifest(pp, :catch_failures => true)
      expect(execute_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
  end

  describe service($service_name) do
    it { is_expected.to be_running }
    if (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8')
      pending 'Should be enabled - Bug 760616 on Debian 8'
    else
      it { should be_enabled }
    end
  end
end

describe 'apache::mod::prefork class' do
  describe 'running puppet code' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
        class { 'apache':
          mpm_module => 'prefork',
        }
      EOS

      # Run it twice and test for idempotency
      execute_manifest(pp, :catch_failures => true)
      expect(execute_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
  end

  describe service($service_name) do
    it { is_expected.to be_running }
    if (fact('operatingsystem') == 'Debian' && fact('operatingsystemmajrelease') == '8')
      pending 'Should be enabled - Bug 760616 on Debian 8'
    else
      it { should be_enabled }
    end
  end
end
