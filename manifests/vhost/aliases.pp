
define apache::vhost::aliases (
  $aliases,
  Optional[String] $vhost                                                           = $name,
) {

  # Load mod_alias if needed and not yet loaded
  if $aliases and $aliases != [] {
    if ! defined(Class['apache::mod::alias']) {
      include ::apache::mod::alias
    }
  }

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-aliases-${name}"
  } else {
    $fragment_name = "${vhost}-aliases"
  }

  # Template uses:
  # - $aliases
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 20,
    content => template('apache/vhost/_aliases.erb'),
  }
}
