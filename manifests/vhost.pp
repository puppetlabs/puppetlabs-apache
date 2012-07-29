# Definition: apache::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - The $port to configure the host on
# - The $docroot provides the DocumentationRoot variable
# - The $serveradmin will specify an email address for Apache that it will display when it renders one of it's error pages
# - The $configure_firewall option is set to true or false to specify if
#   a firewall should be configured.
# - The $ssl option is set true or false to enable SSL for this Virtual Host
# - The $template option specifies whether to use the default template or
#   override
# - The $priority of the site
# - The $servername is the primary name of the virtual host
# - The $serveraliases of the site
# - If the site should use http authentication, $auth should be set to the htpasswd file
# - The $options for the given vhost
# - The $vhost_name for name based virtualhosting, defaulting to *
# - The $logroot specifies the location of the virtual hosts logfiles, default to /var/log/<apache log location>/
# - The $ssl_cert points to your SSL cert. Defaults to Debian's snakeoil
# - The $ssl_key points to your SSL key. Defaults to Debian's snakeoil
# - The $ssl_template points to the default SSH vhost template
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
    $configure_firewall = false,
    $ssl                = false,
    $servername         = false,
    $serveraliases      = false,
    $auth               = false,
    $redirect_ssl       = false,
    $serveradmin        = "${::apache::params::user}@${::fqdn}",
    $template           = 'apache/vhost-default.conf.erb',
    $priority           = '25',
    $options            = 'Indexes FollowSymLinks MultiViews',
    $vhost_name         = '*',
    $apache_name        = $::apache::params::apache_name,
    $logroot            = $::apache::params::logroot,
    $ssl_cert           = $::apache::params::ssl_cert,
    $ssl_key            = $::apache::params::ssl_key
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
  # Wat? -jtopjian
  #if $redirect_ssl == true {
  #  case $::operatingsystem {
  #    'debian','ubuntu': {
  #      A2mod <| title == 'rewrite' |>
  #    }
  #    default: { }
  #  }
  #}

  # NOTE: Why is this here?  
  # This creates directories like "/etc/apache2/sites-enabled/25-example.com-/home/www.example.com/docroot"
  # -jtopjian
  #file {"${apache::params::vdir}/${priority}-${name}-$docroot":
  #  path   => $docroot,
  #  ensure => directory,
  #}

  # This creates a log directory like "/var/log/apache2/www.example.com"
  file {"${logroot}/${name}":
    ensure  => directory,
    require => Package['httpd'],
  }

  file { "${priority}-${name}.conf":
      path    => "${::apache::params::vdir}/${priority}-${name}.conf",
      content => template($template),
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => [
          File["${logroot}/${name}"],
      ],
      notify  => Service['httpd'],
  }

  if $configure_firewall {
    if ! defined(Firewall["0100-INPUT ACCEPT $port"]) {
      @firewall {
        "0100-INPUT ACCEPT $port":
          action => 'accept',
          dport  => $port,
          proto  => 'tcp'
      }
    }
  }
}

