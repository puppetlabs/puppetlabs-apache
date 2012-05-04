# Class: apache::php
#
# This class installs PHP for Apache
#
# Parameters:
# - $php_package
#
# Actions:
#   - Install Apache PHP package
#
# Requires:
#
# Sample Usage:
#
class apache::php {
  include apache::params

  package { 'apache_php_package':
    ensure => present,
    name   => $apache::params::php_package,
  }
}
