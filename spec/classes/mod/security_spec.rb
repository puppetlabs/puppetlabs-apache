
require 'spec_helper'

describe 'apache::mod::security', type: :class do
  it_behaves_like 'a mod class, without including apache'
  context 'on RedHat based systems' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystem: 'CentOS',
        operatingsystemrelease: '7',
        kernel: 'Linux',
        id: 'root',
        concat_basedir: '/',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        is_pe: false,
      }
    end

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
    it {
      is_expected.to contain_file('security.conf').with(
        path: '/etc/httpd/conf.modules.d/security.conf',
      )
    }
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
  context 'on Debian based systems' do
    let :facts do
      {
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        operatingsystemrelease: '8',
        concat_basedir: '/',
        lsbdistcodename: 'jessie',
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        kernel: 'Linux',
        is_pe: false,
      }
    end

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
    it { is_expected.to contain_apache__security__rule_link('base_rules/modsecurity_35_bad_robots.data') }
    it {
      is_expected.to contain_file('modsecurity_35_bad_robots.data').with(
        path: '/etc/modsecurity/activated_rules/modsecurity_35_bad_robots.data',
        target: '/usr/share/modsecurity-crs/base_rules/modsecurity_35_bad_robots.data',
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
      it { is_expected.to contain_file('/etc/modsecurity/security_crs.conf').with_content %r{^\s*SecDefaultAction "phase:2,deny,status:406,nolog,auditlog"$} }
      it {
        is_expected.to contain_file('bar.conf').with(
          path: '/etc/modsecurity/activated_rules/bar.conf',
          target: '/tmp/foo/bar.conf',
        )
      }
    end
  end
end
