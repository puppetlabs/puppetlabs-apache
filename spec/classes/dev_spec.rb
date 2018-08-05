require 'spec_helper'

describe 'apache::dev', type: :class do
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

        case facts[:os]['name']
        when 'Debian'
          context 'on a Debian OS' do
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_package('libaprutil1-dev') }
            it { is_expected.to contain_package('libapr1-dev') }
            if facts[:os]['release']['major'].to_i < 8
              it { is_expected.to contain_package('apache2-prefork-dev') }
            end
          end
        when 'Ubuntu'
          context 'on an Ubuntu 16 OS' do
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_package('apache2-dev') }
          end
        when 'RedHat'
          context 'on a RedHat OS' do
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_package('httpd-devel') }
          end
        when 'FreeBSD'
          context 'on a FreeBSD OS' do
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('apache::params') }
          end
        when 'Gentoo'
          context 'on a Gentoo OS' do
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('apache::params') }
          end
        else
          context "on #{os} OS" do
            it { is_expected.to compile.with_all_deps }
          end
        end
      end
    end
  end
end
