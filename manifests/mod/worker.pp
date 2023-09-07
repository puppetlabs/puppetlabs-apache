# @summary
#   Installs and manages the MPM `worker`.
#
# @param startservers
#   The number of child server processes created on startup
#
# @param minsparethreads
#   Minimum number of idle threads to handle request spikes.
#
# @param maxsparethreads
#   Maximum number of idle threads.
#
# @param threadsperchild
#   The number of threads created by each child process.
#
# @param maxrequestsperchild
#   Limit on the number of connectiojns an individual child server
#   process will handle. This is the old name and is still supported. The new
#   name is MaxConnectionsPerChild as of 2.3.9+.
#
# @param serverlimit
#   With worker, use this directive only if your MaxRequestWorkers
#   and ThreadsPerChild settings require more than 16 server processes
#   (default). Do not set the value of this directive any higher than the
#   number of server processes required by what you may want for
#   MaxRequestWorkers and ThreadsPerChild.
#
# @param threadlimit
#   This directive sets the maximum configured value for
#   ThreadsPerChild for the lifetime of the Apache httpd process.
#
# @param listenbacklog
#    Maximum length of the queue of pending connections.
#
# @param maxrequestworkers
#   Maximum number of connections that will be processed simultaneously
#
# @see https://httpd.apache.org/docs/current/mod/worker.html for additional documentation.
#
class apache::mod::worker (
  Integer $startservers            = 2,
  Integer $minsparethreads         = 25,
  Integer $maxsparethreads         = 75,
  Integer $threadsperchild         = 25,
  Integer $maxrequestsperchild     = 0,
  Integer $serverlimit             = 25,
  Integer $threadlimit             = 64,
  Integer $listenbacklog           = 511,
  Integer $maxrequestworkers       = 150,
) {
  include apache

  if defined(Class['apache::mod::event']) {
    fail('May not include both apache::mod::worker and apache::mod::event on the same node')
  }
  if defined(Class['apache::mod::itk']) {
    fail('May not include both apache::mod::worker and apache::mod::itk on the same node')
  }
  if defined(Class['apache::mod::peruser']) {
    fail('May not include both apache::mod::worker and apache::mod::peruser on the same node')
  }
  if defined(Class['apache::mod::prefork']) {
    fail('May not include both apache::mod::worker and apache::mod::prefork on the same node')
  }
  File {
    owner => 'root',
    group => $apache::params::root_group,
    mode  => $apache::file_mode,
  }

  # Template uses:
  # - $startservers
  # - $maxrequestworkers
  # - $minsparethreads
  # - $maxsparethreads
  # - $threadsperchild
  # - $maxrequestsperchild
  # - $serverlimit
  # - $threadLimit
  # - $listenbacklog
  $parameters = {
    'serverlimit'         => $serverlimit,
    'startservers'        => $startservers,
    'threadlimit'         => $threadlimit,
    'minsparethreads'     => $minsparethreads,
    'maxsparethreads'     => $maxsparethreads,
    'threadsperchild'     => $threadsperchild,
    'maxrequestsperchild' => $maxrequestsperchild,
    'listenbacklog'       => $listenbacklog,
    'maxrequestworkers'   => $maxrequestworkers,
  }

  file { "${apache::mod_dir}/worker.conf":
    ensure  => file,
    content => epp('apache/mod/worker.conf.epp', $parameters),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }

  case $facts['os']['family'] {
    'RedHat', 'Debian', 'FreeBSD': {
      ::apache::mpm { 'worker':
      }
    }
    'Suse': {
      ::apache::mpm { 'worker':
        lib_path => '/usr/lib64/apache2-worker',
      }
    }

    'Gentoo': {
      ::portage::makeconf { 'apache2_mpms':
        content => 'worker',
      }
    }
    default: {
      fail("Unsupported osfamily ${$facts['os']['family']}")
    }
  }
}
