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
    name   => $apache::params::apache_name,
    ensure => installed,
  }
  service { 'httpd':
    name      => $apache::params::apache_name,
    ensure    => running,
    enable    => true,
    subscribe => Package['httpd'],
  }

  file { "httpd_vdir":
    name => $apache::params::vdir,
    ensure  => directory,
    recurse => true,
    purge   => true,
    notify  => Service['httpd'],
    require => Package['httpd'],
  }
}
