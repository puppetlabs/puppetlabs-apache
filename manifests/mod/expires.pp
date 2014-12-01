class apache::mod::expires(
  $expiresdefault = undef,
  $expiresactive  = 'On',
  $types          = {
    'image/gif'    => 'A2592000',
    'image/jpeg'   => 'A2592000',
    'image/jpg'    => 'A2592000',
    'image/png'    => 'A2592000',
    'image/x-icon' => 'A2592000',
    'image/ico'    => 'A2592000',
    'image/bmp'    => 'A2592000',
  },
){
  ::apache::mod { 'expires': }

  file { 'expires.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/expires.conf",
    content => template('apache/mod/expires.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Service['httpd'],
  }
}
