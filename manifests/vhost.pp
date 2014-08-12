# See README.md for usage information
define apache::vhost(
    $docroot,
    $manage_docroot              = true,
    $virtual_docroot             = false,
    $port                        = undef,
    $ip                          = undef,
    $ip_based                    = false,
    $add_listen                  = true,
    $docroot_owner               = 'root',
    $docroot_group               = $::apache::params::root_group,
    $docroot_mode                = undef,
    $serveradmin                 = undef,
    $ssl                         = false,
    $ssl_cert                    = $::apache::default_ssl_cert,
    $ssl_key                     = $::apache::default_ssl_key,
    $ssl_chain                   = $::apache::default_ssl_chain,
    $ssl_ca                      = $::apache::default_ssl_ca,
    $ssl_crl_path                = $::apache::default_ssl_crl_path,
    $ssl_crl                     = $::apache::default_ssl_crl,
    $ssl_certs_dir               = $::apache::params::ssl_certs_dir,
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
    $override                    = ['None'],
    $directoryindex              = '',
    $vhost_name                  = '*',
    $logroot                     = $::apache::logroot,
    $logroot_mode                = undef,
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
    $suphp_addhandler            = $::apache::params::suphp_addhandler,
    $suphp_engine                = $::apache::params::suphp_engine,
    $suphp_configpath            = $::apache::params::suphp_configpath,
    $php_admin_flags             = [],
    $php_admin_values            = [],
    $no_proxy_uris               = [],
    $proxy_preserve_host         = false,
    $redirect_source             = '/',
    $redirect_dest               = undef,
    $redirect_status             = undef,
    $redirectmatch_status        = undef,
    $redirectmatch_regexp        = undef,
    $rack_base_uris              = undef,
    $headers                     = undef,
    $request_headers             = undef,
    $rewrites                    = undef,
    $rewrite_base                = undef,
    $rewrite_rule                = undef,
    $rewrite_cond                = undef,
    $setenv                      = [],
    $setenvif                    = [],
    $block                       = [],
    $ensure                      = 'present',
    $wsgi_application_group      = undef,
    $wsgi_daemon_process         = undef,
    $wsgi_daemon_process_options = undef,
    $wsgi_import_script          = undef,
    $wsgi_import_script_options  = undef,
    $wsgi_process_group          = undef,
    $wsgi_script_aliases         = undef,
    $wsgi_pass_authorization     = undef,
    $custom_fragment             = undef,
    $itk                         = undef,
    $action                      = undef,
    $fastcgi_server              = undef,
    $fastcgi_socket              = undef,
    $fastcgi_dir                 = undef,
    $additional_includes         = [],
    $apache_version              = $::apache::apache_version,
    $suexec_user_group           = undef,
  ) {
  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['apache']) {
    fail('You must include the apache base class before using any apache defined resources')
  }

  $apache_name = $::apache::params::apache_name

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

  if $suexec_user_group {
    validate_re($suexec_user_group, '^\w+ \w+$',
    "${suexec_user_group} is not supported for suexec_user_group.  Must be 'user group'.")
  }

  # Deprecated backwards-compatibility
  if $rewrite_base {
    warning('Apache::Vhost: parameter rewrite_base is deprecated in favor of rewrites')
  }
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
  if $wsgi_import_script_options {
    validate_hash($wsgi_import_script_options)
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

  if $custom_fragment {
    validate_string($custom_fragment)
  }

  if $ssl and $ensure == 'present' {
    include ::apache::mod::ssl
    # Required for the AddType lines.
    include ::apache::mod::mime
  }

  if $virtual_docroot {
    include ::apache::mod::vhost_alias
  }

  if $wsgi_daemon_process {
    include ::apache::mod::wsgi
  }

  if $suexec_user_group {
    include ::apache::mod::suexec
  }

  # Configure the defaultness of a vhost
  if $priority {
    $priority_real = $priority
  } elsif $default_vhost {
    $priority_real = '10'
  } else {
    $priority_real = '25'
  }

  ## Apache include does not always work with spaces in the filename
  $filename = regsubst($name, ' ', '_', 'G')

  # This ensures that the docroot exists
  # But enables it to be specified across multiple vhost resources
  if ! defined(File[$docroot]) and $manage_docroot {
    file { $docroot:
      ensure  => directory,
      owner   => $docroot_owner,
      group   => $docroot_group,
      mode    => $docroot_mode,
      require => Package['httpd'],
      before  => File["${priority_real}-${filename}.conf"],
    }
  }

  # Same as above, but for logroot
  if ! defined(File[$logroot]) and $ensure == 'present' {
    file { $logroot:
      ensure  => directory,
      mode    => $logroot_mode,
      require => Package['httpd'],
    }
  }


  # Is apache::mod::passenger enabled (or apache::mod['passenger'])
  $passenger_enabled = defined(Apache::Mod['passenger'])

  # Define log file names
  if $access_log_file {
    $access_log_destination = "${logroot}/${access_log_file}"
  } elsif $access_log_pipe {
    $access_log_destination = $access_log_pipe
  } elsif $access_log_syslog {
    $access_log_destination = $access_log_syslog
  } else {
    if $ssl {
      $access_log_destination = "${logroot}/${name}_access_ssl.log"
    } else {
      $access_log_destination = "${logroot}/${name}_access.log"
    }
  }

  if $error_log_file {
    $error_log_destination = "${logroot}/${error_log_file}"
  } elsif $error_log_pipe {
    $error_log_destination = $error_log_pipe
  } elsif $error_log_syslog {
    $error_log_destination = $error_log_syslog
  } else {
    if $ssl {
      $error_log_destination = "${logroot}/${name}_error_ssl.log"
    } else {
      $error_log_destination = "${logroot}/${name}_error.log"
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
      $listen_addr_port = undef
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
      $listen_addr_port = undef
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
      ::apache::listen { $listen_addr_port: }
    }
  }
  if ! $ip_based {
    if ! defined(Apache::Namevirtualhost[$nvh_addr_port]) and $ensure == 'present' and (versioncmp($apache_version, '2.4') < 0) {
      ::apache::namevirtualhost { $nvh_addr_port: }
    }
  }

  # Load mod_rewrite if needed and not yet loaded
  if $rewrites or $rewrite_cond {
    if ! defined(Class['apache::mod::rewrite']) {
      include ::apache::mod::rewrite
    }
  }

  # Load mod_alias if needed and not yet loaded
  if ($scriptalias or $scriptaliases != []) or ($redirect_source and $redirect_dest) {
    if ! defined(Class['apache::mod::alias']) {
      include ::apache::mod::alias
    }
  }

  # Load mod_proxy if needed and not yet loaded
  if ($proxy_dest or $proxy_pass) {
    if ! defined(Class['apache::mod::proxy']) {
      include ::apache::mod::proxy
    }
    if ! defined(Class['apache::mod::proxy_http']) {
      include ::apache::mod::proxy_http
    }
  }

  # Load mod_passenger if needed and not yet loaded
  if $rack_base_uris {
    if ! defined(Class['apache::mod::passenger']) {
      include ::apache::mod::passenger
    }
  }

  # Load mod_fastci if needed and not yet loaded
  if $fastcgi_server and $fastcgi_socket {
    if ! defined(Class['apache::mod::fastcgi']) {
      include ::apache::mod::fastcgi
    }
  }

  # Check if mod_headers is required to process $headers/$request_headers
  if $headers or $request_headers {
    if ! defined(Class['apache::mod::headers']) {
      include ::apache::mod::headers
    }
  }

  ## Create a default directory list if none defined
  if $directories {
    if !is_hash($directories) and !(is_array($directories) and is_hash($directories[0])) {
      fail("Apache::Vhost[${name}]: 'directories' must be either a Hash or an Array of Hashes")
    }
    $_directories = $directories
  } else {
    $_directory = {
      provider       => 'directory',
      path           => $docroot,
      options        => $options,
      allow_override => $override,
      directoryindex => $directoryindex,
    }

    if versioncmp($apache_version, '2.4') >= 0 {
      $_directory_version = {
        require => 'all granted',
      }
    } else {
      $_directory_version = {
        order => 'allow,deny',
        allow => 'from all',
      }
    }

    $_directories = [ merge($_directory, $_directory_version) ]
  }

  concat { "${priority_real}-${filename}.conf":
    ensure  => $ensure,
    path    => "${::apache::vhost_dir}/${priority_real}-${filename}.conf",
    owner   => 'root',
    group   => $::apache::params::root_group,
    mode    => '0644',
    order   => 'numeric',
    require => [
      Package['httpd'],
      File[$logroot],
    ],
    notify  => Service['httpd'],
  }
  if $::osfamily == 'Debian' {
    $vhost_enable_dir = $::apache::vhost_enable_dir
    $vhost_symlink_ensure = $ensure ? {
      present => link,
      default => $ensure,
    }
    file{ "${priority_real}-${filename}.conf symlink":
      ensure  => $vhost_symlink_ensure,
      path    => "${vhost_enable_dir}/${priority_real}-${filename}.conf",
      target  => "${::apache::vhost_dir}/${priority_real}-${filename}.conf",
      owner   => 'root',
      group   => $::apache::params::root_group,
      mode    => '0644',
      require => Concat["${priority_real}-${filename}.conf"],
      notify  => Service['httpd'],
    }
  }

  concat::fragment { "${name}-apache-header":
    target  => "${priority_real}-${filename}.conf",
    order   => 0,
    content => template('apache/vhost/_file_header.erb'),
  }

  concat::fragment { "${name}-docroot":
    target  => "${priority_real}-${filename}.conf",
    order   => 10,
    content => template('apache/vhost/_docroot.erb'),
  }

  concat::fragment { "${name}-aliases":
    target  => "${priority_real}-${filename}.conf",
    order   => 20,
    content => template('apache/vhost/_aliases.erb'),
  }

  concat::fragment { "${name}-itk":
    target  => "${priority_real}-${filename}.conf",
    order   => 30,
    content => template('apache/vhost/_itk.erb'),
  }

  concat::fragment { "${name}-fallbackresource":
    target  => "${priority_real}-${filename}.conf",
    order   => 40,
    content => template('apache/vhost/_fallbackresource.erb'),
  }

  concat::fragment { "${name}-directories":
    target  => "${priority_real}-${filename}.conf",
    order   => 50,
    content => template('apache/vhost/_directories.erb'),
  }

  concat::fragment { "${name}-additional_includes":
    target  => "${priority_real}-${filename}.conf",
    order   => 60,
    content => template('apache/vhost/_additional_includes.erb'),
  }

  concat::fragment { "${name}-logging":
    target  => "${priority_real}-${filename}.conf",
    order   => 70,
    content => template('apache/vhost/_logging.erb'),
  }

  concat::fragment { "${name}-access_log":
    target  => "${priority_real}-${filename}.conf",
    order   => 80,
    content => template('apache/vhost/_access_log.erb'),
  }

  concat::fragment { "${name}-action":
    target  => "${priority_real}-${filename}.conf",
    order   => 90,
    content => template('apache/vhost/_action.erb'),
  }

  concat::fragment { "${name}-block":
    target  => "${priority_real}-${filename}.conf",
    order   => 100,
    content => template('apache/vhost/_block.erb'),
  }

  concat::fragment { "${name}-error_document":
    target  => "${priority_real}-${filename}.conf",
    order   => 110,
    content => template('apache/vhost/_error_document.erb'),
  }

  concat::fragment { "${name}-proxy":
    target  => "${priority_real}-${filename}.conf",
    order   => 120,
    content => template('apache/vhost/_proxy.erb'),
  }

  concat::fragment { "${name}-rack":
    target  => "${priority_real}-${filename}.conf",
    order   => 130,
    content => template('apache/vhost/_rack.erb'),
  }

  concat::fragment { "${name}-redirect":
    target  => "${priority_real}-${filename}.conf",
    order   => 140,
    content => template('apache/vhost/_redirect.erb'),
  }

  concat::fragment { "${name}-rewrite":
    target  => "${priority_real}-${filename}.conf",
    order   => 150,
    content => template('apache/vhost/_rewrite.erb'),
  }

  concat::fragment { "${name}-scriptalias":
    target  => "${priority_real}-${filename}.conf",
    order   => 160,
    content => template('apache/vhost/_scriptalias.erb'),
  }

  concat::fragment { "${name}-serveralias":
    target  => "${priority_real}-${filename}.conf",
    order   => 170,
    content => template('apache/vhost/_serveralias.erb'),
  }

  concat::fragment { "${name}-setenv":
    target  => "${priority_real}-${filename}.conf",
    order   => 180,
    content => template('apache/vhost/_setenv.erb'),
  }

  concat::fragment { "${name}-ssl":
    target  => "${priority_real}-${filename}.conf",
    order   => 190,
    content => template('apache/vhost/_ssl.erb'),
  }

  concat::fragment { "${name}-suphp":
    target  => "${priority_real}-${filename}.conf",
    order   => 200,
    content => template('apache/vhost/_suphp.erb'),
  }

  concat::fragment { "${name}-php_admin":
    target  => "${priority_real}-${filename}.conf",
    order   => 210,
    content => template('apache/vhost/_php_admin.erb'),
  }

  concat::fragment { "${name}-header":
    target  => "${priority_real}-${filename}.conf",
    order   => 220,
    content => template('apache/vhost/_header.erb'),
  }

  concat::fragment { "${name}-requestheader":
    target  => "${priority_real}-${filename}.conf",
    order   => 230,
    content => template('apache/vhost/_requestheader.erb'),
  }

  concat::fragment { "${name}-wsgi":
    target  => "${priority_real}-${filename}.conf",
    order   => 240,
    content => template('apache/vhost/_wsgi.erb'),
  }

  concat::fragment { "${name}-custom_fragment":
    target  => "${priority_real}-${filename}.conf",
    order   => 250,
    content => template('apache/vhost/_custom_fragment.erb'),
  }

  concat::fragment { "${name}-fastcgi":
    target  => "${priority_real}-${filename}.conf",
    order   => 260,
    content => template('apache/vhost/_fastcgi.erb'),
  }

  concat::fragment { "${name}-suexec":
    target  => "${priority_real}-${filename}.conf",
    order   => 270,
    content => template('apache/vhost/_suexec.erb'),
  }

  concat::fragment { "${name}-file_footer":
    target  => "${priority_real}-${filename}.conf",
    order   => 999,
    content => template('apache/vhost/_file_footer.erb'),
  }
}
