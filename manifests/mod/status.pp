class apache::mod::status {
  apache::mod { 'status': }
  # Template uses no variables
  file { "${apache::params::mod_dir}/status.conf":
    ensure  => present,
    content => template('apache/mod/status.conf.erb'),
  }
}
