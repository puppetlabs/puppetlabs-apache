class apache::mod::itk (
  $startservers        = '8',
  $minspareservers     = '5',
  $maxspareservers     = '20',
  $serverlimit         = '256',
  $maxclients          = '256',
  $maxrequestsperchild = '4000',
  $apache_version      = $::apache::apache_version,
) {
  if defined(Class['apache::mod::event']) {
    fail('May not include both apache::mod::itk and apache::mod::event on the same node')
  }
  if defined(Class['apache::mod::peruser']) {
    fail('May not include both apache::mod::itk and apache::mod::peruser on the same node')
  }
  if versioncmp($apache_version, '2.4') < 0 {
    if defined(Class['apache::mod::prefork']) {
      fail('May not include both apache::mod::itk and apache::mod::prefork on the same node')
    }
  }
  if defined(Class['apache::mod::worker']) {
    fail('May not include both apache::mod::itk and apache::mod::worker on the same node')
  }
  File {
    owner => 'root',
    group => $::apache::params::root_group,
    mode  => '0644',
  }

  # Template uses:
  # - $startservers
  # - $minspareservers
  # - $maxspareservers
  # - $serverlimit
  # - $maxclients
  # - $maxrequestsperchild
  file { "${::apache::mod_dir}/itk.conf":
    ensure  => file,
    content => template('apache/mod/itk.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }

  case $::osfamily {
    'redhat': {
      package { 'httpd-itk':
        ensure => present,
      }
      if versioncmp($apache_version, '2.4') >= 0 {
        ::apache::mpm{ 'prefork':
          apache_version => $apache_version,
        }
        ::apache::mpm{ 'itk':
          apache_version => $apache_version,
        }
      }
      else {
        file_line { '/etc/sysconfig/httpd itk enable':
          ensure  => present,
          path    => '/etc/sysconfig/httpd',
          line    => 'HTTPD=/usr/sbin/httpd.itk',
          match   => '#?HTTPD=/usr/sbin/httpd.itk',
          require => Package['httpd'],
          notify  => Class['apache::service'],
        }
      }
    }
    'debian', 'freebsd': {
      apache::mpm{ 'itk':
        apache_version => $apache_version,
      }
    }
    'gentoo': {
      ::portage::makeconf { 'apache2_mpms':
        content => 'itk',
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
