class apache::mod::wsgi {
  include apache

  package { "mod_wsgi_package":
    name    => $apache::params::mod_wsgi_package,
    ensure  => installed,
    require => Package["httpd"];
  }

  a2mod { "wsgi": ensure => present; }

}

