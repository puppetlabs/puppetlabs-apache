class apache::mod::python {
  include apache

  package { "mod_python_package":
    name    => $apache::params::mod_python_package,
    ensure  => installed,
    require => Package["httpd"];
  }

  a2mod { "python": ensure => present; }

}


