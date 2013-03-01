class apache::mod::php($ensure = 'present') {
  include apache::params
  apache::mod { 'php5':
    ensure => $ensure
  }
  file { "${apache::params::vdir}/php.conf":
    ensure  => $ensure,
    content => template('apache/mod/php.conf.erb'),
  }
}
