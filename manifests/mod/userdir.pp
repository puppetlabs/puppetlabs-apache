class apache::mod::userdir (
  $home = '/home',
  $dir = 'public_html',
  $disable_root = true,
) {
  apache::mod { 'userdir': }

  # Template uses $home, $dir, $disable_root
  file { 'userdir.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/userdir.conf",
    content => template('apache/mod/userdir.conf.erb'),
  }
}
