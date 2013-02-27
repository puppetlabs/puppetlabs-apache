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
    $docroot,
    $port               = undef,
    $ip                 = undef,
    $ip_based           = false,
    $add_listen         = true,
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
    $ssl_certs_dir      = $apache::params::ssl_certs_dir,
    $priority           = undef,
    $default_vhost      = false,
    $servername         = undef,
    $serveraliases      = [],
    $options            = ['Indexes','FollowSymLinks','MultiViews'],
    $override           = ['None'],
    $vhost_name         = '*',
    $logroot            = "/var/log/${apache::params::apache_name}",
    $access_log         = true,
    $access_log_file    = undef,
    $error_log          = true,
    $error_log_file     = undef,
    $scriptalias        = undef,
    $proxy_dest         = undef,
    $no_proxy_uris      = [],
    $redirect_source    = '/',
    $redirect_dest      = undef,
    $redirect_status    = undef,
    $rack_base_uris     = undef,
    $request_header     = undef,
    $rewrite_rule       = undef,
    $rewrite_base       = undef,
    $rewrite_cond       = undef,
    $setenv             = [],
    $setenvif           = [],
    $block              = [],
    $ensure             = 'present'
  ) {
  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['apache']) {
    fail("You must include the apache base class before using any apache defined resources")
  }
  $apache_name = $apache::params::apache_name

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")
  validate_bool($ip_based)
  validate_bool($configure_firewall)
  validate_bool($access_log)
  validate_bool($ssl)
  validate_bool($default_vhost)

  if $ssl {
    include apache::mod::ssl
  }

  # This ensures that the docroot exists
  # But enables it to be specified across multiple vhost resources
  if ! defined(File[$docroot]) {
    file { $docroot:
      ensure  => directory,
      owner   => $docroot_owner,
      group   => $docroot_group,
      require => Package['httpd'],
    }
  }

  # Same as above, but for logroot
  if ! defined(File[$logroot]) {
    file { $logroot:
      ensure  => directory,
      require => Package['httpd'],
    }
  }

  # Open listening ports if they are not already
  if $servername {
    $servername_real = $servername
  } else {
    $servername_real = $name
  }

  # Define log file names
  if ! $access_log_file {
    if $ssl {
      $access_log_file_real = "${servername_real}_access_ssl.log"
    } else {
      $access_log_file_real = "${servername_real}_access.log"
    }
  } else {
    $access_log_file_real = $access_log_file
  }
  if ! $error_log_file {
    if $ssl {
      $error_log_file_real = "${servername_real}_error_ssl.log"
    } else {
      $error_log_file_real = "${servername_real}_error.log"
    }
  } else {
    $error_log_file_real = $error_log_file
  }

  if $ip {
    if $port {
      $listen_addr_port = "${ip}:${port}"
      $nvh_addr_port = "${ip}:${port}"
    } else {
      $nvh_addr_port = $ip
      if ! $servername and ! $ip_based {
        fail("Apache::Vhost[${name}]: must pass 'ip' and/or 'port' parameters for name-based vhosts")
      }
    }
  } else {
    if $port {
      $listen_addr_port = $port
      $nvh_addr_port = "${vhost_name}:${port}"
    } else {
      $nvh_addr_port = $name
      if ! $servername {
        fail("Apache::Vhost[${name}]: must pass 'ip' and/or 'port' parameters, and/or 'servername' parameter")
      }
    }
  }
  if $add_listen {
    if $ip and defined(Apache::Listen[$port]) {
      fail("Apache::Vhost[${name}]: Mixing IP and non-IP Listen directives is not possible; check the add_listen parameter of the apache::vhost define to disable this")
    }
    if ! defined(Apache::Listen[$listen_addr_port]) and $listen_addr_port {
      apache::listen { $listen_addr_port: }
    }
  }
  if ! $ip_based {
    if ! defined(Apache::Namevirtualhost[$nvh_addr_port]) {
      apache::namevirtualhost { $nvh_addr_port: }
    }
  }

  # Load mod_rewrite if needed and not yet loaded
  if $rewrite_rule {
    if ! defined(Apache::Mod['rewrite']) {
      apache::mod { 'rewrite': }
    }
  }

  # Load mod_alias if needed and not yet loaded
  if $scriptalias or ($redirect_source and $redirect_dest) {
    if ! defined(Class['apache::mod::alias']) {
      include apache::mod::alias
    }
  }

  # Load mod_proxy if needed and not yet loaded
  if $proxy_dest {
    if ! defined(Class['apache::mod::proxy']) {
      include apache::mod::proxy
    }
  }

  # Load mod_passenger if needed and not yet loaded
  if $rack_base_uris {
    if ! defined(Class['apache::mod::passenger']) {
      include apache::mod::passenger
    }
  }

  # Configure the defaultness of a vhost
  if $priority {
    $priority_real = $priority
  } elsif $default_vhost {
    $priority_real = '10'
  } else {
    $priority_real = '25'
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
  # - $nvh_addr_port
  # - $servername_real
  # - $serveradmin
  # - $docroot
  # - $options
  # - $override
  # - $logroot
  # - $name
  # - $access_log
  # - $access_log_file_real
  # - $error_log
  # - $error_log_file_real
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
  # setenv fragment:
  #   - $setenv
  #   - $setenvif
  # ssl fragment:
  #   - $ssl
  #   - $ssl_cert
  #   - $ssl_key
  #   - $ssl_chain
  #   - $ssl_certs_dir
  #   - $ssl_ca
  #   - $ssl_crl
  #   - $ssl_crl_path
  file { "${priority_real}-${name}.conf":
    ensure  => $ensure,
    path    => "${apache::vhost_dir}/${priority_real}-${name}.conf",
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

