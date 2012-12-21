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
#
#  # Simple vhost definition:
#  apache::vhost { 'site.name.fqdn':
#    port => '80',
#    docroot => '/path/to/docroot',
#  }
#
#  # SSL vhost with non-SSL rewrite:
#  apache::vhost { 'site.name.fqdn':
#    port    => '443',
#    ssl     => true,
#    docroot => '/path/to/docroot',
#  }
#  apache::vhost { 'site.name.fqdn':
#    port          => '80',
#    rewrite_cond => '%{HTTPS} off',
#    rewrite_rule => '(.*) https://%{HTTPS_HOST}%{REQUEST_URI}',
#  }
#
define apache::vhost(
    $port,
    $docroot,
    $docroot_owner      = 'root',
    $docroot_group      = 'root',
    $serveradmin        = false,
    $configure_firewall = true,
    $ssl                = false,
    $ssl_cert           = $apache::default_ssl_cert,
    $ssl_key            = $apache::default_ssl_key,
    $ssl_chain          = $apache::default_ssl_chain,
    $ssl_ca             = $apache::default_ssl_ca,
    $ssl_crl_path       = $apache::default_ssl_crl_path,
    $ssl_crl            = $apache::default_ssl_crl,
    $priority           = '25',
    $servername         = undef,
    $serveraliases      = [],
    $redirect_ssl       = false,
    $options            = ['Indexes','FollowSymLinks','MultiViews'],
    $override           = ['None'],
    $vhost_name         = '*',
    $logroot            = "/var/log/$apache::params::apache_name",
    $access_log         = true,
    $access_log_file    = "${name}_access.log",
    $scriptalias        = undef,
    $proxy_dest         = undef,
    $no_proxy_uris      = [],
    $redirect_source    = '/',
    $redirect_dest      = undef,
    $redirect_status    = undef,
    $rack_base_uris     = undef,
    $block              = [],
    $ensure             = 'present'
  ) {
  include apache
  $apache_name = $apache::params::apache_name

  if ! $servername or $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")
  validate_bool($configure_firewall)
  validate_bool($access_log)
  validate_bool($ssl)

  if $ssl {
    include apache::mod::ssl
  }
  # Since the template will use auth, redirect to https requires mod_rewrite
  if $redirect_ssl {
    if ! defined(Apache::Mod['rewrite']) {
      apache::mod { 'rewrite': }
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

  # Open listening ports if they are not already
  if ! defined(Apache::Listen[$port]) {
    apache::listen { $port: }
  }
  if ! defined(Apache::Namevirtualhost["${vhost_name}:${port}"]) {
    apache::namevirtualhost { "${vhost_name}:${port}": }
  }

  # Configure firewall rules
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

  # Template uses:
  # - $vhost_name
  # - $port
  # - $srvname
  # - $serveradmin
  # - $docroot
  # - $options
  # - $override
  # - $logroot
  # - $name
  # - $access_log
  # - $access_log_file
  # block fragment:
  #   - $block
  # proxy fragment:
  #   - $proxy_dest
  #   - $no_proxy_uris
  # rack fragment:
  #   - $rack_base_uris
  # redirect fragment:
  #   - $redirect_source
  #   - $redirect_dest
  #   - $redirect_status
  # rewrite fragment:
  #   - $rewrite_rule
  #   - $rewrite_base
  #   - $rewrite_cond
  # scriptalias fragment:
  #   - $scriptalias
  #   - $ssl
  # serveralias fragment:
  #   - $serveraliases
  # ssl fragment:
  #   - $ssl
  #   - $ssl_cert
  #   - $ssl_key
  #   - $ssl_chain
  #   - $ssl_ca
  #   - $ssl_crl
  #   - $ssl_crl_path
  file { "${priority}-${name}.conf":
    ensure  => $ensure,
    path    => "${apache::params::vhost_dir}/${priority}-${name}.conf",
    content => template('apache/vhost.conf.erb'),
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
}

