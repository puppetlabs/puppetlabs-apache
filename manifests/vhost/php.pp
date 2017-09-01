
define apache::vhost::php (
  $php_flags                                                                        = {},
  $php_values                                                                       = {},
  Optional[String] $vhost                                                           = $name,
) {

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-php-${name}"
  } else {
    $fragment_name = "${vhost}-php"
  }

  # Template uses:
  # - $php_values
  # - $php_flags
  if ($php_values and ! empty($php_values)) or ($php_flags and ! empty($php_flags)) {
    concat::fragment { $fragment_name:
      target  => "apache::vhost::${vhost}",
      order   => 240,
      content => template('apache/vhost/_php.erb'),
    }
  }

}
