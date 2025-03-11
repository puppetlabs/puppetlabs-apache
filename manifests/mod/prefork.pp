# @summary
#   Installs and configures MPM `prefork`.
# 
# @param startservers
#   Number of child server processes created at startup.
#
# @param minspareservers
#   Minimum number of idle child server processes.
# 
# @param maxspareservers
#   Maximum number of idle child server processes.
# 
# @param serverlimit
#   Upper limit on configurable number of processes.
# 
# @param maxclients
#   Old alias for MaxRequestWorkers.
# 
# @param maxrequestworkers
#   Maximum number of connections that will be processed simultaneously.
# 
# @param maxrequestsperchild
#  Old alias for MaxConnectionsPerChild.
# 
# @param maxconnectionsperchild
#   Limit on the number of connections that an individual child server will handle during its life.
#
# @param listenbacklog
#   Maximum length of the queue of pending connections.
# 
# @see https://httpd.apache.org/docs/current/mod/prefork.html for additional documentation.
#
class apache::mod::prefork (
  Integer $startservers                     = 8,
  Integer $minspareservers                  = 5,
  Integer $maxspareservers                  = 20,
  Integer $serverlimit                      = 256,
  Integer $maxclients                       = 256,
  Optional[Integer] $maxrequestworkers      = undef,
  Integer $maxrequestsperchild              = 4000,
  Optional[Integer] $maxconnectionsperchild = undef,
  Integer $listenbacklog                    = 511
) {
  include apache
  if defined(Class['apache::mod::event']) {
    fail('May not include both apache::mod::prefork and apache::mod::event on the same node')
  }
  if defined(Class['apache::mod::peruser']) {
    fail('May not include both apache::mod::prefork and apache::mod::peruser on the same node')
  }
  if defined(Class['apache::mod::worker']) {
    fail('May not include both apache::mod::prefork and apache::mod::worker on the same node')
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
  # - $maxrequestworkers
  # - $maxrequestsperchild
  # - $maxconnectionsperchild
  $parameters = {
    'startservers'            => $startservers,
    'minspareservers'         => $minspareservers,
    'maxspareservers'         => $maxspareservers,
    'serverlimit'             => $serverlimit,
    'maxrequestworkers'       => $maxrequestworkers,
    'maxclients'              => $maxclients,
    'maxconnectionsperchild'  => $maxconnectionsperchild,
    'maxrequestsperchild'     => $maxrequestsperchild,
    'listenbacklog'           => $listenbacklog,
  }

  file { "${apache::mod_dir}/prefork.conf":
    ensure  => file,
    content => epp('apache/mod/prefork.conf.epp', $parameters),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }

  case $facts['os']['family'] {
    'RedHat', 'Debian', 'FreeBSD': {
      ::apache::mpm { 'prefork':
      }
    }
    'Suse': {
      ::apache::mpm { 'prefork':
        lib_path => '/usr/lib64/apache2-prefork',
      }
    }
    'Gentoo': {
      ::portage::makeconf { 'apache2_mpms':
        content => 'prefork',
      }
    }
    default: {
      fail("Unsupported osfamily ${$facts['os']['family']}")
    }
  }
}
