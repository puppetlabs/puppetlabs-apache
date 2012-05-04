# Class: apache::python
#
# This class installs Python for Apache
#
# Parameters:
# - $php_package
#
# Actions:
#   - Install Apache Python package
#
# Requires:
#
# Sample Usage:
#
class apache::python {
  include apache::params
  include apache

  package { 'apache_python_package':
    ensure => present,
    name   => $apache::params::python_package,
  }
  a2mod { 'python': ensure => present, }

}
