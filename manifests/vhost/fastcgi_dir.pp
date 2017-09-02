
define apache::vhost::fastcgi_dir (
  $fastcgi_dir,
  $apache_version                                                                   = $::apache::apache_version,
  Optional[String] $vhost                                                           = $name,
) {

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-fastcgi_dir-${name}"
  } else {
    $fragment_name = "${vhost}-fastcgi_dir"
  }

  # Template uses:
  # - $fastcgi_dir
  # - $apache_version
  if $fastcgi_dir {
    concat::fragment { $fragment_name:
      target  => "apache::vhost::${vhost}",
      order   => 281,
      content => template('apache/vhost/_fastcgi_dir.erb'),
    }
  }

}
