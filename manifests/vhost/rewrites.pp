
define apache::vhost::rewrites (
  Optional[Array[Hash]] $rewrites                                                   = undef,
  Optional[String] $rewrite_base                                                    = undef,
  Optional[String] $rewrite_rule                                                    = undef,
  Optional[Variant[Array[String],String]] $rewrite_cond                             = undef,
  Optional[Boolean] $rewrite_inherit                                                = false,
  Optional[String] $vhost                                                           = $name,
) {

  if !$rewrites and !$rewrite_rule {
    fail("Apache::Vhost::Rewrites[${name}]: expects a value for either parameter 'rewrites' or 'rewrite_rule'")
  }

  # mod_rewrite is needed
  include ::apache::mod::rewrite

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-rewrite-${name}"
  } else {
    $fragment_name = "${vhost}-rewrite"
  }

  # Template uses:
  # - $rewrites
  # - $rewrite_base
  # - $rewrite_rule
  # - $rewrite_cond
  # - $rewrite_inherit
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 190,
    content => template('apache/vhost/_rewrite.erb'),
  }

}
