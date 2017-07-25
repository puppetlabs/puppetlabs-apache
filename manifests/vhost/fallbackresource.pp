
define apache::vhost::fallbackresource (
  Variant[Stdlib::Absolutepath, Enum['disabled']] $fallbackresource,
  Optional[String] $vhost                                                           = $name,
) {
  # Template uses:
  # - $fallbackresource
  concat::fragment { "${vhost}-fallbackresource":
    target  => "apache::vhost::${vhost}",
    order   => 40,
    content => template('apache/vhost/_fallbackresource.erb'),
  }
}
