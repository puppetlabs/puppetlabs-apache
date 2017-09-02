
define apache::vhost::fastcgi_server (
  $fastcgi_server,
  $fastcgi_socket,
  $fastcgi_idle_timeout                                                             = undef,
  Optional[String] $vhost                                                           = $name,
) {

  # Load mod_fastcgi if needed and not yet loaded
  if ! defined(Class['apache::mod::fastcgi']) {
    include ::apache::mod::fastcgi
  }

  # Template uses:
  # - $fastcgi_server
  # - $fastcgi_socket
  # - $fastcgi_idle_timeout
  concat::fragment { "${vhost}-fastcgi":
    target  => "apache::vhost::${vhost}",
    order   => 280,
    content => template('apache/vhost/_fastcgi.erb'),
  }
}
