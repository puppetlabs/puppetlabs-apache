
define apache::vhost::request_header (
  Variant[Array[String],String] $request_headers,
  Optional[String] $vhost                                                           = $name,
) {

  # mod_headers is required to process $headers/$request_headers
  include ::apache::mod::headers

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-requestheader-${name}"
  } else {
    $fragment_name = "${vhost}-requestheader"
  }

  # Template uses:
  # - $request_headers
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 150,
    content => template('apache/vhost/_requestheader.erb'),
  }
}
