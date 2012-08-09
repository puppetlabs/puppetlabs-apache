class apache::mod::userdir (
  $dir = 'public_html',
) {
  apache::mod { 'userdir': }

  # Template uses $dir
  file { "${apache::params::vdir}/userdir.conf":
    ensure  => present,
    content => template('apache/mod/userdir.conf.erb'),
  }
}
