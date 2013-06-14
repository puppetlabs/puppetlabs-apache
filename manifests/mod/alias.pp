class apache::mod::alias {
  $icons_path = $::osfamily ? {
    'debian' => '/usr/share/apache2/icons',
    'redhat' => '/var/www/icons',
    'suse'   => '/usr/share/apache2/icons',
  }
  apache::mod { 'alias': }
  # Template uses $icons_path
  file { 'alias.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/alias.conf",
    content => template('apache/mod/alias.conf.erb'),
  }
}
