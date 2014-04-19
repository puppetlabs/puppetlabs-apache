define apache::fastcgi::server (
  $listen = '127.0.0.1:9000',
  $timout = '15',
  $faux_path = '/var/www/$name.fcgi',
  $alias = '/$name.cfgi',
  $file_type = 'application/x-httpd-php'
) {
  
  file { "$name":
    ensure => file,
    path    => "${::apache::mod_dir}/fastcgi-pool-$name.conf",
    content => template('apache/fastcgi/server.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Service['httpd']
  }
}
