# @summary
#   Installs and configures `mod_event`.
# 
# @param startservers
#   Sets the number of child server processes created at startup, via the module's `StartServers` directive. Setting this to `false` 
#   removes the parameter.
#
# @param maxrequestworkers
#   Sets the maximum number of connections Apache can simultaneously process, via the module's `MaxRequestWorkers` directive. Setting 
#   these to `false` removes the parameters.
#
# @param minsparethreads
#   Sets the minimum number of idle threads, via the `MinSpareThreads` directive. Setting this to `false` removes the parameters.
#
# @param maxsparethreads
#   Sets the maximum number of idle threads, via the `MaxSpareThreads` directive. Setting this to `false` removes the parameters.
#
# @param threadsperchild
#   Number of threads created by each child process.
#
# @param maxconnectionsperchild
#   Limit on the number of connections that an individual child server will handle during its life.
#
# @param serverlimit
#   Limits the configurable number of processes via the `ServerLimit` directive. Setting this to `false` removes the parameter.
#
# @param threadlimit
#    Limits the number of event threads via the module's `ThreadLimit` directive. Setting this to `false` removes the parameter.
#
# @param listenbacklog
#   Sets the maximum length of the pending connections queue via the module's `ListenBackLog` directive. Setting this to `false` removes 
#   the parameter.
#
# @note
#   You cannot include apache::mod::event with apache::mod::itk, apache::mod::peruser, apache::mod::prefork, or 
#   apache::mod::worker on the same server.
#
# @see https://httpd.apache.org/docs/current/mod/event.html for additional documentation.
# @note Unsupported platforms: SLES: all
class apache::mod::event (
  Variant[Integer, Boolean] $startservers                     = 2,
  Optional[Variant[Integer, Boolean]] $maxrequestworkers      = undef,
  Variant[Integer, Boolean] $minsparethreads                  = 25,
  Variant[Integer, Boolean] $maxsparethreads                  = 75,
  Variant[Integer, Boolean] $threadsperchild                  = 25,
  Optional[Variant[Integer, Boolean]] $maxconnectionsperchild = undef,
  Variant[Integer, Boolean] $serverlimit                      = 25,
  Variant[Integer, Boolean]  $threadlimit                     = 64,
  Variant[Integer, Boolean]  $listenbacklog                   = 511,
) {
  include apache

  if defined(Class['apache::mod::itk']) {
    fail('May not include both apache::mod::event and apache::mod::itk on the same node')
  }
  if defined(Class['apache::mod::peruser']) {
    fail('May not include both apache::mod::event and apache::mod::peruser on the same node')
  }
  if defined(Class['apache::mod::prefork']) {
    fail('May not include both apache::mod::event and apache::mod::prefork on the same node')
  }
  if defined(Class['apache::mod::worker']) {
    fail('May not include both apache::mod::event and apache::mod::worker on the same node')
  }
  File {
    owner => 'root',
    group => $apache::params::root_group,
    mode  => $apache::file_mode,
  }

  # Template uses:
  # - $startservers
  # - $minsparethreads
  # - $maxsparethreads
  # - $threadsperchild
  # - $serverlimit
  $parameters = {
    'serverlimit'             => $serverlimit,
    'startservers'            => $startservers,
    'maxrequestworkers'       => $maxrequestworkers,
    'minsparethreads'         => $minsparethreads,
    'maxsparethreads'         => $maxsparethreads,
    'threadsperchild'         => $threadsperchild,
    'maxconnectionsperchild'  => $maxconnectionsperchild,
    'threadlimit'             => $threadlimit,
    'listenbacklog'           => $listenbacklog,
  }

  $eventconffile = $facts['os']['family'] ? {
    'Debian' => "${apache::mod_dir}/mpm_event.conf",
    default  => "${apache::mod_dir}/event.conf",
  }

  file { $eventconffile:
    ensure  => file,
    mode    => $apache::file_mode,
    content => epp('apache/mod/event.conf.epp', $parameters),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }

  case $facts['os']['family'] {
    'RedHat', 'Debian', 'FreeBSD' : {
      apache::mpm { 'event':
      }
    }
    'Gentoo': {
      ::portage::makeconf { 'apache2_mpms':
        content => 'event',
      }
    }
    default: {
      fail("Unsupported osfamily ${$facts['os']['family']}")
    }
  }
}
