
define apache::vhost::error_documents (
  $error_documents,
  Optional[String] $vhost                                                           = $name,
) {

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-error_document-${name}"
  } else {
    $fragment_name = "${vhost}-error_document"
  }

  # Template uses:
  # - $aliases
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 130,
    content => template('apache/vhost/_error_document.erb'),
  }
}
