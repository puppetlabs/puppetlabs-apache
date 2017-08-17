
define apache::vhost::redirect (
  Variant[Array[String],String] $redirect_source,
  Variant[Array[String],String] $redirect_dest,
  Optional[Variant[Array[String],String]] $redirect_status                          = undef,
  Optional[String] $vhost                                                           = $name,
) {

  # Load mod_alias
  include ::apache::mod::alias

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-redirect-${name}"
  } else {
    $fragment_name = "${vhost}-redirect"
  }

  # Template uses:
  # - $redirect_source
  # - $redirect_dest
  # - $redirect_status
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 180,
    content => template('apache/vhost/_redirect.erb'),
  }

}
