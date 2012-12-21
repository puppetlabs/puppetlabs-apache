class apache::mod::dir (
  $dir = 'public_html',
) {
  apache::mod { 'dir': }

  # Template uses no variables
  file { "${apache::params::mod_dir}/dir.conf":
    ensure  => present,
    content => template('apache/mod/dir.conf.erb'),
  }
}
