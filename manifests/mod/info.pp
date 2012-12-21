class apache::mod::info {
  apache::mod { 'info': }
  # Template uses no variables
  file { "${apache::params::mod_dir}/info.conf":
    ensure  => present,
    content => template('apache/mod/info.conf.erb'),
  }
}
