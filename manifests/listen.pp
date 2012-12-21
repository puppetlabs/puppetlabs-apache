define apache::listen {
  $listen_port = $name
  include apache::params

  # Template uses: $listen_port
  concat::fragment { "Listen ${listen_port}":
    target  => $apache::params::ports_file,
    content => template('apache/listen.erb'),
  }
}
