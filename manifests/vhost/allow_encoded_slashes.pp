
define apache::vhost::allow_encoded_slashes (
  Enum['on', 'off', 'nodecode'] $allow_encoded_slashes,
  Optional[String] $vhost                                                           = $name,
) {
  # Template uses:
  # - $allow_encoded_slashes
  concat::fragment { "${vhost}-allow_encoded_slashes":
    target  => "apache::vhost::${vhost}",
    order   => 50,
    content => template('apache/vhost/_allow_encoded_slashes.erb'),
  }
}
