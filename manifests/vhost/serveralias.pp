
define apache::vhost::serveralias (
  Optional[Variant[String,Array[String]]] $serveraliases                            = undef,
  Optional[String] $vhost                                                           = $name,
) {

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-serveralias-${name}"
  } else {
    $fragment_name = "${vhost}-serveralias"
  }

  # Template uses:
  # - $serveraliases
  if $serveraliases and ! empty($serveraliases) {
    concat::fragment { $fragment_name:
      target  => "apache::vhost::${vhost}",
      order   => 210,
      content => template('apache/vhost/_serveralias.erb'),
    }
  }

}
