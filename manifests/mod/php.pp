class apache::mod::php {
  if ! defined(Class['apache::mod::prefork']) {
    fail('apache::mod::php requires apache::mod::prefork; please enable mpm_module => \'prefork\' on Class[\'apache\']')
  }
  if $::osfamily == 'FreeBSD' {
    apache::mod { 'php5': 
      # We put 'LoadModule' directive into httpd.conf instead of creating
      # *.load file. This is necessary for php5 port to be installed correctly.
      loadfile => false
    }
    file_line { 'httpd.conf LoadModule php5_module':
      ensure => present,
      path   => "${apache::params::conf_dir}/${apache::params::conf_file}",
      line   => "LoadModule php5_module libexec/apache22/libphp5.so",
      match => '#? *LoadModule php5_module',
      require => Package['httpd'],
      notify  => Service['httpd'],
    }
  } else {
    apache::mod { 'php5': }
  }
  file { 'php5.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/php5.conf",
    content => template('apache/mod/php5.conf.erb'),
    require => [
      Class['apache::mod::prefork'],
      Exec["mkdir ${apache::mod_dir}"],
    ],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }
}
