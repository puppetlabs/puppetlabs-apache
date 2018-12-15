require 'spec_helper'

describe 'apache::mod::suphp', type: :class do
  on_supported_os.each do |os, facts|
    # suphp has been declared EOL and is no longer supported on any Debian module that we test on
    next unless facts[:os]['family'] == 'RedHat'
    context "on #{os} " do
      let :facts do
        facts
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_package('mod_suphp') }
    end
  end
end
