
define apache::vhost::default_charset (
  $add_default_charset,
  Optional[String] $vhost                                                           = $name,
) {

  # Template uses:
  # - $add_default_charset
  if $add_default_charset {
    concat::fragment { "${vhost}-charsets":
      target  => "apache::vhost::${vhost}",
      order   => 310,
      content => template('apache/vhost/_charsets.erb'),
    }
  }
}
