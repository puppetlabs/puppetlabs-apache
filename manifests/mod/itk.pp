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
# @see http://mpm-itk.sesse.net for additional documentation.
# @note Unsupported platforms: CentOS: 8; RedHat: 8, 9; SLES: all
class apache::mod::itk (
  Integer $startservers                                  = 8,
  Integer $minspareservers                               = 5,
  Integer $maxspareservers                               = 20,
  Integer $serverlimit                                   = 256,
  Integer $maxclients                                    = 256,
  Integer $maxrequestsperchild                           = 4000,
  Optional[Variant[Boolean, String]] $enablecapabilities = undef,
) {
  include apache

  if defined(Class['apache::mod::event']) {
    fail('May not include both apache::mod::itk and apache::mod::event on the same node')
  }
  if defined(Class['apache::mod::peruser']) {
    fail('May not include both apache::mod::itk and apache::mod::peruser on the same node')
  }
  # prefork is a requirement for itk in 2.4; except on FreeBSD and Gentoo, which are special
  if $facts['os']['family'] =~ /^(FreeBSD|Gentoo)/ {
    if defined(Class['apache::mod::prefork']) {
      fail('May not include both apache::mod::itk and apache::mod::prefork on the same node')
    }
  } else {
    if ! defined(Class['apache::mod::prefork']) {
      include apache::mod::prefork
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

  case $facts['os']['family'] {
    'RedHat': {
      package { 'httpd-itk':
        ensure => present,
      }
      ::apache::mpm { 'itk':
      }
    }
    'Debian', 'FreeBSD': {
      apache::mpm { 'itk':
      }
    }
    'Gentoo': {
      ::portage::makeconf { 'apache2_mpms':
        content => 'itk',
      }
    }
    default: {
      fail("Unsupported osfamily ${$facts['os']['family']}")
    }
  }
}
