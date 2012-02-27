class apache::mod::python {
  include apache

  package { "python":
    name => $::operatingsystem ? {
      'centos' => "mod_python",
      'fedora' => "mod_python",
      'redhat' => "mod_python",
      'scientific' => "mod_python",
      default => "libapache2-mod-python",
    },
    ensure  => installed,
    require => Package["httpd"];
  }

  a2mod { "python": ensure => present; }

}


