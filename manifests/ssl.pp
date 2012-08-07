# Class: apache::ssl
#
# This class installs Apache SSL capabilities
#
# Parameters:
# - The $ssl_package name from the apache::params class
#
# Actions:
#   - Install Apache SSL capabilities
#
# Requires:
#
# Sample Usage:
#
class apache::ssl {

  include apache

  if $::osfamily == 'redhat' or $::operatingsystem == 'amazon' {
    package { 'apache_ssl_package':
      ensure  => installed,
      name    => $apache::params::ssl_package,
      require => Package['httpd'],
    }
  } elsif $::osfamily == 'debian' {
    a2mod { 'ssl': ensure => present, }
  } else {
    fail( "${::operatingsystem} not defined in apache::ssl.")
  }
}
