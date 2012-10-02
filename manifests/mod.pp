define apache::mod (
  $package = undef
) {
  $mod = $name
  include apache::params
  #include apache #This creates duplicate resources in rspec-puppet
  $mod_packages = $apache::params::mod_packages
  $mod_package = $mod_packages[$mod] # 2.6 compatibility hack
  if $package {
    $package_REAL = $package
  } elsif "$mod_package" {
    $package_REAL = $mod_package
  }
  $mod_libs = $apache::params::mod_libs
  $mod_lib = $mod_libs[$mod] # 2.6 compatibility hack
  if "${mod_lib}" {
    $lib = $mod_lib
  }

  $mod_identifiers = $apache::params::mod_identifiers
  $mod_identifier = $mod_identifiers[$mod]
  if "${mod_identifier}" {
    $identifier = $mod_identifier
  }

  if $package_REAL {
    package { $package_REAL:
      ensure   => present,
      require  => Package['httpd'],
      before   => A2mod[$mod],
    }
  }

  a2mod { $mod:
    ensure     => present,
    lib        => $lib,
    identifier => $identifier,
    require    => Package['httpd'],
    notify     => Service['httpd'],
  }
}
