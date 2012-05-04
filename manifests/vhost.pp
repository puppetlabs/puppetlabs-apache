# Definition: apache::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - The $port to configure the host on
# - The $docroot provides the DocumentationRoot variable
# - The $ssl option is set true or false to enable SSL for this Virtual Host
# - The $configure_firewall option is set to true or false to specify if
#   a firewall should be configured.
# - The $template option specifies whether to use the default template or
#   override
# - The $priority of the site
# - The $serveraliases of the site
# - The $options for the given vhost
# - The $vhost_name for name based virtualhosting, defaulting to *
#
# Actions:
# - Install Apache Virtual Hosts
#
# Requires:
# - The apache class
#
# Sample Usage:
#  apache::vhost { 'site.name.fqdn':
#    priority => '20',
#    port => '80',
#    docroot => '/path/to/docroot',
#  }
#
define apache::vhost(
    $port,
    $docroot,
    $configure_firewall = true,
    $ssl                = $apache::params::ssl,
    $template           = $apache::params::template,
    $priority           = $apache::params::priority,
    $servername         = $apache::params::servername,
    $serveraliases      = $apache::params::serveraliases,
    $auth               = $apache::params::auth,
    $redirect_ssl       = $apache::params::redirect_ssl,
    $options            = $apache::params::options,
    $apache_name        = $apache::params::apache_name,
    $vhost_name         = $apache::params::vhost_name
  ) {

  include apache

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  if $ssl == true {
    include apache::ssl
  }

  # Since the template will use auth, redirect to https requires mod_rewrite
  if $redirect_ssl == true {
    case $::operatingsystem {
      'debian','ubuntu': {
        A2mod <| title == 'rewrite' |>
      }
      default: { }
    }
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

  if $configure_firewall {
    if ! defined(Firewall["0100-INPUT ACCEPT $port"]) {
      @firewall {
        "0100-INPUT ACCEPT $port":
          action => 'accept',
          dport  => '$port',
          proto  => 'tcp'
      }
    }
  }
}

