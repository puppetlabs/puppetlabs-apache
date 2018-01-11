@osfamily               = fact('osfamily')
@operatingsystem        = fact('operatingsystem')
@operatingsystemrelease = fact('operatingsystemrelease').to_f

case @osfamily
when 'RedHat'
  $confd_dir        = '/etc/httpd/conf.d'
  $conf_file        = '/etc/httpd/conf/httpd.conf'
  $ports_file       = '/etc/httpd/conf/ports.conf'
  $vhost_dir        = '/etc/httpd/conf.d'
  $vhost            = '/etc/httpd/conf.d/15-default.conf'
  $run_dir          = '/var/run/httpd'
  $doc_root         = '/var/www'
  $service_name     = 'httpd'
  $package_name     = 'httpd'
  $error_log        = 'error_log'
  $suphp_handler    = 'php5-script'
  $suphp_configpath = 'undef'

  if (@operatingsystem == 'Fedora' && @operatingsystemrelease >= 18) || (@operatingsystem != 'Fedora' && @operatingsystemrelease >= 7)
    $apache_version = '2.4'
    $mod_dir        = '/etc/httpd/conf.modules.d'
  else
    $apache_version = '2.2'
    $mod_dir        = '/etc/httpd/conf.d'
  end
when 'Debian'
  $confd_dir        = '/etc/apache2/conf.d'
  $mod_dir          = '/etc/apache2/mods-available'
  $conf_file        = '/etc/apache2/apache2.conf'
  $ports_file       = '/etc/apache2/ports.conf'
  $vhost            = '/etc/apache2/sites-available/15-default.conf'
  $vhost_dir        = '/etc/apache2/sites-enabled'
  $run_dir          = '/var/run/apache2'
  $doc_root         = '/var/www'
  $service_name     = 'apache2'
  $package_name     = 'apache2'
  $error_log        = 'error.log'
  $suphp_handler    = 'x-httpd-php'
  $suphp_configpath = '/etc/php5/apache2'
  $apache_version = if @operatingsystem == 'Ubuntu' && @operatingsystemrelease >= 13.10
                      '2.4'
                    elsif @operatingsystem == 'Debian' && @operatingsystemrelease >= 8.0
                      '2.4'
                    else
                      '2.2'
                    end
when 'FreeBSD'
  $confd_dir        = '/usr/local/etc/apache24/Includes'
  $mod_dir          = '/usr/local/etc/apache24/Modules'
  $conf_file        = '/usr/local/etc/apache24/httpd.conf'
  $ports_file       = '/usr/local/etc/apache24/Includes/ports.conf'
  $vhost            = '/usr/local/etc/apache24/Vhosts/15-default.conf'
  $vhost_dir        = '/usr/local/etc/apache24/Vhosts'
  $run_dir          = '/var/run/apache24'
  $doc_root         = '/var/www'
  $service_name     = 'apache24'
  $package_name     = 'apache24'
  $error_log        = 'http-error.log'
  $apache_version   = '2.2'
when 'Gentoo'
  $confd_dir        = '/etc/apache2/conf.d'
  $mod_dir          = '/etc/apache2/modules.d'
  $conf_file        = '/etc/apache2/httpd.conf'
  $ports_file       = '/etc/apache2/ports.conf'
  $vhost            = '/etc/apache2/vhosts.d/15-default.conf'
  $vhost_dir        = '/etc/apache2/vhosts.d'
  $run_dir          = '/var/run/apache2'
  $doc_root         = '/var/www'
  $service_name     = 'apache2'
  $package_name     = 'www-servers/apache'
  $error_log        = 'http-error.log'
  $apache_version   = '2.4'
when 'Suse'
  $confd_dir        = '/etc/apache2/conf.d'
  $mod_dir          = '/etc/apache2/mods-available'
  $conf_file        = '/etc/apache2/httpd.conf'
  $ports_file       = '/etc/apache2/ports.conf'
  $vhost            = '/etc/apache2/sites-available/15-default.conf'
  $vhost_dir        = '/etc/apache2/sites-available'
  $run_dir          = '/var/run/apache2'
  $doc_root         = '/srv/www'
  $service_name     = 'apache2'
  $package_name     = 'apache2'
  $error_log        = 'error.log'
  $apache_version   = if @operatingsystemrelease < 12
                        '2.2'
                      else
                        '2.4'
                      end
else
  $apache_version   = '0'
end
