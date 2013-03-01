class apache::mod::mpm_event {
  # Template uses no variables
  file { 'mpm_event.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/mpm_event.conf",
    content => template('apache/mod/mpm_event.conf.erb'),
  }
}
