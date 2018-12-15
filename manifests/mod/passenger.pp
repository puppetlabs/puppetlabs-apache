# Manages the settings for the mod_passenger
# The result is the /etc/mods-available/mod_passenger.conf file
#
# Where do we get these settings?
#   Settings are dervied from https://www.phusionpassenger.com/library/config/apache/reference
#   Also in passenger source code you can strip out what are all the available options by looking in
#     * src/apache2_module/Configuration.cpp
#     * src/apache2_module/ConfigurationCommands.cpp
#   Note: in the src there are several undocumented settings.
#
# Change Log:
#   * As of 08/13/2017 there are 84 available/deprecated/removed settings.
#   * Around 08/20/2017 UnionStation was discontinued options were removed.
#   * As of 08/20/2017 there are 77 available/deprecated/removed settings.
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
      gpgkey        => 'https://packagecloud.io/phusion/passenger/gpgkey',
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
