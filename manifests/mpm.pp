# @summary Enables the use of Apache MPMs.
#
# @api private
define apache::mpm (
  $lib_path       = $::apache::lib_path,
  $apache_version = $::apache::apache_version,
) {
  if ! defined(Class['apache']) {
    fail('You must include the apache base class before using any apache defined resources')
  }

  $mpm     = $name
  $mod_dir = $::apache::mod_dir

  $_lib  = "mod_mpm_${mpm}.so"
  $_path = "${lib_path}/${_lib}"
  $_id   = "mpm_${mpm}_module"

  if $::osfamily == 'Suse' {
    #mpms on Suse 12 don't use .so libraries so create a placeholder load file
    if versioncmp($apache_version, '2.4') >= 0 {
      file { "${mod_dir}/${mpm}.load":
        ensure  => file,
        path    => "${mod_dir}/${mpm}.load",
        content => '',
        require => [
          Package['httpd'],
          Exec["mkdir ${mod_dir}"],
        ],
        before  => File[$mod_dir],
        notify  => Class['apache::service'],
      }
    }
  } else {
      if versioncmp($apache_version, '2.4') >= 0 {
        file { "${mod_dir}/${mpm}.load":
          ensure  => file,
          path    => "${mod_dir}/${mpm}.load",
          content => "LoadModule ${_id} ${_path}\n",
          require => [
            Package['httpd'],
            Exec["mkdir ${mod_dir}"],
          ],
          before  => File[$mod_dir],
          notify  => Class['apache::service'],
        }
      }
    }

  case $::osfamily {
    'debian': {
      file { "${::apache::mod_enable_dir}/${mpm}.conf":
        ensure  => link,
        target  => "${::apache::mod_dir}/${mpm}.conf",
        require => Exec["mkdir ${::apache::mod_enable_dir}"],
        before  => File[$::apache::mod_enable_dir],
        notify  => Class['apache::service'],
      }

      if versioncmp($apache_version, '2.4') >= 0 {
        file { "${::apache::mod_enable_dir}/${mpm}.load":
          ensure  => link,
          target  => "${::apache::mod_dir}/${mpm}.load",
          require => Exec["mkdir ${::apache::mod_enable_dir}"],
          before  => File[$::apache::mod_enable_dir],
          notify  => Class['apache::service'],
        }

        if $mpm == 'itk' {
          file { "${lib_path}/mod_mpm_itk.so":
            ensure  => link,
            target  => "${lib_path}/mpm_itk.so",
            require => Package['httpd'],
            before  => Class['apache::service'],
          }
        }
      } else {
        package { "apache2-mpm-${mpm}":
          ensure => present,
          before => [
            Class['apache::service'],
            File[$::apache::mod_enable_dir],
          ],
        }
      }


      if $mpm == 'itk' {
        if ( ( $::operatingsystem == 'Ubuntu' ) or ( ($::operatingsystem == 'Debian') and ( versioncmp($::operatingsystemrelease, '8.0.0') >= 0 ) ) ) {
          include apache::mpm::disable_mpm_event
        }

        package { 'libapache2-mpm-itk':
          ensure => present,
          before => [
            Class['apache::service'],
            File[$::apache::mod_enable_dir],
          ],
        }
      }

      if $mpm == 'prefork' {
        if ( ( $::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease,'18.04') >= 0 ) or ( $::operatingsystem == 'Debian' and versioncmp($::operatingsystemrelease, '9.0.0') >= 0 ) ) {
          include apache::mpm::disable_mpm_event
          include apache::mpm::disable_mpm_worker
        }
      }

      if $mpm == 'worker' {
        if ( ( $::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease,'18.04') >= 0 ) or ( $::operatingsystem == 'Debian' and versioncmp($::operatingsystemrelease, '8.0.0') >= 0 ) ) {
          include apache::mpm::disable_mpm_event
        }
      }

    }

    'freebsd': {
      class { '::apache::package':
        mpm_module => $mpm,
      }
    }
    'gentoo': {
      # so we don't fail
    }
    'redhat': {
      # so we don't fail
    }
    'Suse': {
      file { "${::apache::mod_enable_dir}/${mpm}.conf":
        ensure  => link,
        target  => "${::apache::mod_dir}/${mpm}.conf",
        require => Exec["mkdir ${::apache::mod_enable_dir}"],
        before  => File[$::apache::mod_enable_dir],
        notify  => Class['apache::service'],
      }

      if versioncmp($apache_version, '2.4') >= 0 {
        file { "${::apache::mod_enable_dir}/${mpm}.load":
          ensure  => link,
          target  => "${::apache::mod_dir}/${mpm}.load",
          require => Exec["mkdir ${::apache::mod_enable_dir}"],
          before  => File[$::apache::mod_enable_dir],
          notify  => Class['apache::service'],
        }

        if $mpm == 'itk' {
          file { "${lib_path}/mod_mpm_itk.so":
            ensure => link,
            target => "${lib_path}/mpm_itk.so",
          }
        }
      }

      package { "apache2-${mpm}":
        ensure => present,
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
