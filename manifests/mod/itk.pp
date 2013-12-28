class apache::mod::itk (
  $startservers        = '8',
  $minspareservers     = '5',
  $maxspareservers     = '20',
  $serverlimit         = '256',
  $maxclients          = '256',
  $maxrequestsperchild = '4000',
) {
  $lib_path       = $apache::params::lib_path
  $apache_version = $apache::params::apache_version

  if defined(Class['apache::mod::event']) {
    fail('May not include both apache::mod::itk and apache::mod::event on the same node')
  }
  if defined(Class['apache::mod::peruser']) {
    fail('May not include both apache::mod::itk and apache::mod::peruser on the same node')
  }
  if defined(Class['apache::mod::prefork']) {
    fail('May not include both apache::mod::itk and apache::mod::prefork on the same node')
  }
  if defined(Class['apache::mod::worker']) {
    fail('May not include both apache::mod::itk and apache::mod::worker on the same node')
  }
  File {
    owner => 'root',
    group => $apache::params::root_group,
    mode  => '0644',
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
    content => template('apache/mod/itk.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }

  case $::osfamily {
    'debian' : {
      file { "${apache::mod_enable_dir}/itk.conf":
        ensure  => link,
        target  => "${apache::mod_dir}/itk.conf",
        require => Exec["mkdir ${apache::mod_enable_dir}"],
        before  => File[$apache::mod_enable_dir],
        notify  => Service['httpd'],
      }

      if $apache_version == 2.4 {
        file { "${apache::mod_dir}/itk.load":
          ensure  => file,
          path    => "${apache::mod_dir}/itk.load",
          content => "LoadModule mpm_itk_module ${lib_path}/mod_mpm_itk.so\n",
          require => Exec["mkdir ${apache::mod_dir}"],
          before  => File[$apache::mod_dir],
          notify  => Service['httpd'],
        }

        file { "${apache::mod_enable_dir}/itk.load":
          ensure  => link,
          target  => "${apache::mod_dir}/itk.load",
          require => Exec["mkdir ${apache::mod_enable_dir}"],
          before  => File[$apache::mod_enable_dir],
          notify  => Service['httpd'],
        }
      }

      package { 'apache2-mpm-itk':
        ensure => present,
      }
    }
    'freebsd' : {
      class { 'apache::package':
        mpm_module => 'itk'
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
