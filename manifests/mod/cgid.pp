class apache::mod::cgid {
  $cgisock_path = $::osfamily ? {
    'debian' => '${APACHE_RUN_DIR}/cgisock',
  }
  apache::mod { 'cgid': }
  # Template uses $cgisock_path
  file { "${apache::params::mod_dir}/cgid.conf":
    ensure  => present,
    content => template('apache/mod/cgid.conf.erb'),
  }
}
