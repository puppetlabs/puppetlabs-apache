# Define: apache::vhost::proxy
#
# Configures an apache vhost that will only proxy requests
#
# Parameters:
# * $port:
#     The port on which the vhost will respond
# * $dest:
#     URI that the requests will be proxied for
# - $priority
# - $template -- the template to use for the vhost
# - $vhost_name - the name to use for the vhost, defaults to '*'
#
# Actions:
# * Install Apache Virtual Host
#
# Requires:
#
# Sample Usage:
#
define apache::vhost::proxy (
    $port,
    $dest,
    $priority      = '10',
    $template      = 'apache/vhost-proxy.conf.erb',
    $servername    = '',
    $serveraliases = '',
    $ssl           = false,
    $vhost_name    = '*'
  ) {

  include apache

  $apache_name = $apache::params::apache_name
  $ssl_path = $apache::params::ssl_path
  $srvname = $name

  if $ssl == true {
    include apache::ssl
  }

  file { "${priority}-${name}":
    path    => "${apache::params::vdir}/${priority}-${name}",
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }


}
