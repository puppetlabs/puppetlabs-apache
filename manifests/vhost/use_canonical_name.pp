
define apache::vhost::use_canonical_name (
  Enum['On', 'on', 'Off', 'off', 'DNS', 'dns'] $use_canonical_name,
  Optional[String] $vhost                                                           = $name,
) {

  # Template uses:
  # - $use_canonical_name
  concat::fragment { "${name}-use_canonical_name":
    target  => "apache::vhost::${vhost}",
    order   => 360,
    content => template('apache/vhost/_use_canonical_name.erb'),
  }
}
