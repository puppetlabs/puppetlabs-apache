# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::security', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      case facts[:os]['family']
      when 'Suse'
        context 'on Suse based systems' do
          it {
            is_expected.to contain_file('security.conf')
              .with_content(%r{^\s+SecTmpDir /var/lib/mod_security$})
          }
        end
      when 'RedHat'
        context 'on RedHat based systems' do
          it {
            is_expected.to contain_apache__mod('security').with(
              id: 'security2_module',
              lib: 'mod_security2.so',
            )
          }
          it {
            is_expected.to contain_apache__mod('unique_id').with(
              id: 'unique_id_module',
              lib: 'mod_unique_id.so',
            )
          }

          it { is_expected.to contain_package('mod_security_crs') }

          if (facts[:os]['release']['major'].to_i > 6 && facts[:os]['release']['major'].to_i <= 7) || (facts[:os]['release']['major'].to_i >= 8)
            it {
              is_expected.to contain_file('security.conf').with(
                path: '/etc/httpd/conf.modules.d/security.conf',
              )
            }
          end

          it {
            is_expected.to contain_file('security.conf')
              .with_content(%r{^\s+SecAuditLogRelevantStatus "\^\(\?:5\|4\(\?!04\)\)"$})
              .with_content(%r{^\s+SecAuditLogParts ABIJDEFHZ$})
              .with_content(%r{^\s+SecAuditLogType Serial$})
              .with_content(%r{^\s+SecDebugLog /var/log/httpd/modsec_debug.log$})
              .with_content(%r{^\s+SecAuditLog /var/log/httpd/modsec_audit.log$})
              .with_content(%r{^\s+SecTmpDir /var/lib/mod_security$})
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
                audit_log_type: 'Concurrent',
                audit_log_storage_dir: '/var/log/httpd/audit',
                secdefaultaction: 'deny,status:406,nolog,auditlog',
                secrequestbodyaccess: 'Off',
                secresponsebodyaccess: 'On',
                secrequestbodylimitaction: 'ProcessPartial',
                secresponsebodylimitaction: 'Reject'
              }
            end

            it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecAuditLogRelevantStatus "\^\(\?:5\|4\(\?!01\|04\)\)"$} }
            it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecAuditLogParts ABCDZ$} }
            it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecAuditLogType Concurrent$} }
            it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecAuditLogStorageDir /var/log/httpd/audit$} }
            it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecRequestBodyAccess Off$} }
            it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecResponseBodyAccess On$} }
            it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecRequestBodyLimitAction ProcessPartial$} }
            it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecResponseBodyLimitAction Reject$} }
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
                manage_security_crs: false
              }
            end

            it { is_expected.not_to contain_file('/etc/httpd/modsecurity.d/security_crs.conf') }
          end
          describe 'with custom parameters' do
            let :params do
              {
                custom_rules: false
              }
            end

            it {
              is_expected.not_to contain_file('/etc/httpd/modsecurity.d/custom_rules/custom_01_rules.conf')
            }
          end
          describe 'with parameters' do
            let :params do
              {
                custom_rules: true,
                custom_rules_set: ['REMOTE_ADDR "^127.0.0.1" "id:199999,phase:1,nolog,allow,ctl:ruleEngine=off"']
              }
            end

            it {
              is_expected.to contain_file('/etc/httpd/modsecurity.d/custom_rules').with(
                ensure: 'directory', path: '/etc/httpd/modsecurity.d/custom_rules',
                owner: 'apache', group: 'apache'
              )
            }
            it { is_expected.to contain_file('/etc/httpd/modsecurity.d/custom_rules/custom_01_rules.conf').with_content %r{^\s*.*"id:199999,phase:1,nolog,allow,ctl:ruleEngine=off"$} }
          end

          describe 'with CRS parameters' do
            let :params do
              {
                paranoia_level: 1,
                executing_paranoia_level: 2,
                enable_dos_protection: true,
                dos_burst_time_slice: 30,
                dos_counter_threshold: 120,
                dos_block_timeout: 300
              }
            end

            if facts[:os]['release']['major'].to_i < 8 && facts[:os]['family'] == 'RedHat'
              it {
                is_expected.to contain_file('/etc/httpd/modsecurity.d/security_crs.conf').with_content \
                  %r{
                    ^SecAction\ \\\n
                    \ \ "id:'900001',\ \\\n
                    \ \ phase:1,\ \\\n
                    \ \ t:none,\ \\\n
                    \ \ setvar:tx.critical_anomaly_score=5,\ \\\n
                    \ \ setvar:tx.error_anomaly_score=4,\ \\\n
                    \ \ setvar:tx.warning_anomaly_score=3,\ \\\n
                    \ \ setvar:tx.notice_anomaly_score=2,\ \\\n
                    \ \ nolog,\ \\\n
                    \ \ pass"$
                }x
              }
            else
              it {
                is_expected.to contain_file('/etc/httpd/modsecurity.d/security_crs.conf').with_content \
                  %r{^SecAction \\\n\s+\"id:900000,\\\n\s+phase:1,\\\n\s+nolog,\\\n\s+pass,\\\n\s+t:none,\\\n\s+setvar:tx.paranoia_level=1"$}
                is_expected.to contain_file('/etc/httpd/modsecurity.d/security_crs.conf').with_content \
                  %r{^SecAction \\\n\s+\"id:900001,\\\n\s+phase:1,\\\n\s+nolog,\\\n\s+pass,\\\n\s+t:none,\\\n\s+setvar:tx.executing_paranoia_level=2"$}
                is_expected.to contain_file('/etc/httpd/modsecurity.d/security_crs.conf').with_content \
                  %r{
                    ^SecAction\ \\\n
                    \s+\"id:900700,\\\n
                    \s+phase:1,\\\n
                    \s+nolog,\\\n
                    \s+pass,\\\n
                    \s+t:none,\\\n
                    \s+setvar:'tx.dos_burst_time_slice=30',\\\n
                    \s+setvar:'tx.dos_counter_threshold=120',\\\n
                    \s+setvar:'tx.dos_block_timeout=300'"$
                }x
              }
            end
          end

          describe 'with invalid CRS parameters' do
            let :params do
              {
                paranoia_level: 2,
                executing_paranoia_level: 1
              }
            end

            it {
              is_expected.to compile.and_raise_error(%r{Executing paranoia level cannot be lower than paranoia level})
            }
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
            is_expected.to contain_apache__mod('unique_id').with(
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
              .with_content(%r{^\s+SecAuditLogType Serial$})
              .with_content(%r{^\s+SecDebugLog /var/log/apache2/modsec_debug.log$})
              .with_content(%r{^\s+SecAuditLog /var/log/apache2/modsec_audit.log$})
              .with_content(%r{^\s+SecTmpDir /var/cache/modsecurity$})
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
                audit_log_type: 'Concurrent',
                audit_log_storage_dir: '/var/log/httpd/audit',
                secdefaultaction: 'deny,status:406,nolog,auditlog',
                secrequestbodyaccess: 'Off',
                secresponsebodyaccess: 'On',
                secrequestbodylimitaction: 'ProcessPartial',
                secresponsebodylimitaction: 'Reject'
              }
            end

            if (facts[:os]['release']['major'].to_i < 18 && facts[:os]['name'] == 'Ubuntu') ||
               (facts[:os]['release']['major'].to_i < 9 && facts[:os]['name'] == 'Debian')
              it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecAuditLogRelevantStatus "\^\(\?:5\|4\(\?!01\|04\)\)"$} }
              it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecAuditLogParts ABCDZ$} }
              it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecAuditLogStorageDir /var/log/httpd/audit$} }
              it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecRequestBodyAccess Off$} }
              it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecResponseBodyAccess On$} }
              it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecRequestBodyLimitAction ProcessPartial$} }
              it { is_expected.to contain_file('security.conf').with_content %r{^\s+SecResponseBodyLimitAction Reject$} }
              it { is_expected.to contain_file('/etc/modsecurity/security_crs.conf').with_content %r{^\s*SecDefaultAction "phase:2,deny,status:406,nolog,auditlog"$} }
              it {
                is_expected.to contain_file('bar.conf').with(
                  path: '/etc/modsecurity/activated_rules/bar.conf',
                  target: '/tmp/foo/bar.conf',
                )
              }
            end
          end

          describe 'with custom parameters' do
            let :params do
              {
                custom_rules: false
              }
            end

            it {
              is_expected.not_to contain_file('/etc/modsecurity/custom_rules/custom_01_rules.conf')
            }
          end

          describe 'with parameters' do
            let :params do
              {
                custom_rules: true,
                custom_rules_set: ['REMOTE_ADDR "^127.0.0.1" "id:199999,phase:1,nolog,allow,ctl:ruleEngine=off"']
              }
            end

            it {
              is_expected.to contain_file('/etc/modsecurity/custom_rules').with(
                ensure: 'directory', path: '/etc/modsecurity/custom_rules',
                owner: 'www-data', group: 'www-data'
              )
            }
            it { is_expected.to contain_file('/etc/modsecurity/custom_rules/custom_01_rules.conf').with_content %r{\s*.*"id:199999,phase:1,nolog,allow,ctl:ruleEngine=off"$} }
          end

          describe 'with mod security version' do
            let :params do
              {
                version: 2
              }
            end

            it { is_expected.to contain_apache__mod('security2') }
            it {
              is_expected.to contain_file('security.conf').with(
                path: '/etc/apache2/mods-available/security2.conf',
              )
            }
          end

          describe 'with CRS parameters' do
            let :params do
              {
                paranoia_level: 1,
                executing_paranoia_level: 1,
                enable_dos_protection: true,
                dos_burst_time_slice: 30,
                dos_counter_threshold: 120,
                dos_block_timeout: 300
              }
            end

            it {
              is_expected.to contain_file('/etc/modsecurity/security_crs.conf').with_content \
                %r{^SecAction \\\n\s+\"id:900000,\\\n\s+phase:1,\\\n\s+nolog,\\\n\s+pass,\\\n\s+t:none,\\\n\s+setvar:tx.paranoia_level=1"$}
              is_expected.to contain_file('/etc/modsecurity/security_crs.conf').with_content \
                %r{^SecAction \\\n\s+\"id:900001,\\\n\s+phase:1,\\\n\s+nolog,\\\n\s+pass,\\\n\s+t:none,\\\n\s+setvar:tx.executing_paranoia_level=1"$}
              is_expected.to contain_file('/etc/modsecurity/security_crs.conf').with_content \
                %r{
                  ^SecAction\ \\\n
                  \s+\"id:900700,\\\n
                  \s+phase:1,\\\n
                  \s+nolog,\\\n
                  \s+pass,\\\n
                  \s+t:none,\\\n
                  \s+setvar:'tx.dos_burst_time_slice=30',\\\n
                  \s+setvar:'tx.dos_counter_threshold=120',\\\n
                  \s+setvar:'tx.dos_block_timeout=300'"$
              }x
            }
          end

          describe 'with invalid CRS parameters' do
            let :params do
              {
                paranoia_level: 2,
                executing_paranoia_level: 1
              }
            end

            it {
              is_expected.to compile.and_raise_error(%r{Executing paranoia level cannot be lower than paranoia level})
            }
          end
        end
      end
    end
  end
end
