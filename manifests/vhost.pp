# Definition: apache::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - The $port to configure the host on
# - The $docroot provides the DocumentRoot variable
# - The $virtual_docroot provides VirtualDocumentationRoot variable
# - The $serveradmin will specify an email address for Apache that it will
#   display when it renders one of it's error pages
# - The $ssl option is set true or false to enable SSL for this Virtual Host
# - The $priority of the site
# - The $servername is the primary name of the virtual host
# - The $serveraliases of the site
# - The $ip to configure the host on, defaulting to *
# - The $options for the given vhost
# - The $override for the given vhost (list of AllowOverride arguments)
# - The $vhost_name for name based virtualhosting, defaulting to *
# - The $logroot specifies the location of the virtual hosts logfiles, default
#   to /var/log/<apache log location>/
# - The $log_level specifies the verbosity of the error log for this vhost. Not
#   set by default for the vhost, instead the global server configuration default
#   of 'warn' is used.
# - The $access_log specifies if *_access.log directives should be configured.
# - The $ensure specifies if vhost file is present or absent.
# - The $request_headers is a list of RequestHeader statement strings as per http://httpd.apache.org/docs/2.2/mod/mod_headers.html#requestheader
# - $aliases is a list of Alias hashes for mod_alias as per http://httpd.apache.org/docs/current/mod/mod_alias.html
#   each statement is a hash in the form of { alias => '/alias', path => '/real/path/to/directory' }
# - $directories is a lost of hashes for creating <Directory> statements as per http://httpd.apache.org/docs/2.2/mod/core.html#directory
#   each statement is a hash in the form of { path => '/path/to/directory', <directive> => <value>}
#   see README.md for list of supported directives.
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
#  # Multiple Mod Rewrites:
#  apache::vhost { 'site.name.fqdn':
#    port => '80',
#    docroot => '/path/to/docroot',
#    rewrites => [
#      {
#        comment       => 'force www domain',
#        rewrite_cond => ['%{HTTP_HOST} ^([a-z.]+)?example.com$ [NC]', '%{HTTP_HOST} !^www. [NC]'],
#        rewrite_rule => ['.? http://www.%1example.com%{REQUEST_URI} [R=301,L]']
#      },
#      {
#        comment       => 'prevent image hotlinking',
#        rewrite_cond => ['%{HTTP_REFERER} !^$', '%{HTTP_REFERER} !^http://(www.)?example.com/ [NC]'],
#        rewrite_rule => ['.(gif|jpg|png)$ - [F]']
#      },
#    ]
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
#    rewrites => [
#      {
#        comment       => "redirect non-SSL traffic to SSL site",
#        rewrite_cond => ['%{HTTPS} off'],
#        rewrite_rule => ['(.*) https://%{HTTPS_HOST}%{REQUEST_URI}']
#      }
#    ]
#  }
#  apache::vhost { 'site.name.fqdn':
#    port            => '80',
#    docroot         => '/path/to/other_docroot',
#    custom_fragment => template("${module_name}/my_fragment.erb"),
#  }
#
define apache::vhost(
    $docroot,
    $virtual_docroot             = false,
    $port                        = undef,
    $ip                          = undef,
    $ip_based                    = false,
    $add_listen                  = true,
    $docroot_owner               = 'root',
    $docroot_group               = $apache::params::root_group,
    $serveradmin                 = false,
    $ssl                         = false,
    $ssl_cert                    = $apache::default_ssl_cert,
    $ssl_key                     = $apache::default_ssl_key,
    $ssl_chain                   = $apache::default_ssl_chain,
    $ssl_ca                      = $apache::default_ssl_ca,
    $ssl_crl_path                = $apache::default_ssl_crl_path,
    $ssl_crl                     = $apache::default_ssl_crl,
    $ssl_certs_dir               = $apache::params::ssl_certs_dir,
    $ssl_protocol                = undef,
    $ssl_cipher                  = undef,
    $ssl_honorcipherorder        = undef,
    $ssl_verify_client           = undef,
    $ssl_verify_depth            = undef,
    $ssl_options                 = undef,
    $ssl_proxyengine             = false,
    $priority                    = undef,
    $default_vhost               = false,
    $servername                  = $name,
    $serveraliases               = [],
    $options                     = ['Indexes','FollowSymLinks','MultiViews'],
    $index_options               = [],
    $index_order_default         = [],
    $override                    = ['None'],
    $directoryindex              = '',
    $vhost_name                  = '*',
    $logroot                     = $apache::logroot,
    $log_level                   = undef,
    $access_log                  = true,
    $access_log_file             = undef,
    $access_log_pipe             = undef,
    $access_log_syslog           = undef,
    $access_log_format           = undef,
    $access_log_env_var          = undef,
    $aliases                     = undef,
    $directories                 = undef,
    $error_log                   = true,
    $error_log_file              = undef,
    $error_log_pipe              = undef,
    $error_log_syslog            = undef,
    $error_documents             = [],
    $fallbackresource            = undef,
    $scriptalias                 = undef,
    $scriptaliases               = [],
    $proxy_dest                  = undef,
    $proxy_pass                  = undef,
    $suphp_addhandler            = $apache::params::suphp_addhandler,
    $suphp_engine                = $apache::params::suphp_engine,
    $suphp_configpath            = $apache::params::suphp_configpath,
    $php_admin_flags             = [],
    $php_admin_values            = [],
    $no_proxy_uris               = [],
    $redirect_source             = '/',
    $redirect_dest               = undef,
    $redirect_status             = undef,
    $rack_base_uris              = undef,
    $request_headers             = undef,
    $rewrites                    = undef,
    $rewrite_rule                = undef,
    $rewrite_cond                = undef,
    $setenv                      = [],
    $setenvif                    = [],
    $block                       = [],
    $ensure                      = 'present',
    $wsgi_daemon_process         = undef,
    $wsgi_daemon_process_options = undef,
    $wsgi_process_group          = undef,
    $wsgi_script_aliases         = undef,
    $custom_fragment             = undef,
    $itk                         = undef,
    $fastcgi_server              = undef,
    $fastcgi_socket              = undef,
    $fastcgi_dir                 = undef,
    $additional_includes         = [],
  ) {
  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['apache']) {
    fail('You must include the apache base class before using any apache defined resources')
  }
  $apache_name = $apache::params::apache_name

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")
  validate_re($suphp_engine, '^(on|off)$',
  "${suphp_engine} is not supported for suphp_engine.
  Allowed values are 'on' and 'off'.")
  validate_bool($ip_based)
  validate_bool($access_log)
  validate_bool($error_log)
  validate_bool($ssl)
  validate_bool($default_vhost)
  validate_bool($ssl_proxyengine)
  if $rewrites {
    validate_array($rewrites)
    validate_hash($rewrites[0])
  }

  # Deprecated backwards-compatibility
  if $rewrite_rule {
    warning('Apache::Vhost: parameter rewrite_rule is deprecated in favor of rewrites')
  }
  if $rewrite_cond {
    warning('Apache::Vhost parameter rewrite_cond is deprecated in favor of rewrites')
  }

  if $wsgi_script_aliases {
    validate_hash($wsgi_script_aliases)
  }
  if $wsgi_daemon_process_options {
    validate_hash($wsgi_daemon_process_options)
  }
  if $itk {
    validate_hash($itk)
  }

  if $log_level {
    validate_re($log_level, '^(emerg|alert|crit|error|warn|notice|info|debug)$',
    "Log level '${log_level}' is not one of the supported Apache HTTP Server log levels.")
  }

  if $access_log_file and $access_log_pipe {
    fail("Apache::Vhost[${name}]: 'access_log_file' and 'access_log_pipe' cannot be defined at the same time")
  }

  if $error_log_file and $error_log_pipe {
    fail("Apache::Vhost[${name}]: 'error_log_file' and 'error_log_pipe' cannot be defined at the same time")
  }

  if $fallbackresource {
    validate_re($fallbackresource, '^/|disabled', 'Please make sure fallbackresource starts with a / (or is "disabled")')
  }

  if $ssl and $ensure == 'present' {
    include apache::mod::ssl
    # Required for the AddType lines.
    include apache::mod::mime
  }

  if $virtual_docroot {
    include apache::mod::vhost_alias
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


  # Is apache::mod::passenger enabled (or apache::mod['passenger'])
  $passenger_enabled = defined(Apache::Mod['passenger'])

  # Define log file names
  if $access_log_file {
    $access_log_destination = "${logroot}/${access_log_file}"
  } elsif $access_log_pipe {
    $access_log_destination = "\"${access_log_pipe}\""
  } elsif $access_log_syslog {
    $access_log_destination = $access_log_syslog
  } else {
    if $ssl {
      $access_log_destination = "${logroot}/${servername}_access_ssl.log"
    } else {
      $access_log_destination = "${logroot}/${servername}_access.log"
    }
  }

  if $error_log_file {
    $error_log_destination = "${logroot}/${error_log_file}"
  } elsif $error_log_pipe {
    $error_log_destination = "\"${error_log_pipe}\""
  } elsif $error_log_syslog {
    $error_log_destination = $error_log_syslog
  } else {
    if $ssl {
      $error_log_destination = "${logroot}/${servername}_error_ssl.log"
    } else {
      $error_log_destination = "${logroot}/${servername}_error.log"
    }
  }

  # Set access log format
  if $access_log_format {
    $_access_log_format = "\"${access_log_format}\""
  } else {
    $_access_log_format = 'combined'
  }

  if $access_log_env_var {
    $_access_log_env_var = "env=${access_log_env_var}"
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
    if ! defined(Apache::Listen[$listen_addr_port]) and $listen_addr_port and $ensure == 'present' {
      apache::listen { $listen_addr_port: }
    }
  }
  if ! $ip_based {
    if ! defined(Apache::Namevirtualhost[$nvh_addr_port]) and $ensure == 'present' {
      apache::namevirtualhost { $nvh_addr_port: }
    }
  }

  # Load mod_rewrite if needed and not yet loaded
  if $rewrites or $rewrite_cond {
    if ! defined(Apache::Mod['rewrite']) {
      apache::mod { 'rewrite': }
    }
  }

  # Load mod_alias if needed and not yet loaded
  if ($scriptalias or $scriptaliases != []) or ($redirect_source and $redirect_dest) {
    if ! defined(Class['apache::mod::alias']) {
      include apache::mod::alias
    }
  }

  # Load mod_proxy if needed and not yet loaded
  if ($proxy_dest or $proxy_pass) {
    if ! defined(Class['apache::mod::proxy']) {
      include apache::mod::proxy
    }
    if ! defined(Class['apache::mod::proxy_http']) {
      include apache::mod::proxy_http
    }
  }

  # Load mod_passenger if needed and not yet loaded
  if $rack_base_uris {
    if ! defined(Class['apache::mod::passenger']) {
      include apache::mod::passenger
    }
  }

  # Load mod_fastci if needed and not yet loaded
  if $fastcgi_server and $fastcgi_socket {
    if ! defined(Class['apache::mod::fastcgi']) {
      include apache::mod::fastcgi
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

  # Check if mod_headers is required to process $request_headers
  if $request_headers {
    if ! defined(Class['apache::mod::headers']) {
      include apache::mod::headers
    }
  }

  ## Apache include does not always work with spaces in the filename
  $filename = regsubst($name, ' ', '_', 'G')

  ## Create a default directory list if none defined
  if $directories {
    $_directories = $directories
  } else {
    $_directories = [ {
      provider       => 'directory',
      path           => $docroot,
      options        => $options,
      allow_override => $override,
      directoryindex => $directoryindex,
      order          => 'allow,deny',
      allow          => 'from all',
    } ]
  }

  concat { "${priority_real}-${filename}.conf":
    path    => "${apache::vhost_dir}/${priority_real}-${filename}.conf",
    owner   => 'root',
    group   => $apache::params::root_group,
    mode    => '0644',
    require => [
      Package['httpd'],
      File[$docroot],
      File[$logroot],
    ],
    notify  => Service['httpd'],
  }

  # nvh_addr_port
  # servername
  # serveradmin
  concat::fragment { "${name}-apache-header":
    target  => "${priority_real}-${filename}.conf",
    order   => 01,
    content => template('apache/vhost/_header.erb'),
  }
  # virtual_docroot
  # docroot
  concat::fragment { "${name}-apache-docroot":
    target  => "${priority_real}-${filename}.conf",
    order   => 10,
    content => template('apache/vhost/_docroot.erb'),
  }

  if $aliases {
    # aliases
    # alias_statement
    concat::fragment { "${name}-apache-aliases":
      target  => "${priority_real}-${filename}.conf",
      order   => 20,
      content => template('apache/vhost/_aliases.erb'),
    }
  }

  if $itk {
    # itk
    concat::fragment { "${name}-apache-itk":
      target  => "${priority_real}-${filename}.conf",
      order   => 30,
      content => template('apache/vhost/_itk.erb'),
    }
  }

  if $fallbackresource {
    # fallbackresource
    concat::fragment { "${name}-apache-fallbackresource":
      target  => "${priority_real}-${filename}.conf",
      order   => 40,
      content => template('apache/vhost/_fallbackresource.erb'),
    }
  }

  if $_directories {
    # _directories
    concat::fragment { "${name}-apache-directories":
      target  => "${priority_real}-${filename}.conf",
      order   => 50,
      content => template('apache/vhost/_directories.erb'),
    }
  }

  if $additional_includes {
    # additional_includes
    concat::fragment { "${name}-apache-additional_includes":
      target  => "${priority_real}-${filename}.conf",
      order   => 60,
      content => template('apache/vhost/_additional_includes.erb'),
    }
  }

  if ($log_level or $error_log) {
    # log_level
    # error_log
    concat::fragment { "${name}-apache-logging":
      target  => "${priority_real}-${filename}.conf",
      order   => 70,
      content => template('apache/vhost/_logging.erb'),
    }
  }

  concat::fragment { "${name}-apache-serversignature":
    target  => "${priority_real}-${filename}.conf",
    order   => 80,
    content => template('apache/vhost/_serversignature.erb'),
  }

  if ($access_log and $_access_log_env_var) {
    # access_log
    # access_log_env_var
    concat::fragment { "${name}-apache-accesslog":
      target  => "${priority_real}-${filename}.conf",
      order   => 90,
      content => template('apache/vhost/_access_log.erb'),
    }
  }

  if $block != [] {
    # block
    concat::fragment { "${name}-apache-block":
      target  => "${priority_real}-${filename}.conf",
      order   => 100,
      content => template('apache/vhost/_block.erb'),
    }
  }

  if $error_documents != [] {
    # error_documents
    concat::fragment { "${name}-apache-error_documents":
      target  => "${priority_real}-${filename}.conf",
      order   => 110,
      content => template('apache/vhost/_error_document.erb'),
    }
  }

  if ($proxy_dest or $proxy_pass) {
    # proxy_dest
    # proxy_pass
    concat::fragment { "${name}-apache-proxy":
      target  => "${priority_real}-${filename}.conf",
      order   => 120,
      content => template('apache/vhost/_proxy.erb'),
    }
  }

  if $rack_base_uris {
    # rack_base_uris
    concat::fragment { "${name}-apache-rack":
      target  => "${priority_real}-${filename}.conf",
      order   => 130,
      content => template('apache/vhost/_rack.erb'),
    }
  }

  if ($redirect_source and $redirect_dest) {
    # redirect_source
    # redirect_dest
    concat::fragment { "${name}-apache-redirect":
      target  => "${priority_real}-${filename}.conf",
      order   => 140,
      content => template('apache/vhost/_redirect.erb'),
    }
  }

  if $rewrites {
    # rewrites
    concat::fragment { "${name}-apache-rewrite":
      target  => "${priority_real}-${filename}.conf",
      order   => 150,
      content => template('apache/vhost/_rewrite.erb'),
    }
  }

  if $scriptaliases != [] {
    # scriptaliases
    concat::fragment { "${name}-apache-scriptaliases":
      target  => "${priority_real}-${filename}.conf",
      order   => 160,
      content => template('apache/vhost/_scriptalias.erb'),
    }
  }

  if $serveraliases {
    # serveralias
    concat::fragment { "${name}-apache-rewrites":
      target  => "${priority_real}-${filename}.conf",
      order   => 170,
      content => template('apache/vhost/_serveralias.erb'),
    }
  }

  if $setenv != [] {
    # setenv
    # setenvif
    concat::fragment { "${name}-apache-setenv":
      target  => "${priority_real}-${filename}.conf",
      order   => 180,
      content => template('apache/vhost/_setenv.erb'),
    }
  }

  if $ssl {
    # ssl
    # ssl_cert
    # ssl_key
    # ssl_chain
    # ssl_certs_dir
    # ssl_ca
    # ssl_crl_path
    # ssl_crl
    # ssl_proxyengine
    # ssl_protocol
    # ssl_protocol
    # ssl_cipher
    # ssl_honorcipherorder
    # ssl_verify_client
    # ssl_verify_depths
    concat::fragment { "${name}-apache-ssl":
      target  => "${priority_real}-${filename}.conf",
      order   => 190,
      content => template('apache/vhost/_ssl.erb'),
    }
  }

  if $suphp_engine == 'on' {
    # suphp_engine
    # suphp_addhandler
    # suphp_configpath
    concat::fragment { "${name}-apache-suphp":
      target  => "${priority_real}-${filename}.conf",
      order   => 200,
      content => template('apache/vhost/_suphp.erb'),
    }
  }

  if $php_admin_values != [] {
    # php_admin_values
    # php_admin_flags
    concat::fragment { "${name}-apache-php_admin":
      target  => "${priority_real}-${filename}.conf",
      order   => 210,
      content => template('apache/vhost/_php_admin.erb'),
    }
  }

  if $request_headers {
    # request_headers
    # request_statement
    concat::fragment { "${name}-apache-requestheader":
      target  => "${priority_real}-${filename}.conf",
      order   => 220,
      content => template('apache/vhost/_requestheader.erb'),
    }
  }

  if ($wsgi_daemon_process and $wsgi_daemon_process_options) {
    # wsgi_daemon_process
    # wsgi_daemon_process_options
    # wsgi_process_group
    # wsgi_script_aliases
    concat::fragment { "${name}-apache-wsgi":
      target  => "${priority_real}-${filename}.conf",
      order   => 230,
      content => template('apache/vhost/_wsgi.erb'),
    }
  }

  if $custom_fragment {
    # custom_fragment
    concat::fragment { "${name}-apache-custom_fragment":
      target  => "${priority_real}-${filename}.conf",
      order   => 240,
      content => template('apache/vhost/_custom_fragment.erb'),
    }
  }

  if $fastcgi_server {
    # fastcgi_server
    # fastcgi_socket
    # fastcgi_dir
    concat::fragment { "${name}-apache-fastcgi":
      target  => "${priority_real}-${filename}.conf",
      order   => 250,
      content => template('apache/vhost/_fastcgi.erb'),
    }
  }

  concat::fragment { "${name}-apache-footer":
    target  => "${priority_real}-${filename}.conf",
    order   => 999,
    content => template('apache/vhost/_footer.erb'),
  }

  if $::osfamily == 'Debian' {
    $vhost_enable_dir = $apache::vhost_enable_dir
    $vhost_symlink_ensure = $ensure ? {
      present => link,
      default => $ensure,
    }
    file{ "${priority_real}-${filename}.conf symlink":
      ensure  => $vhost_symlink_ensure,
      path    => "${vhost_enable_dir}/${priority_real}-${filename}.conf",
      target  => "${apache::vhost_dir}/${priority_real}-${filename}.conf",
      owner   => 'root',
      group   => $apache::params::root_group,
      mode    => '0644',
      require => File["${priority_real}-${filename}.conf"],
      notify  => Service['httpd'],
    }
  }
}
