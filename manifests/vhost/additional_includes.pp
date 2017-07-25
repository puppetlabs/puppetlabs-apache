
define apache::vhost::additional_includes (
  $additional_includes,
  $use_optional_includes                                                            = $::apache::use_optional_includes,
  $apache_version                                                                   = $::apache::apache_version,
  Optional[String] $vhost                                                           = $name,
) {
  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-additional_includes-${name}"
  } else {
    $fragment_name = "${vhost}-additional_includes"
  }

  # Template uses:
  # - $additional_includes
  # - $use_optional_includes
  # - $apache_version
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 70,
    content => template('apache/vhost/_additional_includes.erb'),
  }
}
