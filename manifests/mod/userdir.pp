class apache::mod::userdir (
  $home = '/home',
  $dir = 'public_html',
  $disable_root = true,
) {
  apache::mod { 'userdir': }

  # Template uses $home, $dir, $disable_root
  file { "${apache::params::mod_dir}/userdir.conf":
    ensure  => present,
    content => template('apache/mod/userdir.conf.erb'),
  }
}
