# Define: apache::vhost::redirect
#
# This class will create a vhost that does nothing more than redirect to a
# given location
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
    $priority      = '10',
    $serveraliases = '',
    $template      = 'apache/vhost-redirect.conf.erb',
    $vhost_name    = '*'
  ) {

  include apache

  $srvname = $name

  file { "${priority}-${name}":
    path    => "${apache::params::vdir}/${priority}-${name}",
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }

  if ! defined(Firewall["0100-INPUT ACCEPT $port"]) {
    @firewall {
      "0100-INPUT ACCEPT $port":
        jump  => 'ACCEPT',
        dport => '$port',
        proto => 'tcp'
    }
  }
}

