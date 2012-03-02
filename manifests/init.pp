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

  # May want to purge all none realize modules using the resources resource type.
  #
  A2mod { require => Package['httpd'], notify => Service['httpd']}
  case $::operatingsystem {
    'debian','ubuntu': {
      @a2mod {
       'rewrite' : ensure => present;
       'headers' : ensure => present;
       'expires' : ensure => present;
      }
    }
    default: { }
  }
  
  file { $apache::params::vdir:
    ensure => directory,
    recurse => true,
    purge => true,
    notify => Service['httpd'],
  } 

  file {
    $apache::params::apache_temp_dir:
      ensure => directory;
    "${apache::params::apache_temp_dir}/ports.d":
      ensure  => directory,
      purge   => true,
      recurse => true,
  }

  exec { 'rebuild-apache-ports':
    command     => "sort -u ${apache::params::apache_temp_dir}/ports.d/*-ports.conf > ${apache::params::ports_conf}",
    path        => ['/usr/bin', '/bin'],
    refreshonly => true,
    subscribe   => File["${apache::params::apache_temp_dir}/ports.d"],
  }
}
