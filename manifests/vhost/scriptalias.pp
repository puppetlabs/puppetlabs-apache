
define apache::vhost::scriptalias (
  Optional[String] $scriptalias                                                     = undef,
  Optional[Variant[Array[Hash],Hash]] $scriptaliases                                = undef,
  Optional[String] $vhost                                                           = $name,
) {

  if !$scriptalias and !$scriptaliases {
    fail("Apache::Vhost::Scriptalias[${name}]: expects a value for either parameter 'scriptalias' or 'scriptaliases'")
  }

  # mod_alias is needed
  include ::apache::mod::alias

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-scriptalias-${name}"
  } else {
    $fragment_name = "${vhost}-scriptalias"
  }

  # Template uses:
  # - $scriptaliases
  # - $scriptalias
  if ( $scriptalias or $scriptaliases != [] ) {
    concat::fragment { $fragment_name:
      target  => "apache::vhost::${vhost}",
      order   => 200,
      content => template('apache/vhost/_scriptalias.erb'),
    }
  }

}
