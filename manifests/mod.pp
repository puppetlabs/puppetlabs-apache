define apache::mod (
  $package = undef
) {
  $module = $name
  include apache
  $mod_packages = $apache::params::mod_packages
  if $package {
    $package_REAL = $package
  } elsif $mod_packages[$module] {
    $package_REAL = $mod_packages[$module]
  }
  if $package_REAL {
    package { $package_REAL:
      ensure  => present,
      require => Package['httpd'],
    }
  }

  a2mod { $module:
    ensure  => present,
    require => Package['httpd'],
    notify  => Service['httpd']
  }
}
