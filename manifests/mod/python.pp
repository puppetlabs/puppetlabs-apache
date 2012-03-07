class apache::mod::python {
  include apache

  package { "python":
      'centos', 'fedora', 'redhat', 'scientific' => "mod_python",
    name => $::operatingsystem ? {
      default => "libapache2-mod-python",
    },
    ensure  => installed,
    require => Package["httpd"];
  }

  a2mod { "python": ensure => present; }

}


