require 'spec_helper'

describe 'apache::dev' do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      context 'with all defaults' do
        let(:pre_condition) do
          [
            'include apache',
          ]
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('apache::params') }
        case facts[:os]['name']
        when 'Debian'
          it { is_expected.to contain_package('libaprutil1-dev') }
          it { is_expected.to contain_package('libapr1-dev') }
          if facts[:os]['release']['major'].to_i < 8
            it { is_expected.to contain_package('apache2-prefork-dev') }
          end
        when 'Ubuntu'
          it { is_expected.to contain_package('apache2-dev') }
        when 'RedHat'
          it { is_expected.to contain_package('httpd-devel') }
        end
      end
    end
  end
end
