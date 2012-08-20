define apache::mod (
  $package = undef
) {
  $mod = $name
  include apache::params
  #include apache #This creates duplicate resources in rspec-puppet
  $mod_packages = $apache::params::mod_packages
  if $package {
    $package_REAL = $package
  } elsif $mod_packages[$mod] {
    $package_REAL = $mod_packages[$mod]
  }
  $mod_libs = $apache::params::mod_libs
  if $mod_libs {
    $lib = $mod_libs[$mod]
  }

  if $package_REAL {
    package { $package_REAL:
      ensure  => present,
      require => Package['httpd'],
      before  => A2mod[$mod],
    }
  }

  a2mod { $mod:
    ensure  => present,
    lib     => $lib,
    require => Package['httpd'],
    notify  => Service['httpd'],
  }
}
