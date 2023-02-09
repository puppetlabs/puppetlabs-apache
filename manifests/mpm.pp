# @summary Enables the use of Apache MPMs.
#
# @api private
define apache::mpm (
  String $lib_path                 = $apache::lib_path,
) {
  if ! defined(Class['apache']) {
    fail('You must include the apache base class before using any apache defined resources')
  }

  $mpm     = $name
  $mod_dir = $apache::mod_dir

  $_lib  = "mod_mpm_${mpm}.so"
  $_path = "${lib_path}/${_lib}"
  $_id   = "mpm_${mpm}_module"

  if $facts['os']['family'] == 'Suse' {
    #mpms on Suse 12 don't use .so libraries so create a placeholder load file
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
  } else {
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

  case $facts['os']['family'] {
    'Debian': {
      file { "${apache::mod_enable_dir}/${mpm}.conf":
        ensure  => link,
        target  => "${apache::mod_dir}/${mpm}.conf",
        require => Exec["mkdir ${apache::mod_enable_dir}"],
        before  => File[$apache::mod_enable_dir],
        notify  => Class['apache::service'],
      }

      file { "${apache::mod_enable_dir}/${mpm}.load":
        ensure  => link,
        target  => "${apache::mod_dir}/${mpm}.load",
        require => Exec["mkdir ${apache::mod_enable_dir}"],
        before  => File[$apache::mod_enable_dir],
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

      if $mpm == 'itk' {
        package { 'libapache2-mpm-itk':
          ensure => present,
          before => [
            Class['apache::service'],
            File[$apache::mod_enable_dir],
          ],
        }
      }

      unless $mpm in ['itk', 'prefork'] {
        include apache::mpm::disable_mpm_prefork
      }

      if $mpm != 'worker' {
        include apache::mpm::disable_mpm_worker
      }

      if $mpm != 'event' {
        include apache::mpm::disable_mpm_event
      }
    }

    'FreeBSD': {
      class { 'apache::package':
        mpm_module => $mpm,
      }
    }
    'Gentoo': {
      # so we don't fail
    }
    'RedHat': {
      # so we don't fail
    }
    'Suse': {
      file { "${apache::mod_enable_dir}/${mpm}.conf":
        ensure  => link,
        target  => "${apache::mod_dir}/${mpm}.conf",
        require => Exec["mkdir ${apache::mod_enable_dir}"],
        before  => File[$apache::mod_enable_dir],
        notify  => Class['apache::service'],
      }

      file { "${apache::mod_enable_dir}/${mpm}.load":
        ensure  => link,
        target  => "${apache::mod_dir}/${mpm}.load",
        require => Exec["mkdir ${apache::mod_enable_dir}"],
        before  => File[$apache::mod_enable_dir],
        notify  => Class['apache::service'],
      }

      if $mpm == 'itk' {
        file { "${lib_path}/mod_mpm_itk.so":
          ensure => link,
          target => "${lib_path}/mpm_itk.so",
        }
      }

      package { "apache2-${mpm}":
        ensure => present,
      }
    }
    default: {
      fail("Unsupported osfamily ${$facts['os']['family']}")
    }
  }
}
