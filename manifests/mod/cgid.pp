class apache::mod::cgid {
  $cgisock_path = $::osfamily ? {
    'debian' => '${APACHE_RUN_DIR}/cgisock',
  }
  apache::mod { 'cgid': }
  # Template uses $cgisock_path
  file { 'cgid.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/cgid.conf",
    content => template('apache/mod/cgid.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }
}
