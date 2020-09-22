# @summary
#   Installs MPM `mod_itk`.
# 
# @param startservers
#   Number of child server processes created on startup.
#
# @param minspareservers
#   Minimum number of idle child server processes.
#
# @param maxspareservers
#   Maximum number of idle child server processes.
#
# @param serverlimit
#   Maximum configured value for `MaxRequestWorkers` for the lifetime of the Apache httpd process.
#
# @param maxclients
#   Limit on the number of simultaneous requests that will be served.
#
# @param maxrequestsperchild
#   Limit on the number of connections that an individual child server process will handle.
#
# @param enablecapabilities
#   Drop most root capabilities in the parent process, and instead run as the user given by the User/Group directives with some extra
#   capabilities (in particular setuid). Somewhat more secure, but can cause problems when serving from filesystems that do not honor 
#   capabilities, such as NFS.
#
# @param apache_version
#   Used to verify that the Apache version you have requested is compatible with the module.
# 
# @see http://mpm-itk.sesse.net for additional documentation.
# @note Unsupported platforms: CentOS: 8; RedHat: 8; SLES: all
class apache::mod::itk (
  $startservers        = '8',
  $minspareservers     = '5',
  $maxspareservers     = '20',
  $serverlimit         = '256',
  $maxclients          = '256',
  $maxrequestsperchild = '4000',
  $enablecapabilities  = undef,
  $apache_version      = undef,
) {
  include apache

  $_apache_version = pick($apache_version, $apache::apache_version)

  if defined(Class['apache::mod::event']) {
    fail('May not include both apache::mod::itk and apache::mod::event on the same node')
  }
  if defined(Class['apache::mod::peruser']) {
    fail('May not include both apache::mod::itk and apache::mod::peruser on the same node')
  }
  if versioncmp($_apache_version, '2.4') < 0 {
    if defined(Class['apache::mod::prefork']) {
      fail('May not include both apache::mod::itk and apache::mod::prefork on the same node')
    }
  } else {
    # prefork is a requirement for itk in 2.4; except on FreeBSD and Gentoo, which are special
    if $::osfamily =~ /^(FreeBSD|Gentoo)/ {
      if defined(Class['apache::mod::prefork']) {
        fail('May not include both apache::mod::itk and apache::mod::prefork on the same node')
      }
    } else {
      if ! defined(Class['apache::mod::prefork']) {
        include apache::mod::prefork
      }
    }
  }
  if defined(Class['apache::mod::worker']) {
    fail('May not include both apache::mod::itk and apache::mod::worker on the same node')
  }
  File {
    owner => 'root',
    group => $apache::params::root_group,
    mode  => $apache::file_mode,
  }

  # Template uses:
  # - $startservers
  # - $minspareservers
  # - $maxspareservers
  # - $serverlimit
  # - $maxclients
  # - $maxrequestsperchild
  file { "${apache::mod_dir}/itk.conf":
    ensure  => file,
    mode    => $apache::file_mode,
    content => template('apache/mod/itk.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }

  case $::osfamily {
    'redhat': {
      package { 'httpd-itk':
        ensure => present,
      }
      if versioncmp($_apache_version, '2.4') >= 0 {
        ::apache::mpm { 'itk':
          apache_version => $_apache_version,
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
      apache::mpm { 'itk':
        apache_version => $_apache_version,
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
