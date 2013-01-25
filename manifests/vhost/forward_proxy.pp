# Define: apache::vhost::forward_proxy
#
# Configures an apache vhost that will act as a forward proxy and
# forward all request to the server indicated by the request. 
# See apache::vhost::proxy for a reverse proxy that only proxies for
# a single server.
#
# Parameters:
# * $port:
#     The port on which the vhost will respond
#   $allowednet: the networks/hosts that are allowed to acces the proxy
# - $priority
# - $template -- the template to use for the vhost
# - $access_log - specifies if *_access.log directives should be configured.
# - $vhost_name - the name to use for the vhost, defaults to '*'
#
# Actions:
# * Install Apache Virtual Host
#
# Requires:
#
# Sample Usage:
#
define apache::vhost::forward_proxy (
    $port,
    $allowednet
    $priority      = '10',
    $template      = 'apache/vhost-forward-proxy.conf.erb',
    $servername    = '',
    $serveraliases = '',
    $ssl           = false,
    $vhost_name    = '*',
    $access_log    = true,
    $no_proxy_uris = []
  ) {

  include apache
  include apache::proxy

  $apache_name = $apache::params::apache_name
  $ssl_path = $apache::params::ssl_path
  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  if $ssl == true {
    include apache::mod::ssl
  }

  # Template uses:
  # - $vhost_name
  # - $port
  # - $allowednet
  # - $ssl
  # - $ssl_path
  # - $srvname
  # - $serveraliases
  # - $no_proxy_uris
  # - $apache::params::apache_name
  # - $access_log
  # - $name
  file { "${priority}-${name}.conf":
    path    => "${apache::params::vdir}/${priority}-${name}.conf",
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }


}
