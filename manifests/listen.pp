# @summary
#   Adds `Listen` directives to `ports.conf` that define the 
#   Apache server's or a virtual host's listening address and port.
#
# The `apache::vhost` class uses this defined type, and titles take the form 
# `<PORT>`, `<IPV4>:<PORT>`, or `<IPV6>:<PORT>`.
define apache::listen {
  $listen_addr_port = $name

  # Template uses: $listen_addr_port
  concat::fragment { "Listen ${listen_addr_port}":
    target  => $apache::ports_file,
    content => template('apache/listen.erb'),
  }
}
