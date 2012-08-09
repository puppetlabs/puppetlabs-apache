class apache::mod::php {
  apache::mod { 'php5': }
  file { "${apache::params::vdir}/php.conf":
    ensure  => present,
    content => template('apache/mod/php.conf.erb'),
  }
}
