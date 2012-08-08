class apache::mod::default {
  file { "${apache::params::vdir}/mod_default.conf":
    ensure  => present,
    content => template('apache/mod/default.erb'),
    notify  => Service['httpd'],
    require => Package['httpd'],
  }
}
