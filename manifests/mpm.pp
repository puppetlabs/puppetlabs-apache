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

  if $facts['os']['family'] == 'Debian' {
    $mpm_modules = ['mpm_event', 'mpm_worker', 'mpm_prefork'] - "mpm_${mpm}"
    $mpmloadfile = "${mod_dir}/mpm_${mpm}.load"
    $mpmloadcontent = $mpm ? {
      /(event|prefork|worker)/ => "# Conflicts: ${join($mpm_modules, ' ')}\nLoadModule ${_id} ${_path}\n",
      'itk'                    => "# Depends: mpm_prefork\nLoadModule ${_id} ${_path}\n",
    }
  } else {
    $mpmloadfile = "${mod_dir}/${mpm}.load"
    $mpmloadcontent = $facts['os']['family'] ? {
      'Suse'  => '',
      default => "LoadModule ${_id} ${_path}\n"
    }
  }

  file { $mpmloadfile:
    ensure  => file,
    path    => $mpmloadfile,
    content => $mpmloadcontent,
    require => [
      Package['httpd'],
      Exec["mkdir ${mod_dir}"],
    ],
    before  => File[$mod_dir],
    notify  => Class['apache::service'],
  }

  case $facts['os']['family'] {
    'Debian': {
      file {
        default:
          ensure  => link,
          require => Exec["mkdir ${apache::mod_enable_dir}"],
          before  => File[$apache::mod_enable_dir],
          notify  => Class['apache::service'],
          ;
        "${apache::mod_enable_dir}/mpm_${mpm}.conf":
          target  => "../mods-available/mpm_${mpm}.conf",
          ;
        "${apache::mod_enable_dir}/mpm_${mpm}.load":
          target  => "../mods-available/mpm_${mpm}.load",
          ;
      }

      if $mpm == 'itk' {
        file { "${lib_path}/mod_mpm_itk.so":
          ensure  => link,
          target  => "${lib_path}/mpm_itk.so",
          require => Package['httpd'],
          before  => Class['apache::service'],
        }

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
    'Suse': {
      file {
        default:
          ensure  => link,
          require => Exec["mkdir ${apache::mod_enable_dir}"],
          before  => File[$apache::mod_enable_dir],
          notify  => Class['apache::service'],
          ;
        "${apache::mod_enable_dir}/${mpm}.conf":
          target  => "${mod_dir}/${mpm}.conf",
          ;
        "${apache::mod_enable_dir}/${mpm}.load":
          target  => "${mod_dir}/${mpm}.load",
          ;
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
    'FreeBSD': {
      class { 'apache::package':
        mpm_module => $mpm,
      }
    }
    'Gentoo', 'RedHat': {
      # so we don't fail
    }
    default: {
      fail("Unsupported osfamily ${$facts['os']['family']}")
    }
  }
}
