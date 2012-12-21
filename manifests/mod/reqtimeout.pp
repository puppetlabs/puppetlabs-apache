class apache::mod::reqtimeout {
  apache::mod { 'reqtimeout': }
  # Template uses no variables
  file { "${apache::params::mod_dir}/reqtimeout.conf":
    ensure  => present,
    content => template('apache/mod/reqtimeout.conf.erb'),
  }
}
