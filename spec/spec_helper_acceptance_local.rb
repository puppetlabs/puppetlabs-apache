# frozen_string_literal: true

RSpec.configure do |c|
  c.before :suite do
    run_shell('puppet module install stahnma/epel')
    pp = <<-PUPPETCODE
    package { 'curl':
      ensure   => 'latest',
    }
    if $::osfamily == 'SLES' or $::osfamily == 'SUSE' {
      package { 'net-tools-deprecated':
        ensure   => 'latest',
      }
    }
    if $::osfamily == 'RedHat' {
      if $::operatingsystemmajrelease == '5' or $::operatingsystemmajrelease == '6'{
        class { 'epel':
          epel_baseurl => "http://osmirror.delivery.puppetlabs.net/epel${::operatingsystemmajrelease}-\\$basearch/RPMS.all",
          epel_mirrorlist => "http://osmirror.delivery.puppetlabs.net/epel${::operatingsystemmajrelease}-\\$basearch/RPMS.all",
        }
      } else {
        class { 'epel': }
      }
    }
    PUPPETCODE
    apply_manifest(pp)
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

    if operatingsystemrelease >= 7
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
