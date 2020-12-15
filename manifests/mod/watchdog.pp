# @summary
#   Installs and configures `mod_watchdog`.
#
# @param watchdog_interval
#   Sets the interval at which the watchdog_step hook runs.
#
# @see https://httpd.apache.org/docs/current/mod/mod_watchdog.html for additional documentation.
class apache::mod::watchdog (
  Optional[Integer] $watchdog_interval = undef,
) {
  include apache

  $module_builtin = $facts['os']['family'] in ['Debian']

  unless $module_builtin {
    apache::mod { 'watchdog':
    }
  }

  if $watchdog_interval {
    file { 'watchdog.conf':
      ensure  => file,
      path    => "${apache::mod_dir}/watchdog.conf",
      mode    => $apache::file_mode,
      content => "WatchdogInterval ${watchdog_interval}\n",
      require => Exec["mkdir ${apache::mod_dir}"],
      before  => File[$apache::mod_dir],
      notify  => Class['apache::service'],
    }
  }
}
