class apache::mod::php {
  if ! defined(Class['apache::mod::prefork']) {
    fail('apache::mod::php requires apache::mod::prefork; please enable mpm_module => \'prefork\' on Class[\'apache\']')
  }
  apache::mod { 'php5': }
  file { 'php.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/php.conf",
    content => template('apache/mod/php.conf.erb'),
    require => Class['apache::mod::prefork'],
  }
}
