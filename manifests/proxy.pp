# Class: apache::proxy
#
# This class enabled the proxy module for Apache
#
# Actions:
#   - Enables Apache Proxy module
#
# Requires:
#
# Sample Usage:
#
class apache::proxy {
  include apache::params
  include apache

  if $::osfamily == 'debian' {
    a2mod { $apache::params::proxy_modules:
      ensure => present,
      before => Service[httpd]
    }
  }
}
