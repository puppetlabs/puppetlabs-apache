class apache::mod::mpm_event {
  # Template uses no variables
  file { "${apache::params::mod_dir}/mpm_event.conf":
    ensure  => present,
    content => template('apache/mod/mpm_event.conf.erb'),
  }
}
