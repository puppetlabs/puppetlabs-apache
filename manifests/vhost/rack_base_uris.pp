
define apache::vhost::rack_base_uris (
  Variant[String,Array[String]] $rack_base_uris,
  Optional[String] $vhost                                                           = $name,
) {

  # Load mod_passenger to handle rack uris
  include ::apache::mod::passenger

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-rack-${name}"
  } else {
    $fragment_name = "${vhost}-rack"
  }

  # Template uses:
  # - $rack_base_uris
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 170,
    content => template('apache/vhost/_rack.erb'),
  }
}
