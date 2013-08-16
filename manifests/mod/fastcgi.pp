class apache::mod::fastcgi {
  Class['apache::mod::worker'] -> Class['apache::mod::fastcgi']

  # Debian specifies it's fastcgi lib path, but RedHat uses the default value
  # with no config file
  $fastcgi_lib_path = $::osfamily ? {
    'debian' => '/var/lib/apache2/fastcgi',
    default  => undef,
  }

  apache::mod { 'fastcgi': }

  if $fastcgi_lib_path {
    file { 'fastcgi.conf':
      ensure  => file,
      path    => "${apache::mod_dir}/fastcgi.conf",
      content => template('apache/mod/fastcgi.conf.erb'),
      require => Exec["mkdir ${apache::mod_dir}"],
      before  => File[$apache::mod_dir],
      notify  => Service['httpd'],
    }
  }

}
