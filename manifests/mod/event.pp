# @summary
#   Installs and configures `mod_event`.
# 
# @param startservers
#   Sets the number of child server processes created at startup, via the module's `StartServers` directive. Setting this to `false` 
#   removes the parameter.
#
# @param maxclients
#   Apache 2.3.12 or older alias for the `MaxRequestWorkers` directive.
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
# @param maxrequestsperchild
#   Apache 2.3.8 or older alias for the `MaxConnectionsPerChild` directive.
#
# @param maxconnectionsperchild
#   Limit on the number of connections that an individual child server will handle during its life.
#
# @param serverlimit
#   Limits the configurable number of processes via the `ServerLimit` directive. Setting this to `false` removes the parameter.
#
# @param apache_version
#   Version of Apache to install module on.
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
  Variant[String,Boolean] $startservers                       = '2',
  Variant[String,Boolean] $maxclients                         = '150',
  Optional[Variant[String,Boolean]] $maxrequestworkers        = undef,
  Variant[String,Boolean] $minsparethreads                    = '25',
  Variant[String,Boolean] $maxsparethreads                    = '75',
  Variant[String,Boolean] $threadsperchild                    = '25',
  Variant[String,Boolean] $maxrequestsperchild                = '0',
  Optional[Variant[String,Boolean]] $maxconnectionsperchild   = undef,
  Variant[String,Boolean] $serverlimit                        = '25',
  Optional[String] $apache_version                            = undef,
  Variant[String,Boolean]  $threadlimit                       = '64',
  Variant[String,Boolean]  $listenbacklog                     = '511',
) {
  include apache

  $_apache_version = pick($apache_version, $apache::apache_version)

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
  # - $maxclients
  # - $minsparethreads
  # - $maxsparethreads
  # - $threadsperchild
  # - $maxrequestsperchild
  # - $serverlimit
  file { "${apache::mod_dir}/event.conf":
    ensure  => file,
    mode    => $apache::file_mode,
    content => template('apache/mod/event.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }

  case $facts['os']['family'] {
    'redhat': {
      if versioncmp($_apache_version, '2.4') >= 0 {
        apache::mpm { 'event':
          apache_version => $_apache_version,
        }
      }
    }
    'debian','freebsd' : {
      apache::mpm { 'event':
        apache_version => $_apache_version,
      }
    }
    'gentoo': {
      ::portage::makeconf { 'apache2_mpms':
        content => 'event',
      }
    }
    default: {
      fail("Unsupported osfamily ${$facts['os']['family']}")
    }
  }
}
