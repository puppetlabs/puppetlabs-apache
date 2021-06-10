# @summary
#   Guides the basic setup and installation of Apache on your system.
#
# When this class is declared with the default options, Puppet:
# - Installs the appropriate Apache software package and [required Apache modules](#default_mods) for your operating system.
# - Places the required configuration files in a directory, with the [default location](#conf_dir) determined by your operating system.
# - Configures the server with a default virtual host and standard port (`80`) and address (`\*`) bindings.
# - Creates a document root directory determined by your operating system, typically `/var/www`.
# - Starts the Apache service.
#
# @example
#   class { 'apache': }
#
# @param allow_encoded_slashes
#   Sets the server default for the `AllowEncodedSlashes` declaration, which modifies the 
#   responses to URLs containing '\' and '/' characters. If not specified, this parameter omits 
#   the declaration from the server's configuration and uses Apache's default setting of 'off'.
#
# @param apache_version
#   Configures module template behavior, package names, and default Apache modules by defining 
#   the version of Apache to use. We do not recommend manually configuring this parameter 
#   without reason.
#
# @param conf_dir
#   Sets the directory where the Apache server's main configuration file is located.
#
# @param conf_template
#   Defines the template used for the main Apache configuration file. Modifying this 
#   parameter is potentially risky, as the apache module is designed to use a minimal 
#   configuration file customized by `conf.d` entries.
#
# @param confd_dir
#   Sets the location of the Apache server's custom configuration directory.
#
# @param default_charset
#   Used as the `AddDefaultCharset` directive in the main configuration file.
#
# @param default_confd_files
#   Determines whether Puppet generates a default set of includable Apache configuration files 
#   in the directory defined by the `confd_dir` parameter. These configuration files 
#   correspond to what is typically installed with the Apache package on the server's 
#   operating system.
#
# @param default_mods
#   Determines whether to configure and enable a set of default Apache modules depending on 
#   your operating system.<br />
#   If `false`, Puppet includes only the Apache modules required to make the HTTP daemon work 
#   on your operating system, and you can declare any other modules separately using the 
#   `apache::mod::<MODULE NAME>` class or `apache::mod` defined type.<br />
#   If `true`, Puppet installs additional modules, depending on the operating system and 
#   the values of `apache_version` and `mpm_module` parameters. Because these lists of 
#   modules can change frequently, consult the Puppet module's code for up-to-date lists.<br />
#   If this parameter contains an array, Puppet instead enables all passed Apache modules.
#
# @param default_ssl_ca
#   Sets the default certificate authority for the Apache server.<br />
#   Although the default value results in a functioning Apache server, you **must** update 
#   this parameter with your certificate authority information before deploying this server in 
#   a production environment.
#
# @param default_ssl_cert
#   Sets the SSL encryption certificate location.<br />
#   Although the default value results in a functioning Apache server, you **must** update this 
#   parameter with your certificate location before deploying this server in a production environment.
#
# @param default_ssl_chain
#   Sets the default SSL chain location.<br />
#   Although this default value results in a functioning Apache server, you **must** update 
#   this parameter with your SSL chain before deploying this server in a production environment.
#
# @param default_ssl_crl
#   Sets the path of the default certificate revocation list (CRL) file to use.<br />
#   Although this default value results in a functioning Apache server, you **must** update 
#   this parameter with the CRL file path before deploying this server in a production 
#   environment. You can use this parameter with or in place of the `default_ssl_crl_path`.
#
# @param default_ssl_crl_path
#   Sets the server's certificate revocation list path, which contains your CRLs.<br />
#   Although this default value results in a functioning Apache server, you **must** update 
#   this parameter with the CRL file path before deploying this server in a production environment.
#
# @param default_ssl_crl_check
#   Sets the default certificate revocation check level via the `SSLCARevocationCheck` directive. 
#   This parameter applies only to Apache 2.4 or higher and is ignored on older versions.<br />
#   Although this default value results in a functioning Apache server, you **must** specify 
#   this parameter when using certificate revocation lists in a production environment.
#
# @param default_ssl_key
#   Sets the SSL certificate key file location.
#   Although the default values result in a functioning Apache server, you **must** update 
#   this parameter with your SSL key's location before deploying this server in a production 
#   environment.
#
# @param default_ssl_reload_on_change
#   Enable reloading of apache if the content of ssl files have changed.
#
# @param default_ssl_vhost
#   Configures a default SSL virtual host.
#   If `true`, Puppet automatically configures the following virtual host using the 
#   `apache::vhost` defined type:
#   ```puppet
#   apache::vhost { 'default-ssl':
#     port            => 443,
#     ssl             => true,
#     docroot         => $docroot,
#     scriptalias     => $scriptalias,
#     serveradmin     => $serveradmin,
#     access_log_file => "ssl_${access_log_file}",
#   }
#   ```
#   **Note**: SSL virtual hosts only respond to HTTPS queries.
#
# @param default_type
#   _Apache 2.2 only_. Sets the MIME `content-type` sent if the server cannot otherwise 
#   determine an appropriate `content-type`. This directive is deprecated in Apache 2.4 and 
#   newer, and is only for backwards compatibility in configuration files.
#
# @param default_vhost
#   Configures a default virtual host when the class is declared.<br />
#   To configure customized virtual hosts, set this parameter's 
#   value to `false`.<br />
#   > **Note**: Apache will not start without at least one virtual host. If you set this 
#   to `false` you must configure a virtual host elsewhere.
#
# @param dev_packages
#   Configures a specific dev package to use.<br />
#   For example, using httpd 2.4 from the IUS yum repo:<br />
#   ``` puppet
#   include ::apache::dev
#   class { 'apache':
#     apache_name  => 'httpd24u',
#     dev_packages => 'httpd24u-devel',
#   }
#   ```
#
# @param docroot
#   Sets the default `DocumentRoot` location.
#
# @param error_documents
#   Determines whether to enable [custom error documents](https://httpd.apache.org/docs/current/custom-error.html) on the Apache server.
#
# @param group
#   Sets the group ID that owns any Apache processes spawned to answer requests.<br />
#   By default, Puppet attempts to manage this group as a resource under the `apache` 
#   class, determining the group based on the operating system as detected by the 
#   `apache::params` class. To prevent the group resource from being created and use a group 
#   created by another Puppet module, set the `manage_group` parameter's value to `false`.<br />
#   > **Note**: Modifying this parameter only changes the group ID that Apache uses to spawn 
#   child processes to access resources. It does not change the user that owns the parent server 
#   process.
#
# @param httpd_dir
#   Sets the Apache server's base configuration directory. This is useful for specially 
#   repackaged Apache server builds but might have unintended consequences when combined 
#   with the default distribution packages.
#
# @param http_protocol_options
#   Specifies the strictness of HTTP protocol checks.<br />
#   Valid options: any sequence of the following alternative values: `Strict` or `Unsafe`, 
#   `RegisteredMethods` or `LenientMethods`, and `Allow0.9` or `Require1.0`.
#
# @param keepalive
#   Determines whether to enable persistent HTTP connections with the `KeepAlive` directive. 
#   If you set this to `On`, use the `keepalive_timeout` and `max_keepalive_requests` parameters 
#   to set relevant options.<br />
#
# @param keepalive_timeout
#   Sets the `KeepAliveTimeout` directive, which determines the amount of time the Apache 
#   server waits for subsequent requests on a persistent HTTP connection. This parameter is 
#   only relevant if the `keepalive` parameter is enabled.
#
# @param max_keepalive_requests
#   Limits the number of requests allowed per connection when the `keepalive` parameter is enabled.
#
# @param hostname_lookups
#   This directive enables DNS lookups so that host names can be logged and passed to 
#   CGIs/SSIs in REMOTE_HOST.<br />
#   > **Note**: If enabled, it impacts performance significantly.
#
# @param ldap_trusted_mode
#  The following modes are supported:
#
#    NONE - no encryption
#    SSL - ldaps:// encryption on default port 636
#    TLS - STARTTLS encryption on default port 389
#  Not all LDAP toolkits support all the above modes. An error message will be logged at
#  runtime if a mode is not supported, and the connection to the LDAP server will fail.
#
#If an ldaps:// URL is specified, the mode becomes SSL and the setting of LDAPTrustedMode is ignored.
#
# @param ldap_verify_server_cert
#  Specifies whether to force the verification of a server certificate when establishing an SSL
#  connection to the LDAP server.
#  On|Off
#
# @param lib_path
#   Specifies the location whereApache module files are stored.<br />
#   > **Note**: Do not configure this parameter manually without special reason.
#
# @param log_level
#   Configures the apache [LogLevel](https://httpd.apache.org/docs/current/mod/core.html#loglevel) directive
#   which adjusts the verbosity of the messages recorded in the error logs.
#
# @param log_formats
#   Define additional `LogFormat` directives. Values: A hash, such as:
#   ``` puppet
#   $log_formats = { vhost_common => '%v %h %l %u %t \"%r\" %>s %b' }
#   ```
#     There are a number of predefined `LogFormats` in the `httpd.conf` that Puppet creates:
#   ``` httpd
#     LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
#     LogFormat "%h %l %u %t \"%r\" %>s %b" common
#     LogFormat "%{Referer}i -> %U" referer
#     LogFormat "%{User-agent}i" agent
#     LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %s %b \"%{Referer}i\" \"%{User-agent}i\"" forwarded
#   ```
#   If your `log_formats` parameter contains one of those, it will be overwritten with **your** definition.
#
# @param logroot
#   Changes the directory of Apache log files for the virtual host.
#
# @param logroot_mode
#   Overrides the default `logroot` directory's mode.<br />
#   > **Note**: Do _not_ grant write access to the directory where the logs are stored 
#   without being aware of the consequences. See the [Apache documentation](https://httpd.apache.org/docs/current/logs.html#security)
#   for details.
#
# @param manage_group
#   When `false`, stops Puppet from creating the group resource.<br />
#   If you have a group created from another Puppet module that you want to use to run Apache, 
#   set this to `false`. Without this parameter, attempting to use a previously established 
#   group results in a duplicate resource error.
#
# @param supplementary_groups
#   A list of groups to which the user belongs. These groups are in addition to the primary group.<br />
#   Notice: This option only has an effect when `manage_user` is set to true.
#
# @param manage_user
#   When `false`, stops Puppet from creating the user resource.<br />
#   This is for instances when you have a user, created from another Puppet module, you want 
#   to use to run Apache. Without this parameter, attempting to use a previously established 
#   user would result in a duplicate resource error.
#
# @param mod_dir
#   Sets where Puppet places configuration files for your Apache modules.
#
# @param mod_libs
#   Allows the user to override default module library names.
#   ```puppet
#   include apache::params
#   class { 'apache':
#     mod_libs => merge($::apache::params::mod_libs, {
#       'wsgi' => 'mod_wsgi_python3.so',
#     })
#   }
#   ```
#
# @param mod_packages
#   Allows the user to override default module package names.
#   ```puppet
#   include apache::params
#   class { 'apache':
#     mod_packages => merge($::apache::params::mod_packages, {
#       'auth_kerb' => 'httpd24-mod_auth_kerb',
#     })
#   }
#   ```
#
# @param mpm_module
#   Determines which [multi-processing module](https://httpd.apache.org/docs/current/mpm.html) (MPM) is loaded and configured for the 
#   HTTPD process. Valid values are: `event`, `itk`, `peruser`, `prefork`, `worker` or `false`.<br />
#   You must set this to `false` to explicitly declare the following classes with custom parameters:
#   - `apache::mod::event`
#   - `apache::mod::itk`
#   - `apache::mod::peruser`
#   - `apache::mod::prefork`
#   - `apache::mod::worker`
#
# @param package_ensure
#   Controls the `package` resource's `ensure` attribute. Valid values are: `absent`, `installed`
#   (or equivalent `present`), or a version string.
#
# @param pidfile
#   Allows settting a custom location for the pid file. Useful if using a custom-built Apache rpm.
#
# @param ports_file
#   Sets the path to the file containing Apache ports configuration.
#
# @param protocols
#   Sets the [Protocols](https://httpd.apache.org/docs/current/en/mod/core.html#protocols) 
#   directive, which lists available protocols for the server.
#
# @param protocols_honor_order
#   Sets the [ProtocolsHonorOrder](https://httpd.apache.org/docs/current/en/mod/core.html#protocolshonororder)
#   directive which determines whether the order of Protocols sets precedence during negotiation.
#
# @param purge_configs
#   Removes all other Apache configs and virtual hosts.<br />
#   Setting this to `false` is a stopgap measure to allow the apache module to coexist with 
#   existing or unmanaged configurations. We recommend moving your configuration to resources 
#   within this module. For virtual host configurations, see `purge_vhost_dir`.
#
# @param purge_vhost_dir
#   If the `vhost_dir` parameter's value differs from the `confd_dir` parameter's, this parameter 
#   determines whether Puppet removes any configurations inside `vhost_dir` that are _not_ managed 
#   by Puppet.<br />
#   Setting `purge_vhost_dir` to `false` is a stopgap measure to allow the apache module to 
#   coexist with existing or otherwise unmanaged configurations within `vhost_dir`.
#
# @param rewrite_lock
#   Allows setting a custom location for a rewrite lock - considered best practice if using 
#   a RewriteMap of type prg in the `rewrites` parameter of your virtual host. This parameter 
#   only applies to Apache version 2.2 or lower and is ignored on newer versions.
#
# @param sendfile
#   Forces Apache to use the Linux kernel's `sendfile` support to serve static files, via the 
#   `EnableSendfile` directive.
#
# @param serveradmin
#   Sets the Apache server administrator's contact information via Apache's `ServerAdmin` directive.
#
# @param servername
#   Sets the Apache server name via Apache's `ServerName` directive.
#   Setting to `false` will not set ServerName at all.
#
# @param server_root
#   Sets the Apache server's root directory via Apache's `ServerRoot` directive.
#
# @param server_signature
#   Configures a trailing footer line to display at the bottom of server-generated documents, 
#   such as error documents and output of certain Apache modules, via Apache's `ServerSignature`
#   directive. Valid values are: `On` or `Off`.
# 
# @param server_tokens
#   Controls how much information Apache sends to the browser about itself and the operating 
#   system, via Apache's `ServerTokens` directive.
# 
# @param service_enable
#   Determines whether Puppet enables the Apache HTTPD service when the system is booted.
# 
# @param service_ensure
#   Determines whether Puppet should make sure the service is running. 
#   Valid values are: `true` (or `running`) or `false` (or `stopped`).<br />
#   The `false` or `stopped` values set the 'httpd' service resource's `ensure` parameter 
#   to `false`, which is useful when you want to let the service be managed by another 
#   application, such as Pacemaker.<br />
# 
# @param service_name
#   Sets the name of the Apache service.
# 
# @param service_manage
#   Determines whether Puppet manages the HTTPD service's state.
#
# @param service_restart
#   Determines whether Puppet should use a specific command to restart the HTTPD service.
#   Values: a command to restart the Apache service.
#
# @param timeout
#   Sets Apache's `TimeOut` directive, which defines the number of seconds Apache waits for 
#   certain events before failing a request.
#
# @param trace_enable
#   Controls how Apache handles `TRACE` requests (per RFC 2616) via the `TraceEnable` directive.
#
# @param use_canonical_name
#   Controls Apache's `UseCanonicalName` directive which controls how Apache handles 
#   self-referential URLs. If not specified, this parameter omits the declaration from the 
#   server's configuration and uses Apache's default setting of 'off'.
#
# @param use_systemd
#   Controls whether the systemd module should be installed on Centos 7 servers, this is 
#   especially useful if using custom-built RPMs.
#
# @param file_mode
#   Sets the desired permissions mode for config files.
#   Valid values are: a string, with permissions mode in symbolic or numeric notation.
#
# @param root_directory_options
#   Array of the desired options for the `/` directory in httpd.conf.
#
# @param root_directory_secured
#   Sets the default access policy for the `/` directory in httpd.conf. A value of `false` 
#   allows access to all resources that are missing a more specific access policy. A value of 
#   `true` denies access to all resources by default. If `true`, more specific rules must be 
#   used to allow access to these resources (for example, in a directory block using the 
#   `directories` parameter).
#
# @param vhost_dir
#   Changes your virtual host configuration files' location.
#
# @param vhost_include_pattern
#   Defines the pattern for files included from the `vhost_dir`.
#   If set to a value like `[^.#]\*.conf[^~]` to make sure that files accidentally created in 
#   this directory (such as files created by version control systems or editor backups) are 
#   *not* included in your server configuration.<br />
#   Some operating systems use a value of `*.conf`. By default, this module creates configuration 
#   files ending in `.conf`.
#
# @param user
#   Changes the user that Apache uses to answer requests. Apache's parent process continues 
#   to run as root, but child processes access resources as the user defined by this parameter. 
#   To prevent Puppet from managing the user, set the `manage_user` parameter to `false`.
#
# @param apache_name
#   The name of the Apache package to install. If you are using a non-standard Apache package 
#   you might need to override the default setting.<br />
#   For CentOS/RHEL Software Collections (SCL), you can also use `apache::version::scl_httpd_version`.
#
# @param error_log
#   The name of the error log file for the main server instance. If the string starts with 
#   `/`, `|`, or `syslog`: the full path is set. Otherwise, the filename  is prefixed with 
#   `$logroot`.
#
# @param scriptalias
#   Directory to use for global script alias
#
# @param access_log_file
#   The name of the access log file for the main server instance.
#
# @param limitreqfields
#   The `limitreqfields` parameter sets the maximum number of request header fields in 
#   an HTTP request. This directive gives the server administrator greater control over 
#   abnormal client request behavior, which may be useful for avoiding some forms of 
#   denial-of-service attacks. The value should be increased if normal clients see an error 
#   response from the server that indicates too many fields were sent in the request.
#
# @param limitreqfieldsize
#   The `limitreqfieldsize` parameter sets the maximum ammount of _bytes_ that will
#   be allowed within a request header.
#
# @param ip
#   Specifies the ip address
#
# @param purge_vdir
#   Removes all other Apache configs and virtual hosts.<br />
#   > **Note**: This parameter is deprecated in favor of the `purge_config` parameter.<br />
# 
# @param conf_enabled
#   Whether the additional config files in `/etc/apache2/conf-enabled` should be managed.
# 
# @param vhost_enable_dir
#   Set's whether the vhost definitions will be stored in sites-availible and if
#   they will be symlinked to and from sites-enabled.
#
# @param mod_enable_dir
#   Set's whether the mods-enabled directory should be managed.
#
# @param ssl_file
#   This parameter allows you to set an ssl.conf file to be managed in order to implement
#   an SSL Certificate.
# 
# @param file_e_tag
#   Sets the server default for the `FileETag` declaration, which modifies the response header 
#   field for static files.
# 
# @param use_optional_includes
#   Specifies whether Apache uses the `IncludeOptional` directive instead of `Include` for 
#   `additional_includes` in Apache 2.4 or newer.
# 
# @param mime_types_additional
#   Specifies any idditional Internet media (mime) types that you wish to be configured.
# 
class apache (
  $apache_name                                                          = $apache::params::apache_name,
  $service_name                                                         = $apache::params::service_name,
  $default_mods                                                         = true,
  Boolean $default_vhost                                                = true,
  $default_charset                                                      = undef,
  Boolean $default_confd_files                                          = true,
  Boolean $default_ssl_vhost                                            = false,
  $default_ssl_cert                                                     = $apache::params::default_ssl_cert,
  $default_ssl_key                                                      = $apache::params::default_ssl_key,
  $default_ssl_chain                                                    = undef,
  $default_ssl_ca                                                       = undef,
  $default_ssl_crl_path                                                 = undef,
  $default_ssl_crl                                                      = undef,
  $default_ssl_crl_check                                                = undef,
  Boolean $default_ssl_reload_on_change                                 = false,
  $default_type                                                         = 'none',
  $dev_packages                                                         = $apache::params::dev_packages,
  $ip                                                                   = undef,
  Boolean $service_enable                                               = true,
  Boolean $service_manage                                               = true,
  $service_ensure                                                       = 'running',
  $service_restart                                                      = undef,
  $purge_configs                                                        = true,
  $purge_vhost_dir                                                      = undef,
  $purge_vdir                                                           = false,
  $serveradmin                                                          = 'root@localhost',
  Enum['On', 'Off', 'on', 'off'] $sendfile                              = 'On',
  $ldap_verify_server_cert                                              = undef,
  $ldap_trusted_mode                                                    = undef,
  $error_documents                                                      = false,
  $timeout                                                              = '60',
  $httpd_dir                                                            = $apache::params::httpd_dir,
  $server_root                                                          = $apache::params::server_root,
  $conf_dir                                                             = $apache::params::conf_dir,
  $confd_dir                                                            = $apache::params::confd_dir,
  Enum['Off', 'On', 'Double', 'off', 'on', 'double'] $hostname_lookups  = $apache::params::hostname_lookups,
  $conf_enabled                                                         = $apache::params::conf_enabled,
  $vhost_dir                                                            = $apache::params::vhost_dir,
  $vhost_enable_dir                                                     = $apache::params::vhost_enable_dir,
  $mod_libs                                                             = $apache::params::mod_libs,
  $mod_packages                                                         = $apache::params::mod_packages,
  $vhost_include_pattern                                                = $apache::params::vhost_include_pattern,
  $mod_dir                                                              = $apache::params::mod_dir,
  $mod_enable_dir                                                       = $apache::params::mod_enable_dir,
  $mpm_module                                                           = $apache::params::mpm_module,
  $lib_path                                                             = $apache::params::lib_path,
  $conf_template                                                        = $apache::params::conf_template,
  $servername                                                           = $apache::params::servername,
  $pidfile                                                              = $apache::params::pidfile,
  Optional[Stdlib::Absolutepath] $rewrite_lock                          = undef,
  Boolean $manage_user                                                  = true,
  Boolean $manage_group                                                 = true,
  $user                                                                 = $apache::params::user,
  $group                                                                = $apache::params::group,
  $http_protocol_options                                                = $apache::params::http_protocol_options,
  $supplementary_groups                                                 = [],
  $keepalive                                                            = $apache::params::keepalive,
  $keepalive_timeout                                                    = $apache::params::keepalive_timeout,
  $max_keepalive_requests                                               = $apache::params::max_keepalive_requests,
  $limitreqfieldsize                                                    = '8190',
  $limitreqfields                                                       = '100',
  $logroot                                                              = $apache::params::logroot,
  $logroot_mode                                                         = $apache::params::logroot_mode,
  Apache::LogLevel $log_level                                           = $apache::params::log_level,
  $log_formats                                                          = {},
  $ssl_file                                                             = undef,
  $ports_file                                                           = $apache::params::ports_file,
  $docroot                                                              = $apache::params::docroot,
  $apache_version                                                       = $apache::version::default,
  $server_tokens                                                        = 'Prod',
  $server_signature                                                     = 'On',
  $trace_enable                                                         = 'On',
  Optional[Enum['on', 'off', 'nodecode']] $allow_encoded_slashes        = undef,
  $file_e_tag                                                           = undef,
  Optional[Enum['On', 'on', 'Off', 'off', 'DNS', 'dns']]
  $use_canonical_name                                          = undef,
  $package_ensure                                                = 'installed',
  Boolean $use_optional_includes                                 = $apache::params::use_optional_includes,
  $use_systemd                                                   = $apache::params::use_systemd,
  $mime_types_additional                                         = $apache::params::mime_types_additional,
  $file_mode                                                     = $apache::params::file_mode,
  $root_directory_options                                        = $apache::params::root_directory_options,
  Boolean $root_directory_secured                                = false,
  $error_log                                                     = $apache::params::error_log,
  $scriptalias                                                   = $apache::params::scriptalias,
  $access_log_file                                               = $apache::params::access_log_file,
  Array[Enum['h2', 'h2c', 'http/1.1']] $protocols                = [],
  Optional[Boolean] $protocols_honor_order                       = undef,
) inherits ::apache::params {
  $valid_mpms_re = $apache_version ? {
    '2.4'   => '(event|itk|peruser|prefork|worker)',
    default => '(event|itk|prefork|worker)'
  }

  if $::osfamily == 'RedHat' and $facts['operatingsystemmajrelease'] == '7' {
    # On redhat 7 the ssl.conf lives in /etc/httpd/conf.d (the confd_dir)
    # when all other module configs live in /etc/httpd/conf.modules.d (the
    # mod_dir). On all other platforms and versions, ssl.conf lives in the
    # mod_dir. This should maintain the expected location of ssl.conf
    $_ssl_file = $ssl_file ? {
      undef   => "${apache::confd_dir}/ssl.conf",
      default => $ssl_file
    }
  } else {
    $_ssl_file = $ssl_file ? {
      undef   => "${apache::mod_dir}/ssl.conf",
      default => $ssl_file
    }
  }

  if $mpm_module and $mpm_module != 'false' { # lint:ignore:quoted_booleans
    assert_type(Pattern[$valid_mpms_re], $mpm_module)
  }

  # NOTE: on FreeBSD it's mpm module's responsibility to install httpd package.
  # NOTE: the same strategy may be introduced for other OSes. For this, you
  # should delete the 'if' block below and modify all MPM modules' manifests
  # such that they include apache::package class (currently event.pp, itk.pp,
  # peruser.pp, prefork.pp, worker.pp).
  if $::osfamily != 'FreeBSD' {
    package { 'httpd':
      ensure => $package_ensure,
      name   => $apache_name,
      notify => Class['Apache::Service'],
    }
  }

  # declare the web server user and group
  # Note: requiring the package means the package ought to create them and not puppet
  if $manage_user {
    user { $user:
      ensure  => present,
      gid     => $group,
      groups  => $supplementary_groups,
      require => Package['httpd'],
    }
  }
  if $manage_group {
    group { $group:
      ensure  => present,
      require => Package['httpd'],
    }
  }

  class { 'apache::service':
    service_name    => $service_name,
    service_enable  => $service_enable,
    service_manage  => $service_manage,
    service_ensure  => $service_ensure,
    service_restart => $service_restart,
  }

  # Deprecated backwards-compatibility
  if $purge_vdir {
    warning('Class[\'apache\'] parameter purge_vdir is deprecated in favor of purge_configs')
    $purge_confd = $purge_vdir
  } else {
    $purge_confd = $purge_configs
  }

  # Set purge vhostd appropriately
  if $purge_vhost_dir == undef {
    $purge_vhostd = $purge_confd
  } else {
    $purge_vhostd = $purge_vhost_dir
  }

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  exec { "mkdir ${confd_dir}":
    creates => $confd_dir,
    require => Package['httpd'],
  }
  file { $confd_dir:
    ensure  => directory,
    recurse => true,
    purge   => $purge_confd,
    force   => $purge_confd,
    notify  => Class['Apache::Service'],
    require => Package['httpd'],
  }

  if $conf_enabled and ! defined(File[$conf_enabled]) {
    file { $conf_enabled:
      ensure  => directory,
      recurse => true,
      purge   => $purge_confd,
      force   => $purge_confd,
      notify  => Class['Apache::Service'],
      require => Package['httpd'],
    }
  }

  if ! defined(File[$mod_dir]) {
    exec { "mkdir ${mod_dir}":
      creates => $mod_dir,
      require => Package['httpd'],
    }
    # Don't purge available modules if an enable dir is used
    $purge_mod_dir = $purge_configs and !$mod_enable_dir
    file { $mod_dir:
      ensure  => directory,
      recurse => true,
      purge   => $purge_mod_dir,
      notify  => Class['Apache::Service'],
      require => Package['httpd'],
      before  => Anchor['::apache::modules_set_up'],
    }
  }

  if $mod_enable_dir and ! defined(File[$mod_enable_dir]) {
    $mod_load_dir = $mod_enable_dir
    exec { "mkdir ${mod_enable_dir}":
      creates => $mod_enable_dir,
      require => Package['httpd'],
    }
    file { $mod_enable_dir:
      ensure  => directory,
      recurse => true,
      purge   => $purge_configs,
      notify  => Class['Apache::Service'],
      require => Package['httpd'],
    }
  } else {
    $mod_load_dir = $mod_dir
  }

  if ! defined(File[$vhost_dir]) {
    exec { "mkdir ${vhost_dir}":
      creates => $vhost_dir,
      require => Package['httpd'],
    }
    file { $vhost_dir:
      ensure  => directory,
      recurse => true,
      purge   => $purge_vhostd,
      notify  => Class['Apache::Service'],
      require => Package['httpd'],
    }
  }

  if $vhost_enable_dir and ! defined(File[$vhost_enable_dir]) {
    $vhost_load_dir = $vhost_enable_dir
    exec { "mkdir ${vhost_load_dir}":
      creates => $vhost_load_dir,
      require => Package['httpd'],
    }
    file { $vhost_enable_dir:
      ensure  => directory,
      recurse => true,
      purge   => $purge_vhostd,
      notify  => Class['Apache::Service'],
      require => Package['httpd'],
    }
  } else {
    $vhost_load_dir = $vhost_dir
  }

  concat { $ports_file:
    ensure  => present,
    owner   => 'root',
    group   => $apache::params::root_group,
    mode    => $apache::file_mode,
    notify  => Class['Apache::Service'],
    require => Package['httpd'],
  }
  concat::fragment { 'Apache ports header':
    target  => $ports_file,
    content => template('apache/ports_header.erb'),
  }

  if $apache::conf_dir and $apache::params::conf_file {
    if $::osfamily == 'gentoo' {
      $error_documents_path = '/usr/share/apache2/error'
      if $default_mods =~ Array {
        if versioncmp($apache_version, '2.4') >= 0 {
          if defined('apache::mod::ssl') {
            ::portage::makeconf { 'apache2_modules':
              content => concat($default_mods, ['authz_core', 'socache_shmcb']),
            }
          } else {
            ::portage::makeconf { 'apache2_modules':
              content => concat($default_mods, 'authz_core'),
            }
          }
        } else {
          ::portage::makeconf { 'apache2_modules':
            content => $default_mods,
          }
        }
      }

      file { [
          '/etc/apache2/modules.d/.keep_www-servers_apache-2',
          '/etc/apache2/vhosts.d/.keep_www-servers_apache-2',
        ]:
          ensure  => absent,
          require => Package['httpd'],
      }
    }

    $apxs_workaround = $::osfamily ? {
      'freebsd' => true,
      default   => false
    }

    # Template uses:
    # - $pidfile
    # - $user
    # - $group
    # - $logroot
    # - $error_log
    # - $sendfile
    # - $mod_dir
    # - $ports_file
    # - $confd_dir
    # - $vhost_dir
    # - $error_documents
    # - $error_documents_path
    # - $apxs_workaround
    # - $http_protocol_options
    # - $keepalive
    # - $keepalive_timeout
    # - $max_keepalive_requests
    # - $server_root
    # - $server_tokens
    # - $server_signature
    # - $trace_enable
    # - $rewrite_lock
    # - $root_directory_secured
    file { "${apache::conf_dir}/${apache::params::conf_file}":
      ensure  => file,
      mode    => $apache::file_mode,
      content => template($conf_template),
      notify  => Class['Apache::Service'],
      require => [Package['httpd'], Concat[$ports_file]],
    }

    # preserve back-wards compatibility to the times when default_mods was
    # only a boolean value. Now it can be an array (too)
    if $default_mods =~ Array {
      class { 'apache::default_mods':
        all  => false,
        mods => $default_mods,
      }
    } else {
      class { 'apache::default_mods':
        all => $default_mods,
      }
    }
    class { 'apache::default_confd_files':
      all => $default_confd_files,
    }
    if $mpm_module and $mpm_module != 'false' { # lint:ignore:quoted_booleans
      include "::apache::mod::${mpm_module}"
    }

    $default_vhost_ensure = $default_vhost ? {
      true  => 'present',
      false => 'absent'
    }
    $default_ssl_vhost_ensure = $default_ssl_vhost ? {
      true  => 'present',
      false => 'absent'
    }

    ::apache::vhost { 'default':
      ensure                       => $default_vhost_ensure,
      port                         => '80',
      docroot                      => $docroot,
      scriptalias                  => $scriptalias,
      serveradmin                  => $serveradmin,
      access_log_file              => $access_log_file,
      priority                     => '15',
      ip                           => $ip,
      logroot_mode                 => $logroot_mode,
      manage_docroot               => $default_vhost,
      use_servername_for_filenames => true,
      use_port_for_filenames       => true,
    }
    $ssl_access_log_file = $::osfamily ? {
      'freebsd' => $access_log_file,
      default   => "ssl_${access_log_file}",
    }
    ::apache::vhost { 'default-ssl':
      ensure                       => $default_ssl_vhost_ensure,
      port                         => '443',
      ssl                          => true,
      docroot                      => $docroot,
      scriptalias                  => $scriptalias,
      serveradmin                  => $serveradmin,
      access_log_file              => $ssl_access_log_file,
      priority                     => '15',
      ip                           => $ip,
      logroot_mode                 => $logroot_mode,
      manage_docroot               => $default_ssl_vhost,
      use_servername_for_filenames => true,
      use_port_for_filenames       => true,
    }
  }

  # This anchor can be used as a reference point for things that need to happen *after*
  # all modules have been put in place.
  anchor { '::apache::modules_set_up': }
}
