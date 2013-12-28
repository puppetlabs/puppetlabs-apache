class apache::mod::event (
  $startservers        = '2',
  $maxclients          = '150',
  $minsparethreads     = '25',
  $maxsparethreads     = '75',
  $threadsperchild     = '25',
  $maxrequestsperchild = '0',
  $serverlimit         = '25',
) {
  $lib_path       = $apache::params::lib_path
  $apache_version = $apache::params::apache_version

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
    mode  => '0644',
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
    content => template('apache/mod/event.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }

  case $::osfamily {
    'freebsd' : {
      class { 'apache::package':
        mpm_module => 'event'
      }
    }
    'debian': {
      file { "${apache::mod_enable_dir}/event.conf":
        ensure  => link,
        target  => "${apache::mod_dir}/event.conf",
        require => Exec["mkdir ${apache::mod_enable_dir}"],
        before  => File[$apache::mod_enable_dir],
        notify  => Service['httpd'],
      }

      if $apache_version == 2.4 {
        file { "${apache::mod_dir}/event.load":
          ensure  => file,
          path    => "${apache::mod_dir}/event.load",
          content => "LoadModule mpm_event_module ${lib_path}/mod_mpm_event.so\n",
          require => Exec["mkdir ${apache::mod_dir}"],
          before  => File[$apache::mod_dir],
          notify  => Service['httpd'],
        }

        file { "${apache::mod_enable_dir}/event.load":
          ensure  => link,
          target  => "${apache::mod_dir}/event.load",
          require => Exec["mkdir ${apache::mod_enable_dir}"],
          before  => File[$apache::mod_enable_dir],
          notify  => Service['httpd'],
        }
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
