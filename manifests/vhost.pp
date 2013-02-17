# Definition: apache::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - The $port to configure the host on
# - The $docroot provides the DocumentationRoot variable
# - The $serveradmin will specify an email address for Apache that it will
#   display when it renders one of it's error pages
# - The $configure_firewall option is set to true or false to specify if
#   a firewall should be configured.
# - The $ssl option is set true or false to enable SSL for this Virtual Host
# - The $template option specifies whether to use the default template or
#   override
# - The $priority of the site
# - The $servername is the primary name of the virtual host
# - The $serveraliases of the site
# - The $options for the given vhost
# - The $override for the given vhost (array of AllowOverride arguments)
# - The $vhost_name for name based virtualhosting, defaulting to *
# - The $logroot specifies the location of the virtual hosts logfiles, default
#   to /var/log/<apache log location>/
# - The $access_log specifies if *_access.log directives should be configured.
# - The $ensure specifies if vhost file is present or absent.
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
    $docroot_owner        = 'root',
    $docroot_group        = 'root',
    $serveradmin          = false,
    $configure_firewall   = true,
    $ssl                  = $apache::params::ssl,
    $ssl_dir              = $apache::params::ssl_dir,
    $ssl_public_cert_dir  = $apache::params::ssl_public_cert_dir,
    $ssl_private_key_dir  = $apache::params::ssl_private_key_dir,
    $ssl_public_cert      = false,
    $ssl_private_key      = false,
    $ssl_ca_chain_cert    = false,
    $ssl_ca_cert          = false,
    $sslprotocol          = $apache::params::sslprotocol,
    $ssloptions           = $apache::params::ssloptions,
    $sslciphersuite       = $apache::params::sslciphersuite,
    $sslverifyclient      = $apache::params::sslverifyclient,
    $sslverifydepth       = $apache::params::sslverifydepth,
    $template             = $apache::params::template,
    $priority             = $apache::params::priority,
    $servername           = $apache::params::servername,
    $serveraliases        = $apache::params::serveraliases,
    $auth                 = $apache::params::auth,
    $redirect_ssl         = $apache::params::redirect_ssl,
    $options              = $apache::params::options,
    $override             = $apache::params::override,
    $apache_name          = $apache::params::apache_name,
    $vhost_name           = $apache::params::vhost_name,
    $logroot              = "/var/log/$apache::params::apache_name",
    $access_log           = true,
    $ensure               = 'present'
  ) {

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")

  include apache

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  if $ssl == true {
    include apache::mod::ssl
    # define the ssl directories if they do not exist
    # They may be defined elsewhere when certificates were uploaded
    # or may be installed by some software package and not
    # yet defined as a puppet resource
    if ! defined(File[$ssl_dir]){
      file {$ssl_dir:
        ensure => directory,
      }
    }

    # Do not require $ssl_dir, it might not be the parent
    if ! defined(File[$ssl_public_cert_dir]){
      file {$ssl_public_cert_dir:
        ensure => directory,
      }
    }

    # Do not require $ssl_dir, it might not be the parent
    if ! defined(File[$ssl_private_key_dir]){
      file {$ssl_private_key_dir:
        ensure => directory,
      }
    }

    if ! $ssl_public_cert {
      warning("A public certicate must be specified when enabling ssl with apache::vhost on ${::fqdn}")
    }
    $ssl_public_cert_path = "${ssl_public_cert_dir}/${ssl_public_cert}"
    if ! defined(File[$ssl_public_cert_path]){
      file {$ssl_public_cert_path:
        ensure  => file,
        require => File[$ssl_public_cert_dir],
      }
    }

    if ! $ssl_private_key {
      warning("A private key must be specified when enabling ssl with apache::vhost on ${::fqdn}")
    }
    $ssl_private_key_path = "${ssl_private_key_dir}/${ssl_private_key}"
    if ! defined(File[$ssl_private_key_path]){
      file {$ssl_private_key_path:
        ensure  => file,
        require => File[$ssl_private_key_dir],
      }
    }

    # We assume all the public certificates are in the same place
    if $ssl_ca_cert {
      $ssl_ca_cert_path = "${ssl_public_cert_dir}/${ssl_ca_cert}"
      if ! defined(File[$ssl_ca_cert_path]){
        file {$ssl_ca_cert_path:
          ensure  => file,
          require => File[$ssl_public_cert_dir],
        }
      }
    }

    if $ssl_ca_chain_cert {
      $ssl_ca_chain_cert_path = "${ssl_public_cert_dir}/${ssl_ca_chain_cert}"
      if ! defined(File[$ssl_ca_chain_cert_path]){
        file {$ssl_ca_chain_cert_path:
          ensure  => file,
          require => File[$ssl_public_cert_dir],
        }
      }
    }

  }

  # Since the template will use auth, redirect to https requires mod_rewrite
  if $redirect_ssl == true {
    if $::osfamily == 'debian' {
      A2mod <| title == 'rewrite' |>
    }
  }

  # This ensures that the docroot exists
  # But enables it to be specified across multiple vhost resources
  if ! defined(File[$docroot]) {
    file { $docroot:
      ensure => directory,
      owner  => $docroot_owner,
      group  => $docroot_group,
    }
  }

  # Same as above, but for logroot
  if ! defined(File[$logroot]) {
    file { $logroot:
      ensure => directory,
    }
  }

  # Template uses:
  # - $vhost_name
  # - $port
  # - $srvname
  # - $serveradmin
  # - $serveraliases
  # - $docroot
  # - $options
  # - $override
  # - $logroot
  # - $access_log
  # - $name
  # - $ssl
  # The template uses the folloiwing only if $ssl is true
  # - $sslprotocol
  # - $ssloptions
  # - $ssl_public_cert_path
  # - $ssl_private_key_path
  file { "${priority}-${name}.conf":
    ensure  => $ensure,
    path    => "${apache::params::vdir}/${priority}-${name}.conf",
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [
      Package['httpd'],
      File[$docroot],
      File[$logroot],
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

