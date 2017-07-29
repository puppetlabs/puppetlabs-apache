
define apache::vhost::action (
  $action,
  Optional[String] $vhost                                                           = $name,
) {

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-action-${name}"
  } else {
    $fragment_name = "${vhost}-action"
  }

  # Template uses:
  # - $action
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 110,
    content => template('apache/vhost/_action.erb'),
  }
}
