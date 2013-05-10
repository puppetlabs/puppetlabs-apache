class apache::mod::php {
  require apache::mod::prefork
  apache::mod { 'php5': }
  file { 'php.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/php.conf",
    content => template('apache/mod/php.conf.erb'),
  }
}
