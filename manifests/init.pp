# Class: apache
#
# This class installs Apache
#
# Parameters:
#
# Actions:
#   - Install Apache
#   - Manage Apache service
#
# Requires:
#
# Sample Usage:
#
class apache (
  $default_mods         = true,
  $default_vhost        = true,
  $default_ssl_vhost    = false,
  $default_ssl_cert     = $apache::params::default_ssl_cert,
  $default_ssl_key      = $apache::params::default_ssl_key,
  $default_ssl_chain    = undef,
  $default_ssl_ca       = undef,
  $default_ssl_crl_path = undef,
  $default_ssl_crl      = undef,
  $service_enable       = true,
  $purge_configs        = true,
  $serveradmin          = 'root@localhost',
  $sendfile             = false,
  $error_documents      = false
) inherits apache::params {

  package { 'httpd':
    ensure => installed,
    name   => $apache::params::apache_name,
  }

  validate_bool($default_mods)
  validate_bool($default_vhost)
  # true/false is sufficient for both ensure and enable
  validate_bool($service_enable)

  $user       = $apache::params::user
  $group      = $apache::params::group
  $httpd_dir  = $apache::params::httpd_dir
  $ports_file = $apache::params::ports_file
  $logroot    = $apache::params::logroot

  service { 'httpd':
    ensure    => $service_enable,
    name      => $apache::params::apache_name,
    enable    => $service_enable,
    subscribe => Package['httpd'],
  }

  file { $apache::params::confd_dir:
    ensure  => directory,
    recurse => true,
    purge   => $purge_configs,
    notify  => Service['httpd'],
    require => Package['httpd'],
  }

  file { $apache::params::mod_dir:
    ensure  => directory,
    recurse => true,
    purge   => $purge_configs,
    notify  => Service['httpd'],
    require => Package['httpd'],
  }

  file { $apache::params::vhost_dir:
    ensure  => directory,
    recurse => true,
    purge   => $purge_configs,
    notify  => Service['httpd'],
    require => Package['httpd'],
  }

  concat { $ports_file:
    owner  => $user,
    group  => $group,
    mode   => '0644',
    notify => Service[$apache::params::apache_name],
  }
  concat::fragment { "Apache ports header":
    target  => $ports_file,
    content => template('apache/ports_header.erb')
  }

  if $apache::params::conf_dir and $apache::params::conf_file {
    case $::osfamily {
      'debian': {
        $docroot              = '/var/www'
        $pidfile              = '${APACHE_PID_FILE}'
        $error_log            = 'error.log'
        $error_documents_path = '/usr/share/apache2/error'
        $scriptalias          = '/usr/lib/cgi-bin'
        $access_log_file      = 'access.log'
      }
      'redhat': {
        $docroot              = '/var/www/html'
        $pidfile              = 'run/httpd.pid'
        $error_log            = 'error_log'
        $error_documents_path = '/var/www/error'
        $scriptalias          = '/var/www/cgi-bin'
        $access_log_file      = 'access_log'
      }
    }
    # Template uses:
    # - $httpd_dir
    # - $pidfile
    # - $user
    # - $group
    # - $logroot
    # - $error_log
    # - $sendfile
    # - $mod_dir
    # - $ports_file
    # - $confd_dir
    # - $vhost_dir
    # - $error_documents
    # - $error_documents_path
    file { "${apache::params::conf_dir}/${apache::params::conf_file}":
      ensure  => present,
      content => template("apache/httpd.conf.erb"),
      notify  => Service['httpd'],
      require => Package['httpd'],
    }
    if $default_mods {
      include apache::mod::default
    }
    if $default_vhost {
      apache::vhost { 'default':
        port            => 80,
        docroot         => $docroot,
        scriptalias     => $scriptalias,
        serveradmin     => $serveradmin,
        access_log_file => $access_log_file,
        priority        => '15',
      }
    }
    if $default_ssl_vhost {
      apache::vhost { 'default-ssl':
        port            => 443,
        ssl             => true,
        docroot         => $docroot,
        scriptalias     => $scriptalias,
        serveradmin     => $serveradmin,
        access_log_file => "ssl_${access_log_file}",
        priority        => '15',
      }
    }
  }
}
