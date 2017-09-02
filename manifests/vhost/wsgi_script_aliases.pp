
define apache::vhost::wsgi_script_aliases (
  Optional[Hash] $wsgi_script_aliases_match                                         = undef,
  Optional[Hash] $wsgi_script_aliases                                               = undef,
  Optional[String] $vhost                                                           = $name,
) {

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-wsgi_script_aliases-${name}"
  } else {
    $fragment_name = "${vhost}-wsgi_script_aliases"
  }

  # Template uses:
  # - $wsgi_script_aliases
  # - $wsgi_script_aliases_match
  if ($wsgi_script_aliases and ! empty($wsgi_script_aliases)) or ($wsgi_script_aliases_match and ! empty($wsgi_script_aliases_match)) {
    concat::fragment { $fragment_name:
      target  => "apache::vhost::${vhost}",
      order   => 261,
      content => template('apache/vhost/_wsgi_script_aliases.erb'),
    }
  }
}
