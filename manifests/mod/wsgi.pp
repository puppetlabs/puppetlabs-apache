class apache::mod::wsgi {
  include apache

  package { "wsgi":
    name => $operatingsystem ? {
      'centos', 'fedora', 'redhat', 'scientific' => "mod_wsgi",
      default => "libapache2-mod-wsgi",
    },
    ensure  => installed,
    require => Package["httpd"];
  }

  a2mod { "wsgi": ensure => present; }

}

