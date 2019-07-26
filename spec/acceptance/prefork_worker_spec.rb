require 'spec_helper_acceptance'
apache_hash = apache_settings_hash
describe 'prefork_worker_spec.rb', unless: (os[:family] =~ %r{sles}) do
  describe 'apache::mod::event class' do
    describe 'running puppet code' do
      let(:pp) do
        <<-MANIFEEST
            class { 'apache':
              mpm_module => 'event',
            }
        MANIFEEST
      end

      it 'behaves idempotently' do
        idempotent_apply(pp)
      end
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end

  describe 'apache::mod::worker class' do
    describe 'running puppet code' do
      let(:pp) do
        <<-MANIFEEST
          class { 'apache':
            mpm_module => 'worker',
          }
        MANIFEEST
      end

      it 'behaves idempotently' do
        idempotent_apply(pp)
      end
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
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

      it 'behaves idempotently' do
        idempotent_apply(pp)
      end
    end

    describe service(apache_hash['service_name']) do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
