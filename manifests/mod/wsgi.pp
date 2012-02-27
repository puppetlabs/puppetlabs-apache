class apache::mod::wsgi {
  include apache

  package { "wsgi":
      'centos', 'fedora', 'redhat', 'scientific' => "mod_wsgi",
    name => $::operatingsystem ? {
      default => "libapache2-mod-wsgi",
    },
    ensure  => installed,
    require => Package["httpd"];
  }

  a2mod { "wsgi": ensure => present; }

}

