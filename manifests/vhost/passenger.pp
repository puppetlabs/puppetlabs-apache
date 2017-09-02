
define apache::vhost::passenger (
  $passenger_spawn_method                                                           = undef,
  $passenger_app_root                                                               = undef,
  $passenger_app_env                                                                = undef,
  $passenger_ruby                                                                   = undef,
  $passenger_min_instances                                                          = undef,
  $passenger_max_requests                                                           = undef,
  $passenger_start_timeout                                                          = undef,
  $passenger_user                                                                   = undef,
  $passenger_group                                                                  = undef,
  $passenger_high_performance                                                       = undef,
  $passenger_nodejs                                                                 = undef,
  Optional[Boolean] $passenger_sticky_sessions                                      = undef,
  $passenger_startup_file                                                           = undef,
  Optional[String] $vhost                                                           = $name,
) {

  if $passenger_spawn_method or $passenger_app_root or $passenger_app_env or $passenger_ruby or $passenger_min_instances or $passenger_max_requests or $passenger_start_timeout or $passenger_user or $passenger_group or $passenger_high_performance or $passenger_nodejs or $passenger_sticky_sessions or $passenger_startup_file {
    include ::apache::mod::passenger
  }

  # Template uses:
  # - $passenger_spawn_method
  # - $passenger_app_root
  # - $passenger_app_env
  # - $passenger_ruby
  # - $passenger_min_instances
  # - $passenger_max_requests
  # - $passenger_start_timeout
  # - $passenger_user
  # - $passenger_group
  # - $passenger_high_performance
  # - $passenger_nodejs
  # - $passenger_sticky_sessions
  # - $passenger_startup_file
  if $passenger_spawn_method or $passenger_app_root or $passenger_app_env or $passenger_ruby or $passenger_min_instances or $passenger_max_requests or $passenger_start_timeout or $passenger_user or $passenger_group or $passenger_high_performance or $passenger_nodejs or $passenger_sticky_sessions or $passenger_startup_file {
    concat::fragment { "${vhost}-passenger":
      target  => "apache::vhost::${vhost}",
      order   => 300,
      content => template('apache/vhost/_passenger.erb'),
    }
  }
}
