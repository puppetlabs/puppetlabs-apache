class apache::mod::wsgi (
  $wsgi_socket_prefix = undef
){
  apache::mod { 'wsgi': }

  if $wsgi_socket_prefix != undef {
    # Template uses: $wsgi_socket_prefix
    file {'wsgi.conf':
      ensure  => file,
      path    => "${apache::mod_dir}/wsgi.conf",
      content => template('apache/mod/wsgi.conf.erb'),
      require => Exec["mkdir ${apache::mod_dir}"],
      before  => File[$apache::mod_dir],
      notify  => Service['httpd']
    }
  }
}

