define apache::fastcgi::server (
  $listen = '127.0.0.1:9000'
) {
  
  file { "$name":
    ensure => file,
    path    => "${::apache::mod_dir}/fastcgi-pool-$name.conf",
    content => template('apache/mod/fastcgi.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Service['httpd']
  }
}
