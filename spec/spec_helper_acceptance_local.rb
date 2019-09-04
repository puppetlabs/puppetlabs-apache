# frozen_string_literal: true

RSpec.configure do |c|
  # IPv6 is not enabled by default in the new travis-ci Trusty environment (see https://github.com/travis-ci/travis-ci/issues/8891 )
  if ENV['CI'] == 'true'
    c.filter_run_excluding ipv6: true
  end
  c.before :suite do
    run_shell('puppet module install stahnma/epel')
    pp = <<-PUPPETCODE
    # needed by tests
    package { 'curl':
      ensure   => 'latest',
    }
    # needed for netstat, for serverspec checks
    if $::osfamily == 'SLES' or $::osfamily == 'SUSE' {
      package { 'net-tools-deprecated':
        ensure   => 'latest',
      }
    }
    # needed for ss, for serverspec checks
    if $::operatingsystem == 'Ubuntu' and $::operatingsystemmajrelease !~ /14.04|16.04/ {
      package { 'iproute2':
        ensure   => 'latest',
      }
    }
    if $::osfamily == 'RedHat' {
      if $::operatingsystemmajrelease == '5' or $::operatingsystemmajrelease == '6'{
        class { 'epel':
          epel_baseurl => "http://osmirror.delivery.puppetlabs.net/epel${::operatingsystemmajrelease}-\\$basearch/RPMS.all",
          epel_mirrorlist => "http://osmirror.delivery.puppetlabs.net/epel${::operatingsystemmajrelease}-\\$basearch/RPMS.all",
        }
        } elsif $::operatingsystemmajrelease == '8' {
          class { 'epel':
                os_maj_release => "7",
                epel_baseurl => "http://osmirror.delivery.puppetlabs.net/epel7-\\$basearch/RPMS.all",
                epel_mirrorlist => "http://osmirror.delivery.puppetlabs.net/epel7-\\$basearch/RPMS.all",
          }
      } else {
        class { 'epel': }
      }
    }
    PUPPETCODE
    apply_manifest(pp)

    # Make sure selinux is disabled so the tests work.
    run_shell('setenforce 0', expect_failures: true) if os[:family] =~ %r{redhat|oracle}
  end
end

def apache_settings_hash
  osfamily               = os[:family]
  operatingsystemrelease = os[:release].to_f
  apache = {}
  case osfamily
  when 'redhat', 'oracle'
    apache['confd_dir']        = '/etc/httpd/conf.d'
    apache['conf_file']        = '/etc/httpd/conf/httpd.conf'
    apache['ports_file']       = '/etc/httpd/conf/ports.conf'
    apache['vhost_dir']        = '/etc/httpd/conf.d'
    apache['vhost']            = '/etc/httpd/conf.d/15-default.conf'
    apache['run_dir']          = '/var/run/httpd'
    apache['doc_root']         = '/var/www'
    apache['service_name']     = 'httpd'
    apache['package_name']     = 'httpd'
    apache['error_log']        = 'error_log'
    apache['suphp_handler']    = 'php5-script'
    apache['suphp_configpath'] = 'undef'
    if (operatingsystemrelease >= 7 && operatingsystemrelease < 8) && (osfamily == 'redhat')
      apache['version'] = '2.4'
      apache['mod_dir'] = '/etc/httpd/conf.modules.d'
    elsif operatingsystemrelease >= 8 && osfamily == 'redhat'
      apache['version'] = '2.4'
      apache['mod_dir'] = '/etc/httpd/conf.d'
    elsif operatingsystemrelease >= 7 && osfamily == 'oracle'
      apache['version'] = '2.4'
      apache['mod_dir'] = '/etc/httpd/conf.modules.d'
    else
      apache['version'] = '2.2'
      apache['mod_dir'] = '/etc/httpd/conf.d'
    end
  when 'debian', 'ubuntu'
    apache['confd_dir']        = '/etc/apache2/conf.d'
    apache['mod_dir']          = '/etc/apache2/mods-available'
    apache['conf_file']        = '/etc/apache2/apache2.conf'
    apache['ports_file']       = '/etc/apache2/ports.conf'
    apache['vhost']            = '/etc/apache2/sites-available/15-default.conf'
    apache['vhost_dir']        = '/etc/apache2/sites-enabled'
    apache['run_dir']          = '/var/run/apache2'
    apache['doc_root']         = '/var/www'
    apache['service_name']     = 'apache2'
    apache['package_name']     = 'apache2'
    apache['error_log']        = 'error.log'
    apache['suphp_handler']    = 'x-httpd-php'
    apache['suphp_configpath'] = '/etc/php5/apache2'
    apache['version'] = if osfamily == 'ubuntu' && operatingsystemrelease >= 13.10
                          '2.4'
                        elsif osfamily == 'debian' && operatingsystemrelease >= 8.0
                          '2.4'
                        else
                          '2.2'
                        end
  when 'freebsd'
    apache['confd_dir']        = '/usr/local/etc/apache24/Includes'
    apache['mod_dir']          = '/usr/local/etc/apache24/Modules'
    apache['conf_file']        = '/usr/local/etc/apache24/httpd.conf'
    apache['ports_file']       = '/usr/local/etc/apache24/Includes/ports.conf'
    apache['vhost']            = '/usr/local/etc/apache24/Vhosts/15-default.conf'
    apache['vhost_dir']        = '/usr/local/etc/apache24/Vhosts'
    apache['run_dir']          = '/var/run/apache24'
    apache['doc_root']         = '/var/www'
    apache['service_name']     = 'apache24'
    apache['package_name']     = 'apache24'
    apache['error_log']        = 'http-error.log'
    apache['version'] = '2.2'
  when 'gentoo'
    apache['confd_dir']        = '/etc/apache2/conf.d'
    apache['mod_dir']          = '/etc/apache2/modules.d'
    apache['conf_file']        = '/etc/apache2/httpd.conf'
    apache['ports_file']       = '/etc/apache2/ports.conf'
    apache['vhost']            = '/etc/apache2/vhosts.d/15-default.conf'
    apache['vhost_dir']        = '/etc/apache2/vhosts.d'
    apache['run_dir']          = '/var/run/apache2'
    apache['doc_root']         = '/var/www'
    apache['service_name']     = 'apache2'
    apache['package_name']     = 'www-servers/apache'
    apache['error_log']        = 'http-error.log'
    apache['version'] = '2.4'
  when 'suse', 'sles'
    apache['confd_dir']        = '/etc/apache2/conf.d'
    apache['mod_dir']          = '/etc/apache2/mods-available'
    apache['conf_file']        = '/etc/apache2/httpd.conf'
    apache['ports_file']       = '/etc/apache2/ports.conf'
    apache['vhost']            = '/etc/apache2/sites-available/15-default.conf'
    apache['vhost_dir']        = '/etc/apache2/sites-available'
    apache['run_dir']          = '/var/run/apache2'
    apache['doc_root']         = '/srv/www'
    apache['service_name']     = 'apache2'
    apache['package_name']     = 'apache2'
    apache['error_log']        = 'error.log'
    apache['version'] = if operatingsystemrelease < 12
                          '2.2'
                        else
                          '2.4'
                        end
  else
    raise 'unable to figure out what apache version'
  end
  apache
end
