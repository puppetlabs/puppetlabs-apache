# @summary
#   Installs `mod_pasenger`.
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
# @param rack_auto_detect
#   This option has been removed in version 4.0.0 as part of an optimization. You should use PassengerEnabled instead.
#
# @param rack_autodetect
#   This option has been removed in version 4.0.0 as part of an optimization. You should use PassengerEnabled instead.
#
# @param rack_base_uri
#   Deprecated in 3.0.0 in favor of PassengerBaseURI.
#
# @param rack_env
#   Alias for PassengerAppEnv.
#
# @param rails_allow_mod_rewrite
#   This option doesn't do anything anymore since version 4.0.0.
#
# @param rails_app_spawner_idle_time
#   This option has been removed in version 4.0.0, and replaced with PassengerMaxPreloaderIdleTime.
#
# @param rails_auto_detect
#   This option has been removed in version 4.0.0 as part of an optimization. You should use PassengerEnabled instead.
#
# @param rails_autodetect
#   This option has been removed in version 4.0.0 as part of an optimization. You should use PassengerEnabled instead.
#
# @param rails_base_uri
#   Deprecated in 3.0.0 in favor of PassengerBaseURI.
#
# @param rails_default_user
#   Deprecated in 3.0.0 in favor of PassengerDefaultUser
#
# @param rails_env
#   Alias for PassengerAppEnv.
#
# @param rails_framework_spawner_idle_time
#   This option is no longer available in version 4.0.0. There is no alternative because framework spawning has been removed 
#   altogether. You should use smart spawning instead.
#
# @param rails_ruby
#   Deprecated in 3.0.0 in favor of PassengerRuby.
#
# @param rails_spawn_method
#   Deprecated in 3.0.0 in favor of PassengerSpawnMethod.
#
# @param rails_user_switching
#   Deprecated in 3.0.0 in favor of PassengerUserSwitching.
#
# @param wsgi_auto_detect
#   This option has been removed in version 4.0.0 as part of an optimization. You should use PassengerEnabled instead.
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
# @see https://www.phusionpassenger.com/library/config/apache/reference/ for additional documentation.
#
class apache::mod::passenger (
  $manage_repo                                                                               = true,
  $mod_id                                                                                    = undef,
  $mod_lib                                                                                   = undef,
  $mod_lib_path                                                                              = undef,
  $mod_package                                                                               = undef,
  $mod_package_ensure                                                                        = undef,
  $mod_path                                                                                  = undef,
  $passenger_allow_encoded_slashes                                                           = undef,
  $passenger_app_env                                                                         = undef,
  $passenger_app_group_name                                                                  = undef,
  $passenger_app_root                                                                        = undef,
  $passenger_app_type                                                                        = undef,
  $passenger_base_uri                                                                        = undef,
  $passenger_buffer_response                                                                 = undef,
  $passenger_buffer_upload                                                                   = undef,
  $passenger_concurrency_model                                                               = undef,
  $passenger_conf_file                                                                       = $::apache::params::passenger_conf_file,
  $passenger_conf_package_file                                                               = $::apache::params::passenger_conf_package_file,
  $passenger_data_buffer_dir                                                                 = undef,
  $passenger_debug_log_file                                                                  = undef,
  $passenger_debugger                                                                        = undef,
  $passenger_default_group                                                                   = undef,
  $passenger_default_ruby                                                                    = $::apache::params::passenger_default_ruby,
  $passenger_default_user                                                                    = undef,
  $passenger_disable_security_update_check                                                   = undef,
  $passenger_enabled                                                                         = undef,
  $passenger_error_override                                                                  = undef,
  $passenger_file_descriptor_log_file                                                        = undef,
  $passenger_fly_with                                                                        = undef,
  $passenger_force_max_concurrent_requests_per_process                                       = undef,
  $passenger_friendly_error_pages                                                            = undef,
  $passenger_group                                                                           = undef,
  $passenger_high_performance                                                                = undef,
  $passenger_installed_version                                                               = undef,
  $passenger_instance_registry_dir                                                           = undef,
  $passenger_load_shell_envvars                                                              = undef,
  Optional[Stdlib::Absolutepath] $passenger_log_file                                         = undef,
  $passenger_log_level                                                                       = undef,
  $passenger_lve_min_uid                                                                     = undef,
  $passenger_max_instances                                                                   = undef,
  $passenger_max_instances_per_app                                                           = undef,
  $passenger_max_pool_size                                                                   = undef,
  $passenger_max_preloader_idle_time                                                         = undef,
  $passenger_max_request_queue_size                                                          = undef,
  $passenger_max_request_time                                                                = undef,
  $passenger_max_requests                                                                    = undef,
  $passenger_memory_limit                                                                    = undef,
  $passenger_meteor_app_settings                                                             = undef,
  $passenger_min_instances                                                                   = undef,
  $passenger_nodejs                                                                          = undef,
  $passenger_pool_idle_time                                                                  = undef,
  Optional[Variant[String,Array[String]]] $passenger_pre_start                               = undef,
  $passenger_python                                                                          = undef,
  $passenger_resist_deployment_errors                                                        = undef,
  $passenger_resolve_symlinks_in_document_root                                               = undef,
  $passenger_response_buffer_high_watermark                                                  = undef,
  $passenger_restart_dir                                                                     = undef,
  $passenger_rolling_restarts                                                                = undef,
  $passenger_root                                                                            = $::apache::params::passenger_root,
  $passenger_ruby                                                                            = $::apache::params::passenger_ruby,
  $passenger_security_update_check_proxy                                                     = undef,
  $passenger_show_version_in_header                                                          = undef,
  $passenger_socket_backlog                                                                  = undef,
  Optional[Enum['smart', 'direct', 'smart-lv2', 'conservative']] $passenger_spawn_method     = undef,
  $passenger_start_timeout                                                                   = undef,
  $passenger_startup_file                                                                    = undef,
  $passenger_stat_throttle_rate                                                              = undef,
  $passenger_sticky_sessions                                                                 = undef,
  $passenger_sticky_sessions_cookie_name                                                     = undef,
  $passenger_thread_count                                                                    = undef,
  $passenger_use_global_queue                                                                = undef,
  $passenger_user                                                                            = undef,
  $passenger_user_switching                                                                  = undef,
  $rack_auto_detect                                                                          = undef,
  $rack_autodetect                                                                           = undef,
  $rack_base_uri                                                                             = undef,
  $rack_env                                                                                  = undef,
  $rails_allow_mod_rewrite                                                                   = undef,
  $rails_app_spawner_idle_time                                                               = undef,
  $rails_auto_detect                                                                         = undef,
  $rails_autodetect                                                                          = undef,
  $rails_base_uri                                                                            = undef,
  $rails_default_user                                                                        = undef,
  $rails_env                                                                                 = undef,
  $rails_framework_spawner_idle_time                                                         = undef,
  $rails_ruby                                                                                = undef,
  $rails_spawn_method                                                                        = undef,
  $rails_user_switching                                                                      = undef,
  $wsgi_auto_detect                                                                          = undef,
) inherits ::apache::params {
  include ::apache
  if $passenger_installed_version {
    if $passenger_allow_encoded_slashes {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_allow_encoded_slashes is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_app_env {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_app_env is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_app_group_name {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_app_group_name is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_app_root {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_app_root is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_app_type {
      if (versioncmp($passenger_installed_version, '4.0.25') < 0) {
        fail("Passenger config option :: passenger_app_type is not introduced until version 4.0.25 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_base_uri {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_base_uri is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_buffer_response {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_buffer_response is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_buffer_upload {
      if (versioncmp($passenger_installed_version, '4.0.26') < 0) {
        fail("Passenger config option :: passenger_buffer_upload is not introduced until version 4.0.26 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_concurrency_model {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_concurrency_model is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
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
    if $passenger_debugger {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_debugger is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_default_group {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_default_group is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_default_ruby {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_default_ruby is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_default_user {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_default_user is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_disable_security_update_check {
      if (versioncmp($passenger_installed_version, '5.1.0') < 0) {
        fail("Passenger config option :: passenger_disable_security_update_check is not introduced until version 5.1.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_enabled {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_enabled is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
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
    if $passenger_group {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_group is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_high_performance {
      if (versioncmp($passenger_installed_version, '2.0.0') < 0) {
        fail("Passenger config option :: passenger_high_performance is not introduced until version 2.0.0 :: ${passenger_installed_version} is the version reported")
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
    if $passenger_log_file {
      if (versioncmp($passenger_installed_version, '5.0.5') < 0) {
        fail("Passenger config option :: passenger_log_file is not introduced until version 5.0.5 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_log_level {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_log_level is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_lve_min_uid {
      if (versioncmp($passenger_installed_version, '5.0.28') < 0) {
        fail("Passenger config option :: passenger_lve_min_uid is not introduced until version 5.0.28 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_max_instances {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_max_instances is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_max_instances_per_app {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_max_instances_per_app is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_max_pool_size {
      if (versioncmp($passenger_installed_version, '1.0.0') < 0) {
        fail("Passenger config option :: passenger_max_pool_size is not introduced until version 1.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_max_preloader_idle_time {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_max_preloader_idle_time is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_max_request_queue_size {
      if (versioncmp($passenger_installed_version, '4.0.15') < 0) {
        fail("Passenger config option :: passenger_max_request_queue_size is not introduced until version 4.0.15 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_max_request_time {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_max_request_time is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_max_requests {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_max_requests is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_memory_limit {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_memory_limit is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_meteor_app_settings {
      if (versioncmp($passenger_installed_version, '5.0.7') < 0) {
        fail("Passenger config option :: passenger_meteor_app_settings is not introduced until version 5.0.7 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_min_instances {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_min_instances is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_nodejs {
      if (versioncmp($passenger_installed_version, '4.0.24') < 0) {
        fail("Passenger config option :: passenger_nodejs is not introduced until version 4.0.24 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_pool_idle_time {
      if (versioncmp($passenger_installed_version, '1.0.0') < 0) {
        fail("Passenger config option :: passenger_pool_idle_time is not introduced until version 1.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_pre_start {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_pre_start is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_python {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_python is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_resist_deployment_errors {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_resist_deployment_errors is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_resolve_symlinks_in_document_root {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_resolve_symlinks_in_document_root is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_response_buffer_high_watermark {
      if (versioncmp($passenger_installed_version, '5.0.0') < 0) {
        fail("Passenger config option :: passenger_response_buffer_high_watermark is not introduced until version 5.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_restart_dir {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_restart_dir is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_rolling_restarts {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_rolling_restarts is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_root {
      if (versioncmp($passenger_installed_version, '1.0.0') < 0) {
        fail("Passenger config option :: passenger_root is not introduced until version 1.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_ruby {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_ruby is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
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
    if $passenger_spawn_method {
      if (versioncmp($passenger_installed_version, '2.0.0') < 0) {
        fail("Passenger config option :: passenger_spawn_method is not introduced until version 2.0.0 :: ${passenger_installed_version} is the version reported")
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
    if $passenger_stat_throttle_rate {
      if (versioncmp($passenger_installed_version, '2.2.0') < 0) {
        fail("Passenger config option :: passenger_stat_throttle_rate is not introduced until version 2.2.0 :: ${passenger_installed_version} is the version reported")
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
    if $passenger_thread_count {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_thread_count is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_use_global_queue {
      if (versioncmp($passenger_installed_version, '4.0.0') > 0) {
        fail('REMOVED PASSENGER OPTION :: passenger_use_global_queue :: -- no message on the current passenger reference webpage -- ')
      }
      if (versioncmp($passenger_installed_version, '2.0.4') < 0) {
        fail("Passenger config option :: passenger_use_global_queue is not introduced until version 2.0.4 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_user {
      if (versioncmp($passenger_installed_version, '4.0.0') < 0) {
        fail("Passenger config option :: passenger_user is not introduced until version 4.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $passenger_user_switching {
      if (versioncmp($passenger_installed_version, '3.0.0') < 0) {
        fail("Passenger config option :: passenger_user_switching is not introduced until version 3.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if ($rack_auto_detect or $rack_autodetect) {
      if (versioncmp($passenger_installed_version, '4.0.0') > 0) {
        fail('REMOVED PASSENGER OPTION :: rack_auto_detect ::  These options have been removed in version 4.0.0 as part of an optimization. You should use PassengerEnabled instead.')
      }
    }
    if $rack_base_uri {
      if (versioncmp($passenger_installed_version, '3.0.0') > 0) {
        warning('DEPRECATED PASSENGER OPTION :: rack_base_uri :: Deprecated in 3.0.0 in favor of PassengerBaseURI.')
      }
    }
    if $rack_env {
      if (versioncmp($passenger_installed_version, '2.0.0') < 0) {
        fail("Passenger config option :: rack_env is not introduced until version 2.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $rails_allow_mod_rewrite {
      if (versioncmp($passenger_installed_version, '4.0.0') > 0) {
        warning("DEPRECATED PASSENGER OPTION :: rails_allow_mod_rewrite :: This option doesn't do anything anymore in since version 4.0.0.")
      }
    }
    if $rails_app_spawner_idle_time {
      if (versioncmp($passenger_installed_version, '4.0.0') > 0) {
        fail('REMOVED PASSENGER OPTION :: rails_app_spawner_idle_time ::  This option has been removed in version 4.0.0, and replaced with PassengerMaxPreloaderIdleTime.')
      }
    }
    if ($rails_auto_detect or $rails_autodetect) {
      if (versioncmp($passenger_installed_version, '4.0.0') > 0) {
        fail('REMOVED PASSENGER OPTION :: rails_auto_detect ::  These options have been removed in version 4.0.0 as part of an optimization. You should use PassengerEnabled instead.')
      }
    }
    if $rails_base_uri {
      if (versioncmp($passenger_installed_version, '3.0.0') > 0) {
        warning('DEPRECATED PASSENGER OPTION :: rails_base_uri :: Deprecated in 3.0.0 in favor of PassengerBaseURI.')
      }
    }
    if $rails_default_user {
      if (versioncmp($passenger_installed_version, '3.0.0') > 0) {
        warning('DEPRECATED PASSENGER OPTION :: rails_default_user :: Deprecated in 3.0.0 in favor of PassengerDefaultUser.')
      }
    }
    if $rails_env {
      if (versioncmp($passenger_installed_version, '2.0.0') < 0) {
        fail("Passenger config option :: rails_env is not introduced until version 2.0.0 :: ${passenger_installed_version} is the version reported")
      }
    }
    if $rails_framework_spawner_idle_time {
      if (versioncmp($passenger_installed_version, '4.0.0') > 0) {
        fail('REMOVED PASSENGER OPTION :: rails_framework_spawner_idle_time ::  This option is no longer available in version 4.0.0. There is no alternative because framework spawning has been removed altogether. You should use smart spawning instead.')
      }
    }
    if $rails_ruby {
      if (versioncmp($passenger_installed_version, '3.0.0') > 0) {
        warning('DEPRECATED PASSENGER OPTION :: rails_ruby :: Deprecated in 3.0.0 in favor of PassengerRuby.')
      }
    }
    if $rails_spawn_method {
      if (versioncmp($passenger_installed_version, '3.0.0') > 0) {
        warning('DEPRECATED PASSENGER OPTION :: rails_spawn_method :: Deprecated in 3.0.0 in favor of PassengerSpawnMethod.')
      }
    }
    if $rails_user_switching {
      if (versioncmp($passenger_installed_version, '3.0.0') > 0) {
        warning('DEPRECATED PASSENGER OPTION :: rails_user_switching :: Deprecated in 3.0.0 in favor of PassengerUserSwitching.')
      }
    }
    if $wsgi_auto_detect {
      if (versioncmp($passenger_installed_version, '4.0.0') > 0) {
        fail('REMOVED PASSENGER OPTION :: wsgi_auto_detect ::  These options have been removed in version 4.0.0 as part of an optimization. You should use PassengerEnabled instead.')
      }
    }
  }
  # Managed by the package, but declare it to avoid purging
  if $passenger_conf_package_file {
    file { 'passenger_package.conf':
      path => "${::apache::confd_dir}/${passenger_conf_package_file}",
    }
  }

  $_package = $mod_package
  $_package_ensure = $mod_package_ensure
  $_lib = $mod_lib
  if $::osfamily == 'FreeBSD' {
    if $mod_lib_path {
      $_lib_path = $mod_lib_path
    } else {
      $_lib_path = "${passenger_root}/buildout/apache2"
    }
  } else {
    $_lib_path = $mod_lib_path
  }

  if $::osfamily == 'RedHat' and $manage_repo {
    if $::operatingsystem == 'Amazon' {
      $baseurl = 'https://oss-binaries.phusionpassenger.com/yum/passenger/el/6Server/$basearch'
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

  unless ($::operatingsystem == 'SLES') {
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
  # - $rack_auto_detect : since unkown. Deprecated in 4.0.0.
  # - $rack_base_uri : since unkown. Deprecated in 3.0.0.
  # - $rack_env : since 2.0.0.
  # - $rails_allow_mod_rewrite : since unkown. Deprecated in 4.0.0.
  # - $rails_app_spawner_idle_time : since unkown. Deprecated in 4.0.0.
  # - $rails_auto_detect : since unkown. Deprecated in 4.0.0.
  # - $rails_base_uri : since unkown. Deprecated in 3.0.0.
  # - $rails_default_user : since unkown. Deprecated in 3.0.0.
  # - $rails_env : since 2.0.0.
  # - $rails_framework_spawner_idle_time : since unkown. Deprecated in 4.0.0.
  # - $rails_ruby : since unkown. Deprecated in 3.0.0.
  # - $rails_spawn_method : since unkown. Deprecated in 3.0.0.
  # - $rails_user_switching : since unkown. Deprecated in 3.0.0.
  # - $wsgi_auto_detect : since unkown. Deprecated in 4.0.0.
  # - $rails_autodetect : this options is only for backward compatiblity with older versions of this class
  # - $rack_autodetect : this options is only for backward compatiblity with older versions of this class
  file { 'passenger.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/${passenger_conf_file}",
    content => template('apache/mod/passenger.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
