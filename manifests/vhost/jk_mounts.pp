
define apache::vhost::jk_mounts (
  Array[Hash] $jk_mounts,
  Optional[String] $vhost                                                           = $name,
) {

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-jk_mounts-${name}"
  } else {
    $fragment_name = "${vhost}-jk_mounts"
  }

  # Template uses:
  # - $jk_mounts
  if $jk_mounts and ! empty($jk_mounts) {
    concat::fragment { $fragment_name:
      target  => "apache::vhost::${vhost}",
      order   => 340,
      content => template('apache/vhost/_jk_mounts.erb'),
    }
  }

}
