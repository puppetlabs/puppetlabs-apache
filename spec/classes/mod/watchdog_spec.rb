require 'spec_helper'

describe 'apache::mod::watchdog', type: :class do
  it_behaves_like 'a mod class, without including apache'

  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let :facts do
        os_facts
      end

      if os_facts[:os]['family'] == 'Debian'
        it { is_expected.not_to contain_apache__mod('watchdog') }
      else
        it { is_expected.to contain_apache__mod('watchdog') }
      end

      context 'with default configuration' do
        it { is_expected.not_to contain_file('watchdog.conf') }
      end

      context 'with custom configuration' do
        let(:params) do
          {
            watchdog_interval: 5,
          }
        end

        it { is_expected.to contain_file('watchdog.conf').with_content(%r{^WatchdogInterval 5$}) }
      end
    end
  end
end
