class apache::mod::deflate {
  apache::mod { 'deflate': }
  # Template uses no variables
  file { "${apache::params::mod_dir}/deflate.conf":
    ensure  => present,
    content => template('apache/mod/deflate.conf.erb'),
  }
}
