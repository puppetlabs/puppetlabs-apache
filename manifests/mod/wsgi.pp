class apache::mod::wsgi (
  $wsgi_socket_prefix = undef,
  $wsgi_python_home   = undef,
){
  apache::mod { 'wsgi': }

  # Template uses:
  # - $wsgi_socket_prefix
  # - $wsgi_python_home
  file {'wsgi.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/wsgi.conf",
    content => template('apache/mod/wsgi.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd']
  }
}

