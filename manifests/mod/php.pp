class apache::mod::php (
  $package_ensure = 'present',
) {
  if ((defined(Class['apache::mod::prefork']) == true) or (defined(Class['apache::mod::itk']) == true)) == false {
    fail('apache::mod::php requires apache::mod::prefork; please enable mpm_module => \'prefork\' on Class[\'apache\']')
  }
  apache::mod { 'php5':
    package_ensure => $package_ensure,
  }

  include apache::mod::mime
  include apache::mod::dir
  Class['apache::mod::mime'] -> Class['apache::mod::dir'] -> Class['apache::mod::php']

  file { 'php5.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/php5.conf",
    content => template('apache/mod/php5.conf.erb'),
    require => [
      Class["apache::mod::${apache::mpm_module}"],
      Exec["mkdir ${apache::mod_dir}"],
    ],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }
}
