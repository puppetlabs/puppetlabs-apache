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
# - $access_log - specifies if *_access.log directives should be configured.
# - $ssl_chain - (boolean) when set to true includes pl.chain
# - $ssl_path - path to the certificate files
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
    $allowips	   = '',
    $ssl           = false,
    $ssl_chain	   = false,
    $ssl_path	   = $apache::params::ssl_path,
    $vhost_name    = '*',
    $access_log    = true,
    $no_proxy_uris = []
  ) {

  include apache
  include apache::mod::proxy

  $apache_name = $apache::params::apache_name
#  $ssl_path = $apache::params::ssl_path
  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  if $ssl == true {
    include apache::mod::ssl
  }

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
