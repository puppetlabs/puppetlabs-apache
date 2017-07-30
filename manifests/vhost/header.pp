
define apache::vhost::header (
  $headers,
  Optional[String] $vhost                                                           = $name,
) {

  # mod_headers is required to process $headers/$request_headers
  include ::apache::mod::headers

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-header-${name}"
  } else {
    $fragment_name = "${vhost}-header"
  }

  # Template uses:
  # - $aliases
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 140,
    content => template('apache/vhost/_header.erb'),
  }
}
