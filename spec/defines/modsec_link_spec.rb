# frozen_string_literal: true

require 'spec_helper'

describe 'apache::security::rule_link', type: :define do
  let :pre_condition do
    'class { "apache": }
    class { "apache::mod::security": activated_rules => [] }
    '
  end

  let :title do
    'base_rules/modsecurity_35_bad_robots.data'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      case facts[:os]['family']
      when 'RedHat'
        if facts[:os]['release']['major'].to_i <= 7
          it {
            expect(subject).to contain_file('modsecurity_35_bad_robots.data').with(
              path: '/etc/httpd/modsecurity.d/activated_rules/modsecurity_35_bad_robots.data',
              target: '/usr/lib/modsecurity.d/base_rules/modsecurity_35_bad_robots.data',
            )
          }
        else
          it {
            expect(subject).to contain_file('modsecurity_35_bad_robots.data').with(
              path: '/etc/httpd/modsecurity.d/activated_rules/modsecurity_35_bad_robots.data',
              target: '/usr/share/mod_modsecurity_crs/base_rules/modsecurity_35_bad_robots.data',
            )
          }
        end
      when 'Debian'
        it {
          expect(subject).to contain_file('modsecurity_35_bad_robots.data').with(
            path: '/etc/modsecurity/activated_rules/modsecurity_35_bad_robots.data',
            target: '/usr/share/modsecurity-crs/base_rules/modsecurity_35_bad_robots.data',
          )
        }
      end
    end
  end
end
