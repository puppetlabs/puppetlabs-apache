class apache::mod::auth_kerb {
  include apache

  package { 'mod_auth_kerb_package':
    ensure  => installed,
    name    => $apache::params::mod_auth_kerb_package,
    require => Package['httpd'];
  }

  a2mod { 'auth_kerb': ensure => present; }

}


