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
class apache {
  include apache::params

  package { 'httpd':
    ensure => installed,
    name   => $apache::params::apache_name,
  }

  service { 'httpd':
    ensure    => running,
    name      => $apache::params::apache_name,
    enable    => true,
    subscribe => Package['httpd'],
  }

  file { 'httpd_vdir':
    ensure  => directory,
    path    => $apache::params::vdir,
    recurse => true,
    purge   => true,
    notify  => Service['httpd'],
    require => Package['httpd'],
  }
}
