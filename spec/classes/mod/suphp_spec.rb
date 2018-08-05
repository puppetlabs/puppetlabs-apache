require 'spec_helper'

describe 'apache::mod::suphp', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      case facts[:os]['family']
      when 'Debian'
        if facts[:os]['release']['major'].to_i < 18
          context 'on a Debian OS' do
            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_package('libapache2-mod-suphp') }
          end
        end
      when 'RedHat'
        context 'on a RedHat OS' do
          it { is_expected.to contain_class('apache::params') }
          it { is_expected.to contain_package('mod_suphp') }
        end
      end
    end
  end
end
