class apache::mod::dev inherits apache::params {
  # Development packages have no mod to load
  $packages = $apache::params::mod_packages['dev']
  package { $packages:
    ensure  => present,
    require => Package['httpd'],
  }
}
