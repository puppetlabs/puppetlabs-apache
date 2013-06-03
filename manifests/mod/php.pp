class apache::mod::php {
  apache::mod { 'php5': }
  file { 'php.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/php.conf",
    content => template('apache/mod/php.conf.erb'),
    require => Class['apache::mod::prefork'],
  }
}
