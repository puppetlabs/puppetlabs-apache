class apache::mod::prefork (
  $startservers        = '8',
  $minspareservers     = '5',
  $maxspareservers     = '20',
  $serverlimit         = '256',
  $maxclients          = '256',
  $maxrequestsperchild = '4000',
) {
  if defined(Class['apache::mod::worker']) {
    fail('May not include both apache::mod::worker and apache::mod::prefork on the same node')
  }
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  # Template uses:
  # - $startservers
  # - $minspareservers
  # - $maxspareservers
  # - $serverlimit
  # - $maxclients
  # - $maxrequestsperchild
  file { "${apache::mod_dir}/prefork.conf":
    ensure  => file,
    content => template('apache/mod/prefork.conf.erb'),
  }

  case $::osfamily {
    'redhat': {
      file_line { '/etc/sysconfig/httpd prefork enable':
        ensure  => present,
        path    => '/etc/sysconfig/httpd',
        line    => '#HTTPD=/usr/sbin/httpd.prefork',
        match   => '#?HTTPD=',
        require => Package['httpd'],
        notify  => Service['httpd'],
      }
    }
    'debian': {
      file { "${apache::mod_enable_dir}/prefork.conf":
        ensure => link,
        target => "${apache::mod_dir}/prefork.conf",
      }
      package { 'apache2-mpm-prefork':
        ensure => present,
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
