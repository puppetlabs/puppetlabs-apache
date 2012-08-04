class apache::mod::suexec {

  if ($::operatingsystem != 'Ubuntu' and
     $::operatingsystem != 'Debian') {
    fail "apache::mod::suexec not implemented for ${::operatingsystem}"
  }

  include apache::params
  include apache

  package { 'mod_suexec':
    ensure  => present,
    name    => $apache::params::suexec_package
  }

  a2mod { 'suexec':
    ensure  => present,
    require => Package['mod_suexec']
  }

}
