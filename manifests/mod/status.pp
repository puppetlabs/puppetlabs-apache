class apache::mod::status {
  apache::mod { 'status': }
  # Template uses no variables
  file { 'status.conf':
    ensure  => present,
    path    => "${apache::mod_dir}/status.conf",
    content => template('apache/mod/status.conf.erb'),
  }
}
