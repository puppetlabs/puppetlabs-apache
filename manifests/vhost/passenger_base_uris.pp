
define apache::vhost::passenger_base_uris (
  $passenger_base_uris,
  Optional[String] $vhost                                                           = $name,
) {

  # Load mod_passenger
  include ::apache::mod::passenger

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-passenger_uris-${name}"
  } else {
    $fragment_name = "${vhost}-passenger_uris"
  }

  # Template uses:
  # - $passenger_base_uris
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 175,
    content => template('apache/vhost/_passenger_base_uris.erb'),
  }

}

