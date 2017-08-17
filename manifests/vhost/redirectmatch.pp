
define apache::vhost::redirectmatch (
  Variant[Array[String],String] $redirectmatch_regexp,
  Variant[Array[String],String] $redirectmatch_dest,
  Optional[Variant[Array[String],String]] $redirectmatch_status                     = undef,
  Optional[String] $vhost                                                           = $name,
) {

  # Load mod_alias
  include ::apache::mod::alias

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-redirectmatch-${name}"
  } else {
    $fragment_name = "${vhost}-redirectmatch"
  }

  # Template uses:
  # - $redirectmatch_status
  # - $redirectmatch_regexp
  # - $redirectmatch_dest
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 180,
    content => template('apache/vhost/_redirectmatch.erb'),
  }

}
