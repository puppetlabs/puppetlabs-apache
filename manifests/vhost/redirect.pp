# Define: apache::vhost::redirect
#
# This class will create a vhost that does nothing more than redirect to a given location
#
# Parameters:
#   $port:
#       Which port to list on
#   $dest:
#       Where to redirect to
# - $vhost_name
#
# Actions:
#   Installs apache and creates a vhost
#
# Requires:
#
# Sample Usage:
#
define apache::vhost::redirect (
    $port,
    $dest,
    $configure_firewall = true,
    $priority           = '10',
    $servername         = '',
    $serveraliases      = '',
    $template           = "apache/vhost-redirect.conf.erb",
    $vhost_name         = '*'
  ) {

  include apache

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  file { "${priority}-${name}":
    name    => "${apache::params::vdir}/${priority}-${name}",
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }

  if $configure_firewall {
    if ! defined(Firewall["0100-INPUT ACCEPT $port"]) {
      @firewall {
        "0100-INPUT ACCEPT $port":
          action => 'accept',
          dport => "$port",
          proto => 'tcp'
      }
    }
  }
}

