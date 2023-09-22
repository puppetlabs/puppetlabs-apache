# @summary
#   Installs `mod_pasenger`.
#   > **Note**: This module support Passenger 4.0.0 and higher.
#
# @param manage_repo
#   Toggle whether to manage yum repo if on a RedHat node.
#
# @param mod_id
#   Specifies the package id.
#
# @param mod_lib
#   Defines the module's shared object name. Do not configure manually without special reason.
#
# @param mod_lib_path
#   Specifies a path to the module's libraries. Do not manually set this parameter without special reason. The `path` parameter overrides
#   this value.
#
# @param mod_package
#   Name of the module package to install.
#
# @param mod_package_ensure
#   Determines whether Puppet ensures the module should be installed.
#
# @param mod_path
#   Specifies a path to the module. Do not manually set this parameter without a special reason.
#
# @param passenger_allow_encoded_slashes
#   Toggle whether URLs with encoded slashes (%2f) can be used (by default Apache does not support this).
#
# @param passenger_anonymous_telemetry_proxy
#   Set an intermediate proxy for the Passenger anonymous telemetry reporting.
#
# @param passenger_app_env
#   This option sets, for the current application, the value of the following environment variables:
#   - RAILS_ENV
#   - RACK_ENV
#   - WSGI_ENV
#   - NODE_ENV
#   - PASSENGER_APP_ENV
#
# @param passenger_app_group_name
#   Sets the name of the application group that the current application should belong to.
#
# @param passenger_app_root
#   Path to the application root which allows access independent from the DocumentRoot.
#
# @param passenger_app_type
#   Specifies the type of the application. If you set this option, then you must also set PassengerAppRoot, otherwise Passenger will
#   not properly recognize your application.
#
# @param passenger_base_uri
#   Used to specify that the given URI is an distinct application that should be served by Passenger.
#
# @param passenger_buffer_response
#   Toggle whether application-generated responses are buffered by Apache. Buffering will happen in memory.
#
# @param passenger_buffer_upload
#   Toggle whether HTTP client request bodies are buffered before they are sent to the application. 
#
# @param passenger_concurrency_model
#   Specifies the I/O concurrency model that should be used for Ruby application processes.
#
# @param passenger_conf_file
#   
#
# @param passenger_conf_package_file
#   
#
# @param passenger_data_buffer_dir
#   Specifies the directory in which to store data buffers.
#
# @param passenger_debug_log_file
#   
#
# @param passenger_debugger
#   Turns support for Ruby application debugging on or off. 
#
# @param passenger_default_group
#   Allows you to specify the group that applications must run as, if user switching fails or is disabled.
#
# @param passenger_default_ruby
#   File path to desired ruby interpreter to use by default.
#
# @param passenger_default_user
#   Allows you to specify the user that applications must run as, if user switching fails or is disabled.
#
# @param passenger_disable_anonymous_telemetry
#   Whether or not to disable the Passenger anonymous telemetry reporting.
#
# @param passenger_disable_log_prefix
#   Whether to stop Passenger from prefixing logs when they are written to a log file.
#
# @param passenger_disable_security_update_check
#   Allows disabling the Passenger security update check, a daily check with https://securitycheck.phusionpassenger.com for important
#   security updates that might be available.
#
# @param passenger_enabled
#   Toggles whether Passenger should be enabled for that particular context.
#
# @param passenger_error_override
#   Toggles whether Apache will intercept and handle responses with HTTP status codes of 400 and higher. 
#
# @param passenger_file_descriptor_log_file
#   Log file descriptor debug tracing messages to the given file.
#
# @param passenger_fly_with
#   Enables the Flying Passenger mode, and configures Apache to connect to the Flying Passenger daemon that's listening on the 
#   given socket filename.
#
# @param passenger_force_max_concurrent_requests_per_process
#   Use this option to tell Passenger how many concurrent requests the application can handle per process. 
#
# @param passenger_friendly_error_pages
#   Toggles whether Passenger should display friendly error pages whenever an application fails to start.
#
# @param passenger_group
#   Allows you to override that behavior and explicitly set a group to run the web application as, regardless of the ownership of the 
#   startup file.
#
# @param passenger_high_performance
#   Toggles whether to enable PassengerHighPerformance which will make Passenger will be a little faster, in return for reduced
#   compatibility with other Apache modules.
#
# @param passenger_installed_version
#   
#
# @param passenger_instance_registry_dir
#   Specifies the directory that Passenger should use for registering its current instance.
#
# @param passenger_load_shell_envvars
#   Enables or disables the loading of shell environment variables before spawning the application.
#
# @param passenger_preload_bundler
#   Enables or disables loading bundler before loading your Ruby app.
#
# @param passenger_log_file
#   File path to log file. By default Passenger log messages are written to the Apache global error log.
#
# @param passenger_log_level
#   Specifies how much information Passenger should log to its log file. A higher log level value means that more 
#   information will be logged.
#
# @param passenger_lve_min_uid
#   When using Passenger on a LVE-enabled kernel, a security check (enter) is run for spawning application processes. This options
#   tells the check to only allow processes with UIDs equal to, or higher than, the specified value.
#
# @param passenger_max_instances
#   The maximum number of application processes that may simultaneously exist for an application. 
#
# @param passenger_max_instances_per_app
#   The maximum number of application processes that may simultaneously exist for a single application. 
#
# @param passenger_max_pool_size
#   The maximum number of application processes that may simultaneously exist.
#
# @param passenger_max_preloader_idle_time
#   Set the preloader's idle timeout, in seconds. A value of 0 means that it should never idle timeout.
#
# @param passenger_max_request_queue_size
#   Specifies the maximum size for the queue of all incoming requests.
#
# @param passenger_max_request_time
#   The maximum amount of time, in seconds, that an application process may take to process a request.
#
# @param passenger_max_requests
#   The maximum number of requests an application process will process. 
#
# @param passenger_memory_limit
#   The maximum amount of memory that an application process may use, in megabytes.
#
# @param passenger_meteor_app_settings
#   When using a Meteor application in non-bundled mode, use this option to specify a JSON file with settings for the application.
#
# @param passenger_min_instances
#   Specifies the minimum number of application processes that should exist for a given application. 
#
# @param passenger_nodejs
#   Specifies the Node.js command to use for serving Node.js web applications.
#
# @param passenger_pool_idle_time
#   The maximum number of seconds that an application process may be idle.
#
# @param passenger_pre_start
#   URL of the web application you want to pre-start.
#
# @param passenger_python
#   Specifies the Python interpreter to use for serving Python web applications.
#
# @param passenger_resist_deployment_errors
#   Enables or disables resistance against deployment errors.
#
# @param passenger_resolve_symlinks_in_document_root
#   This option is no longer available in version 5.2.0. Switch to PassengerAppRoot if you are setting the application root via a
#   document root containing symlinks.
#
# @param passenger_response_buffer_high_watermark
#   Configures the maximum size of the real-time disk-backed response buffering system.
#
# @param passenger_restart_dir
#   Path to directory containing restart.txt file. Can be either absolute or relative.
#
# @param passenger_rolling_restarts
#   Enables or disables support for zero-downtime application restarts through restart.txt.
#
# @param passenger_root
#   Refers to the location to the Passenger root directory, or to a location configuration file. 
#
# @param passenger_ruby
#   Specifies the Ruby interpreter to use for serving Ruby web applications. 
#
# @param passenger_security_update_check_proxy
#   Allows use of an intermediate proxy for the Passenger security update check.
#
# @param passenger_show_version_in_header
#   Toggle whether Passenger will output its version number in the X-Powered-By header in all Passenger-served requests:
#
# @param passenger_socket_backlog
#   This option can be raised if Apache manages to overflow the backlog queue.
#
# @param passenger_spawn_dir
#   The directory in which Passenger will record progress during startup
#
# @param passenger_spawn_method
#   Controls whether Passenger spawns applications directly, or using a prefork copy-on-write mechanism.
#
# @param passenger_start_timeout
#   Specifies a timeout for the startup of application processes.
#
# @param passenger_startup_file
#   Specifies the startup file that Passenger should use when loading the application. 
#
# @param passenger_stat_throttle_rate
#   Setting this option to a value of x means that certain filesystem checks will be performed at most once every x seconds.
#
# @param passenger_sticky_sessions
#   Toggles whether all requests that a client sends will be routed to the same originating application process, whenever possible. 
#
# @param passenger_sticky_sessions_cookie_name
#   Sets the name of the sticky sessions cookie.
#
# @param passenger_sticky_sessions_cookie_attributes
#   Sets the attributes of the sticky sessions cookie.
#
# @param passenger_thread_count
#   Specifies the number of threads that Passenger should spawn per Ruby application process.
#
# @param passenger_use_global_queue
#   N/A.
#
# @param passenger_user
#   Allows you to override that behavior and explicitly set a user to run the web application as, regardless of the ownership of the
#   startup file.
#
# @param passenger_user_switching
#   Toggles whether to attempt to enable user account sandboxing, also known as user switching.
#
# @param rack_env
#   Alias for PassengerAppEnv.
#
# @param rails_env
#   Alias for PassengerAppEnv.
#
# @param rails_framework_spawner_idle_time
#   This option is no longer available in version 4.0.0. There is no alternative because framework spawning has been removed 
#   altogether. You should use smart spawning instead.
#
# @note 
#   In Passenger source code you can strip out what are all the available options by looking in
#     - src/apache2_module/Configuration.cpp
#     - src/apache2_module/ConfigurationCommands.cpp
#   There are also several undocumented settings.
#
# @note
#   For Red Hat based systems, ensure that you meet the minimum requirements described in the passenger docs.
#
# The current set of server configurations settings were taken directly from the Passenger Reference. To enable deprecation warnings 
# and removal failure messages, set the passenger_installed_version to the version number installed on the server.
#
# Change Log:
#   - As of 08/13/2017 there are 84 available/deprecated/removed settings.
#   - Around 08/20/2017 UnionStation was discontinued options were removed.
#   - As of 08/20/2017 there are 77 available/deprecated/removed settings.
#
# @see https://www.phusionpassenger.com/docs/references/config_reference/apache/ for additional documentation.
#
class apache::mod::passenger (
  Boolean $manage_repo                                                                       = true,
  Optional[String] $mod_id                                                                   = undef,
  Optional[String] $mod_lib                                                                  = undef,
  Optional[String] $mod_lib_path                                                             = undef,
  Optional[String] $mod_package                                                              = undef,
  Optional[String] $mod_package_ensure                                                       = undef,
  Optional[String] $mod_path                                                                 = undef,
  Optional[Apache::OnOff] $passenger_allow_encoded_slashes                                   = undef,
  Optional[String] $passenger_anonymous_telemetry_proxy                                      = undef,
  Optional[String] $passenger_app_env                                                        = undef,
  Optional[String] $passenger_app_group_name                                                 = undef,
  Optional[String] $passenger_app_root                                                       = undef,
  Optional[String] $passenger_app_type                                                       = undef,
  Optional[String] $passenger_base_uri                                                       = undef,
  Optional[Apache::OnOff] $passenger_buffer_response                                         = undef,
  Optional[Apache::OnOff] $passenger_buffer_upload                                           = undef,
  Optional[String] $passenger_concurrency_model                                              = undef,
  String $passenger_conf_file                                                                = $apache::params::passenger_conf_file,
  Optional[String] $passenger_conf_package_file                                              = $apache::params::passenger_conf_package_file,
  Optional[Stdlib::Absolutepath] $passenger_data_buffer_dir                                  = undef,
  Optional[String] $passenger_debug_log_file                                                 = undef,
  Optional[Apache::OnOff] $passenger_debugger                                                = undef,
  Optional[String] $passenger_default_group                                                  = undef,
  Optional[String] $passenger_default_ruby                                                   = $apache::params::passenger_default_ruby,
  Optional[String] $passenger_default_user                                                   = undef,
  Optional[Boolean] $passenger_disable_anonymous_telemetry                                   = undef,
  Optional[Boolean] $passenger_disable_log_prefix                                            = undef,
  Optional[Apache::OnOff] $passenger_disable_security_update_check                           = undef,
  Optional[Apache::OnOff] $passenger_enabled                                                 = undef,
  Optional[Apache::OnOff] $passenger_error_override                                          = undef,
  Optional[String] $passenger_file_descriptor_log_file                                       = undef,
  Optional[String] $passenger_fly_with                                                       = undef,
  Optional[Variant[Integer, String]] $passenger_force_max_concurrent_requests_per_process    = undef,
  Optional[Apache::OnOff] $passenger_friendly_error_pages                                    = undef,
  Optional[String] $passenger_group                                                          = undef,
  Optional[Apache::OnOff] $passenger_high_performance                                        = undef,
  Optional[String] $passenger_installed_version                                              = undef,
  Optional[String] $passenger_instance_registry_dir                                          = undef,
  Optional[Apache::OnOff] $passenger_load_shell_envvars                                      = undef,
  Optional[Boolean] $passenger_preload_bundler                                               = undef,
  Optional[Stdlib::Absolutepath] $passenger_log_file                                         = undef,
  Optional[Integer] $passenger_log_level                                                     = undef,
  Optional[Integer] $passenger_lve_min_uid                                                   = undef,
  Optional[Integer] $passenger_max_instances                                                 = undef,
  Optional[Integer] $passenger_max_instances_per_app                                         = undef,
  Optional[Integer] $passenger_max_pool_size                                                 = undef,
  Optional[Integer] $passenger_max_preloader_idle_time                                       = undef,
  Optional[Integer] $passenger_max_request_queue_size                                        = undef,
  Optional[Integer] $passenger_max_request_time                                              = undef,
  Optional[Integer] $passenger_max_requests                                                  = undef,
  Optional[Integer] $passenger_memory_limit                                                  = undef,
  Optional[String] $passenger_meteor_app_settings                                            = undef,
  Optional[Integer] $passenger_min_instances                                                 = undef,
  Optional[String] $passenger_nodejs                                                         = undef,
  Optional[Integer] $passenger_pool_idle_time                                                = undef,
  Optional[Variant[String, Array[String]]] $passenger_pre_start                              = undef,
  Optional[String] $passenger_python                                                         = undef,
  Optional[Apache::OnOff] $passenger_resist_deployment_errors                                = undef,
  Optional[Apache::OnOff] $passenger_resolve_symlinks_in_document_root                       = undef,
  Optional[Variant[Integer, String]] $passenger_response_buffer_high_watermark               = undef,
  Optional[String] $passenger_restart_dir                                                    = undef,
  Optional[Apache::OnOff] $passenger_rolling_restarts                                        = undef,
  Optional[String] $passenger_root                                                           = $apache::params::passenger_root,
  Optional[String] $passenger_ruby                                                           = $apache::params::passenger_ruby,
  Optional[String] $passenger_security_update_check_proxy                                    = undef,
  Optional[Apache::OnOff] $passenger_show_version_in_header                                  = undef,
  Optional[Variant[Integer, String]] $passenger_socket_backlog                               = undef,
  Optional[String] $passenger_spawn_dir                                                      = undef,
  Optional[Enum['smart', 'direct', 'smart-lv2', 'conservative']] $passenger_spawn_method     = undef,
  Optional[Integer] $passenger_start_timeout                                                 = undef,
  Optional[String] $passenger_startup_file                                                   = undef,
  Optional[Integer] $passenger_stat_throttle_rate                                            = undef,
  Optional[Apache::OnOff] $passenger_sticky_sessions                                         = undef,
  Optional[String] $passenger_sticky_sessions_cookie_name                                    = undef,
  Optional[String] $passenger_sticky_sessions_cookie_attributes                              = undef,
  Optional[Integer] $passenger_thread_count                                                  = undef,
  Optional[String] $passenger_use_global_queue                                               = undef,
  Optional[String] $passenger_user                                                           = undef,
  Optional[Apache::OnOff] $passenger_user_switching                                          = undef,
  Optional[String] $rack_env                                                                 = undef,
  Optional[String] $rails_env                                                                = undef,
  Optional[String] $rails_framework_spawner_idle_time                                        = undef,
) inherits apache::params {
  include apache
  if $passenger_installed_version {
    if $passenger_anonymous_telemetry_proxy {
      if (versioncmp($passenger_installed_version, '6.0.0') < 0) {
        fail("Passenger config option :: passenger_anonymous_telemetry_proxy is not introduced until version 6.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_app_type {
      if (versioncmp($passenger_installed_version, '4.0.25') < 0) {
        fail("Passenger config option :: passenger_app_type is not introduced until version 4.0.25 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_buffer_upload {
      if (versioncmp($passenger_installed_version, '4.0.26') < 0) {
        fail("Passenger config option :: passenger_buffer_upload is not introduced until version 4.0.26 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_data_buffer_dir {
      if (versioncmp($passenger_installed_version, '5.0.0') < 0) {
        fail("Passenger config option :: passenger_data_buffer_dir is not introduced until version 5.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_debug_log_file {
      if (versioncmp($passenger_installed_version, '5.0.5') > 0) {
        warning('DEPRECATED PASSENGER OPTION :: passenger_debug_log_file :: This option has been renamed in version 5.0.5 to PassengerLogFile.')
      }
    }
    if $passenger_disable_anonymous_telemetry {
      if (versioncmp($passenger_installed_version, '6.0.0') < 0) {
        fail("Passenger config option :: passenger_disable_anonymous_telemetry is not introduced until version 6.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_disable_log_prefix {
      if (versioncmp($passenger_installed_version, '6.0.2') < 0) {
        fail("Passenger config option :: passenger_disable_log_prefix is not introduced until version 6.0.2 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_disable_security_update_check {
      if (versioncmp($passenger_installed_version, '5.1.0') < 0) {
        fail("Passenger config option :: passenger_disable_security_update_check is not introduced until version 5.1.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_error_override {
      if (versioncmp($passenger_installed_version, '4.0.24') < 0) {
        fail("Passenger config option :: passenger_error_override is not introduced until version 4.0.24 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_file_descriptor_log_file {
      if (versioncmp($passenger_installed_version, '5.0.5') < 0) {
        fail("Passenger config option :: passenger_file_descriptor_log_file is not introduced until version 5.0.5 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_fly_with {
      if (versioncmp($passenger_installed_version, '4.0.45') < 0) {
        fail("Passenger config option :: passenger_fly_with is not introduced until version 4.0.45 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_force_max_concurrent_requests_per_process {
      if (versioncmp($passenger_installed_version, '5.0.22') < 0) {
        fail("Passenger config option :: passenger_force_max_concurrent_requests_per_process is not introduced until version 5.0.22 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_friendly_error_pages {
      if (versioncmp($passenger_installed_version, '4.0.42') < 0) {
        fail("Passenger config option :: passenger_friendly_error_pages is not introduced until version 4.0.42 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_instance_registry_dir {
      if (versioncmp($passenger_installed_version, '5.0.0') < 0) {
        fail("Passenger config option :: passenger_instance_registry_dir is not introduced until version 5.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_load_shell_envvars {
      if (versioncmp($passenger_installed_version, '4.0.20') < 0) {
        fail("Passenger config option :: passenger_load_shell_envvars is not introduced until version 4.0.20 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_preload_bundler {
      if (versioncmp($passenger_installed_version, '6.0.13') < 0) {
        fail("Passenger config option :: passenger_preload_bundler is not introduced until version 6.0.13 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_log_file {
      if (versioncmp($passenger_installed_version, '5.0.5') < 0) {
        fail("Passenger config option :: passenger_log_file is not introduced until version 5.0.5 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_lve_min_uid {
      if (versioncmp($passenger_installed_version, '5.0.28') < 0) {
        fail("Passenger config option :: passenger_lve_min_uid is not introduced until version 5.0.28 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_max_request_queue_size {
      if (versioncmp($passenger_installed_version, '4.0.15') < 0) {
        fail("Passenger config option :: passenger_max_request_queue_size is not introduced until version 4.0.15 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_meteor_app_settings {
      if (versioncmp($passenger_installed_version, '5.0.7') < 0) {
        fail("Passenger config option :: passenger_meteor_app_settings is not introduced until version 5.0.7 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_nodejs {
      if (versioncmp($passenger_installed_version, '4.0.24') < 0) {
        fail("Passenger config option :: passenger_nodejs is not introduced until version 4.0.24 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_response_buffer_high_watermark {
      if (versioncmp($passenger_installed_version, '5.0.0') < 0) {
        fail("Passenger config option :: passenger_response_buffer_high_watermark is not introduced until version 5.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_security_update_check_proxy {
      if (versioncmp($passenger_installed_version, '5.1.0') < 0) {
        fail("Passenger config option :: passenger_security_update_check_proxy is not introduced until version 5.1.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_show_version_in_header {
      if (versioncmp($passenger_installed_version, '5.1.0') < 0) {
        fail("Passenger config option :: passenger_show_version_in_header is not introduced until version 5.1.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_socket_backlog {
      if (versioncmp($passenger_installed_version, '5.0.24') < 0) {
        fail("Passenger config option :: passenger_socket_backlog is not introduced until version 5.0.24 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_spawn_dir {
      if (versioncmp($passenger_installed_version, '6.0.3') < 0) {
        fail("Passenger config option :: passenger_spawn_dir is not introduced until version 6.0.3 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_start_timeout {
      if (versioncmp($passenger_installed_version, '4.0.15') < 0) {
        fail("Passenger config option :: passenger_start_timeout is not introduced until version 4.0.15 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_startup_file {
      if (versioncmp($passenger_installed_version, '4.0.25') < 0) {
        fail("Passenger config option :: passenger_startup_file is not introduced until version 4.0.25 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_sticky_sessions {
      if (versioncmp($passenger_installed_version, '4.0.45') < 0) {
        fail("Passenger config option :: passenger_sticky_sessions is not introduced until version 4.0.45 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_sticky_sessions_cookie_name {
      if (versioncmp($passenger_installed_version, '4.0.45') < 0) {
        fail("Passenger config option :: passenger_sticky_sessions_cookie_name is not introduced until version 4.0.45 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_sticky_sessions_cookie_attributes {
      if (versioncmp($passenger_installed_version, '6.0.5') < 0) {
        fail("Passenger config option :: passenger_sticky_sessions_cookie_attributes is not introduced until version 6.0.5 :: ${passenger_installed_version} is the version reported")
      }
    }
  }
  # Managed by the package, but declare it to avoid purging
  if $passenger_conf_package_file {
    file { 'passenger_package.conf':
      path => "${apache::confd_dir}/${passenger_conf_package_file}",
    }
  }

  $_package = $mod_package
  $_package_ensure = $mod_package_ensure
  $_lib = $mod_lib
  if $facts['os']['family'] == 'FreeBSD' {
    if $mod_lib_path {
      $_lib_path = $mod_lib_path
    } else {
      $_lib_path = "${passenger_root}/buildout/apache2"
    }
  } else {
    $_lib_path = $mod_lib_path
  }

  if $facts['os']['family'] == 'RedHat' and $manage_repo {
    if $facts['os']['name'] == 'Amazon' {
      if $facts['os']['release']['major'] == '2' {
        $baseurl = 'https://oss-binaries.phusionpassenger.com/yum/passenger/el/7/$basearch'
      } else {
        $baseurl = 'https://oss-binaries.phusionpassenger.com/yum/passenger/el/6/$basearch'
      }
    } else {
      $baseurl = 'https://oss-binaries.phusionpassenger.com/yum/passenger/el/$releasever/$basearch'
    }

    yumrepo { 'passenger':
      ensure        => 'present',
      baseurl       => $baseurl,
      descr         => 'passenger',
      enabled       => '1',
      gpgcheck      => '0',
      gpgkey        => 'https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key.txt',
      repo_gpgcheck => '1',
      sslcacert     => '/etc/pki/tls/certs/ca-bundle.crt',
      sslverify     => '1',
      before        => Apache::Mod['passenger'],
    }
  }

  unless ($facts['os']['name'] == 'SLES') {
    $_id = $mod_id
    $_path = $mod_path
    ::apache::mod { 'passenger':
      package        => $_package,
      package_ensure => $_package_ensure,
      lib            => $_lib,
      lib_path       => $_lib_path,
      id             => $_id,
      path           => $_path,
      loadfile_name  => 'zpassenger.load',
    }
  }

  # Template uses:
  # - $passenger_allow_encoded_slashes : since 4.0.0.
  # - $passenger_app_env : since 4.0.0.
  # - $passenger_app_group_name : since 4.0.0.
  # - $passenger_app_root : since 4.0.0.
  # - $passenger_app_type : since 4.0.25.
  # - $passenger_base_uri : since 4.0.0.
  # - $passenger_buffer_response : since 4.0.0.
  # - $passenger_buffer_upload : since 4.0.26.
  # - $passenger_concurrency_model : since 4.0.0.
  # - $passenger_data_buffer_dir : since 5.0.0.
  # - $passenger_debug_log_file : since unkown. Deprecated in 5.0.5.
  # - $passenger_debugger : since 3.0.0.
  # - $passenger_default_group : since 3.0.0.
  # - $passenger_default_ruby : since 4.0.0.
  # - $passenger_default_user : since 3.0.0.
  # - $passenger_disable_security_update_check : since 5.1.0.
  # - $passenger_enabled : since 4.0.0.
  # - $passenger_error_override : since 4.0.24.
  # - $passenger_file_descriptor_log_file : since 5.0.5.
  # - $passenger_fly_with : since 4.0.45.
  # - $passenger_force_max_concurrent_requests_per_process : since 5.0.22.
  # - $passenger_friendly_error_pages : since 4.0.42.
  # - $passenger_group : since 4.0.0.
  # - $passenger_high_performance : since 2.0.0.
  # - $passenger_instance_registry_dir : since 5.0.0.
  # - $passenger_load_shell_envvars : since 4.0.20.
  # - $passenger_preload_bundler : since 6.0.13
  # - $passenger_log_file : since 5.0.5.
  # - $passenger_log_level : since 3.0.0.
  # - $passenger_lve_min_uid : since 5.0.28.
  # - $passenger_max_instances : since 3.0.0.
  # - $passenger_max_instances_per_app : since 3.0.0.
  # - $passenger_max_pool_size : since 1.0.0.
  # - $passenger_max_preloader_idle_time : since 4.0.0.
  # - $passenger_max_request_queue_size : since 4.0.15.
  # - $passenger_max_request_time : since 3.0.0.
  # - $passenger_max_requests : since 3.0.0.
  # - $passenger_memory_limit : since 3.0.0.
  # - $passenger_meteor_app_settings : since 5.0.7.
  # - $passenger_min_instances : since 3.0.0.
  # - $passenger_nodejs : since 4.0.24.
  # - $passenger_pool_idle_time : since 1.0.0.
  # - $passenger_pre_start : since 3.0.0.
  # - $passenger_python : since 4.0.0.
  # - $passenger_resist_deployment_errors : since 3.0.0.
  # - $passenger_resolve_symlinks_in_document_root : since 3.0.0.
  # - $passenger_response_buffer_high_watermark : since 5.0.0.
  # - $passenger_restart_dir : since 3.0.0.
  # - $passenger_rolling_restarts : since 3.0.0.
  # - $passenger_root : since 1.0.0.
  # - $passenger_ruby : since 4.0.0.
  # - $passenger_security_update_check_proxy : since 5.1.0.
  # - $passenger_show_version_in_header : since 5.1.0.
  # - $passenger_socket_backlog : since 5.0.24.
  # - $passenger_spawn_method : since 2.0.0.
  # - $passenger_start_timeout : since 4.0.15.
  # - $passenger_startup_file : since 4.0.25.
  # - $passenger_stat_throttle_rate : since 2.2.0.
  # - $passenger_sticky_sessions : since 4.0.45.
  # - $passenger_sticky_sessions_cookie_name : since 4.0.45.
  # - $passenger_thread_count : since 4.0.0.
  # - $passenger_use_global_queue : since 2.0.4.Deprecated in 4.0.0.
  # - $passenger_user : since 4.0.0.
  # - $passenger_user_switching : since 3.0.0.

  $parameters = {
    'passenger_allow_encoded_slashes'                     => $passenger_allow_encoded_slashes,
    'passenger_anonymous_telemetry_proxy'                 => $passenger_anonymous_telemetry_proxy,
    'passenger_app_env'                                   => $passenger_app_env,
    'passenger_app_group_name'                            => $passenger_app_group_name,
    'passenger_app_root'                                  => $passenger_app_root,
    'passenger_app_type'                                  => $passenger_app_type,
    'passenger_base_uri'                                  => $passenger_base_uri,
    'passenger_buffer_response'                           => $passenger_buffer_response,
    'passenger_buffer_upload'                             => $passenger_buffer_upload,
    'passenger_concurrency_model'                         => $passenger_concurrency_model,
    'passenger_data_buffer_dir'                           => $passenger_data_buffer_dir,
    'passenger_debug_log_file'                            => $passenger_debug_log_file,
    'passenger_debugger'                                  => $passenger_debugger,
    'passenger_default_group'                             => $passenger_default_group,
    'passenger_default_ruby'                              => $passenger_default_ruby,
    'passenger_default_user'                              => $passenger_default_user,
    'passenger_disable_anonymous_telemetry'               => $passenger_disable_anonymous_telemetry,
    'passenger_disable_log_prefix'                        => $passenger_disable_log_prefix,
    'passenger_disable_security_update_check'             => $passenger_disable_security_update_check,
    'passenger_enabled'                                   => $passenger_enabled,
    'passenger_error_override'                            => $passenger_error_override,
    'passenger_file_descriptor_log_file'                  => $passenger_file_descriptor_log_file,
    'passenger_fly_with'                                  => $passenger_fly_with,
    'passenger_force_max_concurrent_requests_per_process' => $passenger_force_max_concurrent_requests_per_process,
    'passenger_friendly_error_pages'                      => $passenger_friendly_error_pages,
    'passenger_group'                                     => $passenger_group,
    'passenger_high_performance'                          => $passenger_high_performance,
    'passenger_instance_registry_dir'                     => $passenger_instance_registry_dir,
    'passenger_load_shell_envvars'                        => $passenger_load_shell_envvars,
    'passenger_preload_bundler'                           => $passenger_preload_bundler,
    'passenger_log_file'                                  => $passenger_log_file,
    'passenger_log_level'                                 => $passenger_log_level,
    'passenger_lve_min_uid'                               => $passenger_lve_min_uid,
    'passenger_max_instances'                             => $passenger_max_instances,
    'passenger_max_instances_per_app'                     => $passenger_max_instances_per_app,
    'passenger_max_pool_size'                             => $passenger_max_pool_size,
    'passenger_max_preloader_idle_time'                   => $passenger_max_preloader_idle_time,
    'passenger_max_request_queue_size'                    => $passenger_max_request_queue_size,
    'passenger_max_request_time'                          => $passenger_max_request_time,
    'passenger_max_requests'                              => $passenger_max_requests,
    'passenger_memory_limit'                              => $passenger_memory_limit,
    'passenger_meteor_app_settings'                       => $passenger_meteor_app_settings,
    'passenger_min_instances'                             => $passenger_min_instances,
    'passenger_nodejs'                                    => $passenger_nodejs,
    'passenger_pool_idle_time'                            => $passenger_pool_idle_time,
    'passenger_pre_start'                                 => $passenger_pre_start,
    'passenger_python'                                    => $passenger_python,
    'passenger_resist_deployment_errors'                  => $passenger_resist_deployment_errors,
    'passenger_resolve_symlinks_in_document_root'         => $passenger_resolve_symlinks_in_document_root,
    'passenger_response_buffer_high_watermark'            => $passenger_response_buffer_high_watermark,
    'passenger_restart_dir'                               => $passenger_restart_dir,
    'passenger_rolling_restarts'                          => $passenger_rolling_restarts,
    'passenger_root'                                      => $passenger_root,
    'passenger_ruby'                                      => $passenger_ruby,
    'passenger_security_update_check_proxy'               => $passenger_security_update_check_proxy,
    'passenger_show_version_in_header'                    => $passenger_show_version_in_header,
    'passenger_socket_backlog'                            => $passenger_socket_backlog,
    'passenger_spawn_dir'                                 => $passenger_spawn_dir,
    'passenger_spawn_method'                              => $passenger_spawn_method,
    'passenger_start_timeout'                             => $passenger_start_timeout,
    'passenger_startup_file'                              => $passenger_startup_file,
    'passenger_stat_throttle_rate'                        => $passenger_stat_throttle_rate,
    'passenger_sticky_sessions'                           => $passenger_sticky_sessions,
    'passenger_sticky_sessions_cookie_name'               => $passenger_sticky_sessions_cookie_name,
    'passenger_sticky_sessions_cookie_attributes'         => $passenger_sticky_sessions_cookie_attributes,
    'passenger_thread_count'                              => $passenger_thread_count,
    'passenger_use_global_queue'                          => $passenger_use_global_queue,
    'passenger_user'                                      => $passenger_user,
    'passenger_user_switching'                            => $passenger_user_switching,
    'rack_env'                                            => $rack_env,
    'rails_env'                                           => $rails_env,
    'rails_framework_spawner_idle_time'                   => $rails_framework_spawner_idle_time,
  }

  file { 'passenger.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/${passenger_conf_file}",
    content => epp('apache/mod/passenger.conf.epp', $parameters),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
