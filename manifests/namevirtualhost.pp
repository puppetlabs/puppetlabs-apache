define apache::namevirtualhost {
  $vhost_name_port = $name
  include apache::params

  # Template uses: $vhost_name_port
  concat::fragment { "NameVirtualHost ${vhost_name_port}":
    target  => $apache::params::ports_file,
    content => template('apache/namevirtualhost.erb'),
  }
}
