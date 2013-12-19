class apache::mod::alias {
  $icons_path = $::osfamily or $::operatingsystem ? {
    'debian'  => '/usr/share/apache2/icons',
    'redhat'  => '/var/www/icons',
    'amazon'  => '/var/www/icons',
    'freebsd' => '/usr/local/www/apache22/icons',
  }
  apache::mod { 'alias': }
  # Template uses $icons_path
  file { 'alias.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/alias.conf",
    content => template('apache/mod/alias.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }
}
