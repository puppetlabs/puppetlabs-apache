class apache::mod::info {
  apache::mod { 'info': }
  # Template uses no variables
  file { 'info.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/info.conf",
    content => template('apache/mod/info.conf.erb'),
  }
}
