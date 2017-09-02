
define apache::vhost::filters (
  Variant[Array[String],String] $filters,
  Optional[String] $vhost                                                           = $name,
) {

  # We need mod_filter to process $filters
  include ::apache::mod::filter

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-filters-${name}"
  } else {
    $fragment_name = "${vhost}-filters"
  }

  # Template uses:
  # - $filters
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 330,
    content => template('apache/vhost/_filters.erb'),
  }

}
