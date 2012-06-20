class apache::mod::fcgid {

  include apache::params

  include apache

  if ($::operatingsystem != 'Ubuntu' and
     $::operatingsystem != 'Debian') {
    fail "apache::mod::fcgid not implemented for ${::operatingsystem}"
  }

  file {'fcgi-scripts-dir':
    ensure  => directory,
    path    => $apache::params::fcgi_scriptsdir,
    require => Package['mod_fcgid']

  }

  package{'mod_fcgid':
    ensure => 'present',
    name   => $apache::params::fcgi_package_name
  }

  a2mod{'fcgid':
    ensure  => present,
    require => Package['mod_fcgid']
  }

  file{'/etc/apache2/mods-available/fcgid.conf':
    ensure  => present,
    content => template('apache/fcgid.conf.erb'),
    require => Package['mod_fcgid']

  }

}
