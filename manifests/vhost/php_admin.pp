
define apache::vhost::php_admin (
  $php_admin_flags                                                                  = {},
  $php_admin_values                                                                 = {},
  Optional[String] $vhost                                                           = $name,
) {

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-php_admin-${name}"
  } else {
    $fragment_name = "${vhost}-php_admin"
  }

  # Template uses:
  # - $php_admin_values
  # - $php_admin_flags
  if ($php_admin_values and ! empty($php_admin_values)) or ($php_admin_flags and ! empty($php_admin_flags)) {
    concat::fragment { $fragment_name:
      target  => "apache::vhost::${vhost}",
      order   => 250,
      content => template('apache/vhost/_php_admin.erb'),
    }
  }

}
