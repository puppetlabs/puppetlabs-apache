
define apache::vhost::directories (
  $directories,
  $apache_version                                                                   = $::apache::apache_version,
  Enum['on', 'off'] $suphp_engine                                                   = $::apache::params::suphp_engine,
  Optional[Variant[Boolean,String]] $docroot                                        = undef,
  Optional[String] $vhost                                                           = $name,
) {
  # alias for the template
  $_directories = $directories

  # Is apache::mod::shib enabled (or apache::mod['shib2'])
  $shibboleth_enabled = defined(Apache::Mod['shib2'])

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-directories-${name}"
  } else {
    $fragment_name = "${vhost}-directories"
  }

  # Template uses:
  # - $_directories
  # - $docroot
  # - $apache_version
  # - $suphp_engine
  # - $shibboleth_enabled
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 60,
    content => template('apache/vhost/_directories.erb'),
  }
}
