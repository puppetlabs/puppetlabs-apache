class apache::mod::mime {
  apache::mod { 'mime': }
  # Template uses no variables
  file { "${apache::params::mod_dir}/mime.conf":
    ensure  => present,
    content => template('apache/mod/mime.conf.erb'),
  }
}
