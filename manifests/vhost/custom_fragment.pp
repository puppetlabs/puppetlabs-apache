
define apache::vhost::custom_fragment (
  Optional[String] $custom_fragment                                                 = undef,
  Optional[String] $vhost                                                           = $name,
) {

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-custom_fragment-${name}"
  } else {
    $fragment_name = "${vhost}-custom_fragment"
  }

  # Template uses:
  # - $custom_fragment
  if $custom_fragment {
    concat::fragment { $fragment_name:
      target  => "apache::vhost::${vhost}",
      order   => 270,
      content => template('apache/vhost/_custom_fragment.erb'),
    }
  }

}
