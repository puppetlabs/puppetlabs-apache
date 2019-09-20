
require 'spec_helper'

describe 'apache::mod::security', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      case facts[:os]['family']
      when 'RedHat'
        context 'on RedHat based systems' do
          it {
            is_expected.to contain_apache__mod('security').with(
              id: 'security2_module',
              lib: 'mod_security2.so',
            )
          }
          it {
            is_expected.to contain_apache__mod('unique_id_module').with(
              id: 'unique_id_module',
              lib: 'mod_unique_id.so',
            )
          }
          it { is_expected.to contain_package('mod_security_crs') }
          if facts[:os]['release']['major'].to_i > 6 && facts[:os]['release']['major'].to_i <= 7
            it {
              is_expected.to contain_file('security.conf').with(
                path: '/etc/httpd/conf.modules.d/security.conf',
              )
            }
          end
          if facts[:os]['release']['major'].to_i >= 8
            it {
              is_expected.to contain_file('security.conf').with(
                path: '/etc/httpd/conf.d/security.conf',
              )
            }
          end
          it {
            is_expected.to contain_file('security.conf')
              .with_content(%r{^\s+SecAuditLogRelevantStatus "\^\(\?:5\|4\(\?!04\)\)"$})
              .with_content(%r{^\s+SecAuditLogParts ABIJDEFHZ$})
              .with_content(%r{^\s+SecDebugLog /var/log/httpd/modsec_debug.log$})
              .with_content(%r{^\s+SecAuditLog /var/log/httpd/modsec_audit.log$})
          }
          it {
            is_expected.to contain_file('/etc/httpd/modsecurity.d').with(
              ensure: 'directory', path: '/etc/httpd/modsecurity.d',
              owner: 'root', group: 'root', mode: '0755'
            )
          }
          it {
            is_expected.to contain_file('/etc/httpd/modsecurity.d/activated_rules').with(
              ensure: 'directory', path: '/etc/httpd/modsecurity.d/activated_rules',
              owner: 'apache', group: 'apache'
            )
          }
          it {
            is_expected.to contain_file('/etc/httpd/modsecurity.d/security_crs.conf').with(
              path: '/etc/httpd/modsecurity.d/security_crs.conf',
            )
          }
          it { is_expected.to contain_apache__security__rule_link('base_rules/modsecurity_35_bad_robots.data') }
          it {
            is_expected.to contain_file('modsecurity_35_bad_robots.data').with(
              path: '/etc/httpd/modsecurity.d/activated_rules/modsecurity_35_bad_robots.data',
              target: '/usr/lib/modsecurity.d/base_rules/modsecurity_35_bad_robots.data',
            )
          }

          describe 'with parameters' do
            let :params do
              {
                activated_rules: [
                  '/tmp/foo/bar.conf',
                ],
                audit_log_relevant_status: '^(?:5|4(?!01|04))',
                audit_log_parts: 'ABCDZ',
                secdefaultaction: 'deny,status:406,nolog,auditlog',
              }
            end

            it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecAuditLogRelevantStatus "\^\(\?:5\|4\(\?!01\|04\)\)"$} }
            it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecAuditLogParts ABCDZ$} }
            it { is_expected.to contain_file('/etc/httpd/modsecurity.d/security_crs.conf').with_content %r{^\s*SecDefaultAction "phase:2,deny,status:406,nolog,auditlog"$} }
            it {
              is_expected.to contain_file('bar.conf').with(
                path: '/etc/httpd/modsecurity.d/activated_rules/bar.conf',
                target: '/tmp/foo/bar.conf',
              )
            }
          end
          describe 'with other modsec parameters' do
            let :params do
              {
                manage_security_crs: false,
              }
            end

            it { is_expected.not_to contain_file('/etc/httpd/modsecurity.d/security_crs.conf') }
          end
        end
      when 'Debian'
        context 'on Debian based systems' do
          it {
            is_expected.to contain_apache__mod('security').with(
              id: 'security2_module',
              lib: 'mod_security2.so',
            )
          }
          it {
            is_expected.to contain_apache__mod('unique_id_module').with(
              id: 'unique_id_module',
              lib: 'mod_unique_id.so',
            )
          }
          it { is_expected.to contain_package('modsecurity-crs') }
          it {
            is_expected.to contain_file('security.conf').with(
              path: '/etc/apache2/mods-available/security.conf',
            )
          }
          it {
            is_expected.to contain_file('security.conf')
              .with_content(%r{^\s+SecAuditLogRelevantStatus "\^\(\?:5\|4\(\?!04\)\)"$})
              .with_content(%r{^\s+SecAuditLogParts ABIJDEFHZ$})
              .with_content(%r{^\s+SecDebugLog /var/log/apache2/modsec_debug.log$})
              .with_content(%r{^\s+SecAuditLog /var/log/apache2/modsec_audit.log$})
          }
          it {
            is_expected.to contain_file('/etc/modsecurity').with(
              ensure: 'directory', path: '/etc/modsecurity',
              owner: 'root', group: 'root', mode: '0755'
            )
          }
          it {
            is_expected.to contain_file('/etc/modsecurity/activated_rules').with(
              ensure: 'directory', path: '/etc/modsecurity/activated_rules',
              owner: 'www-data', group: 'www-data'
            )
          }
          it {
            is_expected.to contain_file('/etc/modsecurity/security_crs.conf').with(
              path: '/etc/modsecurity/security_crs.conf',
            )
          }
          if (facts[:os]['release']['major'].to_i < 18 && facts[:os]['name'] == 'Ubuntu') ||
             (facts[:os]['release']['major'].to_i < 9 && facts[:os]['name'] == 'Debian')
            it { is_expected.to contain_apache__security__rule_link('base_rules/modsecurity_35_bad_robots.data') }
            it {
              is_expected.to contain_file('modsecurity_35_bad_robots.data').with(
                path: '/etc/modsecurity/activated_rules/modsecurity_35_bad_robots.data',
                target: '/usr/share/modsecurity-crs/base_rules/modsecurity_35_bad_robots.data',
              )
            }
          end

          describe 'with parameters' do
            let :params do
              {
                activated_rules: [
                  '/tmp/foo/bar.conf',
                ],
                audit_log_relevant_status: '^(?:5|4(?!01|04))',
                audit_log_parts: 'ABCDZ',
                secdefaultaction: 'deny,status:406,nolog,auditlog',
              }
            end

            if (facts[:os]['release']['major'].to_i < 18 && facts[:os]['name'] == 'Ubuntu') ||
               (facts[:os]['release']['major'].to_i < 9 && facts[:os]['name'] == 'Debian')
              it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecAuditLogRelevantStatus "\^\(\?:5\|4\(\?!01\|04\)\)"$} }
              it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecAuditLogParts ABCDZ$} }
              it { is_expected.to contain_file('/etc/modsecurity/security_crs.conf').with_content %r{^\s*SecDefaultAction "phase:2,deny,status:406,nolog,auditlog"$} }
              it {
                is_expected.to contain_file('bar.conf').with(
                  path: '/etc/modsecurity/activated_rules/bar.conf',
                  target: '/tmp/foo/bar.conf',
                )
              }
            end
          end

          describe 'with mod security version' do
            let :params do
              {
                version: 2,
              }
            end

            it { is_expected.to contain_apache__mod('security2') }
            it {
              is_expected.to contain_file('security.conf').with(
                path: '/etc/apache2/mods-available/security2.conf',
              )
            }
          end
        end
      end
    end
  end
end
