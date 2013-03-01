class apache::mod::deflate {
  apache::mod { 'deflate': }
  # Template uses no variables
  file { 'deflate.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/deflate.conf",
    content => template('apache/mod/deflate.conf.erb'),
  }
}
