
define apache::vhost::block (
  $block,
  $apache_version                                                                   = $::apache::apache_version,
  Optional[String] $vhost                                                           = $name,
) {

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-block-${name}"
  } else {
    $fragment_name = "${vhost}-block"
  }

  # Template uses:
  # - $block
  # - $apache_version
  if $block and ! empty($block) {
    concat::fragment { $fragment_name:
      target  => "apache::vhost::${vhost}",
      order   => 120,
      content => template('apache/vhost/_block.erb'),
    }
  }
}
