class apache::mod::passenger {

  case $::operatingsystem {
    'debian': { $passenger_package = 'libapache2-mod-passenger' }
    default:  { notice "passenger package for ${::operatingsystem} undefined"}
  }

  package { 'passenger':
    name    => $passenger_package,
    ensure  => installed,
    require => Package['httpd'];
  }

  file { '/etc/apache2/mods-available/passenger.conf':
    ensure  => present,
    source  => 'puppet:///apache/passenger.conf',
    require => Package['passenger']
  }

  a2mod { 'passenger':
    ensure => present;
  }

}
