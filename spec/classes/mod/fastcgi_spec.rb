require 'spec_helper'

describe 'apache::mod::fastcgi', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      context 'with all defaults' do
        case facts[:os]['name']
        when 'Debian'
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('apache::params') }
          it { is_expected.to contain_apache__mod('fastcgi') }
          it { is_expected.to contain_package('libapache2-mod-fastcgi') }
          it { is_expected.to contain_file('fastcgi.conf') }
        when 'RedHat', 'CentOS', 'OracleLinux', 'Scientific'
          if facts[:os]['release']['major'].to_i < 7
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('apache::params') }
            it { is_expected.to contain_apache__mod('fastcgi') }
            it { is_expected.to contain_package('mod_fastcgi') }
            it { is_expected.not_to contain_file('fastcgi.conf') }
          else
            it { is_expected.not_to compile }
          end
        when 'Ubuntu'
          if facts[:os]['release']['major'].to_i < 18
            it { is_expected.to compile.with_all_deps }
          else
            it { is_expected.not_to compile }
          end
        else
          it { is_expected.to compile.with_all_deps }
        end
      end
    end
  end
end
