
define apache::vhost::setenv (
  $setenv                                                                           = [],
  $setenvif                                                                         = [],
  $setenvifnocase                                                                   = [],
  Optional[String] $vhost                                                           = $name,
) {

  # Check if mod_env is required and not yet loaded.
  # create an expression to simplify the conditional check
  $use_env_mod = $setenv and ! empty($setenv)
  if ($use_env_mod) {
    if ! defined(Class['apache::mod::env']) {
      include ::apache::mod::env
    }
  }
  # Check if mod_setenvif is required and not yet loaded.
  # create an expression to simplify the conditional check
  $use_setenvif_mod = ($setenvif and ! empty($setenvif)) or ($setenvifnocase and ! empty($setenvifnocase))

  if ($use_setenvif_mod) {
    if ! defined(Class['apache::mod::setenvif']) {
      include ::apache::mod::setenvif
    }
  }

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-setenv-${name}"
  } else {
    $fragment_name = "${vhost}-setenv"
  }

  # Template uses:
  # - $setenv
  # - $setenvif
  # - $setenvifnocase
  if ($use_env_mod or $use_setenvif_mod) {
    concat::fragment { $fragment_name:
      target  => "apache::vhost::${vhost}",
      order   => 220,
      content => template('apache/vhost/_setenv.erb'),
    }
  }

}
