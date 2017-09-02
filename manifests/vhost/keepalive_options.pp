
define apache::vhost::keepalive_options (
  Optional[Enum['on', 'off']] $keepalive                                            = undef,
  Optional[Variant[Integer,String]] $keepalive_timeout                              = undef,
  Optional[Variant[Integer,String]] $max_keepalive_requests                         = undef,
  Optional[String] $vhost                                                           = $name,
) {

  # Template uses:
  # - $keepalive
  # - $keepalive_timeout
  # - $max_keepalive_requests
  if $keepalive or $keepalive_timeout or $max_keepalive_requests {
    concat::fragment { "${vhost}-keepalive_options":
      target  => "apache::vhost::${vhost}",
      order   => 350,
      content => template('apache/vhost/_keepalive_options.erb'),
    }
  }
}
