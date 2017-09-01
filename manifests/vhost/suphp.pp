
define apache::vhost::suphp (
  $suphp_addhandler                                                                 = $::apache::params::suphp_addhandler,
  Enum['on', 'off'] $suphp_engine                                                   = $::apache::params::suphp_engine,
  $suphp_configpath                                                                 = $::apache::params::suphp_configpath,
  Optional[String] $vhost                                                           = $name,
) {

  # Template uses:
  # - $suphp_engine
  # - $suphp_addhandler
  # - $suphp_configpath
  if $suphp_engine == 'on' {
    concat::fragment { "${vhost}-suphp":
      target  => "apache::vhost::${vhost}",
      order   => 240,
      content => template('apache/vhost/_suphp.erb'),
    }
  }
}
