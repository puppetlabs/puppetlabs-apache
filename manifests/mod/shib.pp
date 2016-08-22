class apache::mod::shib (
  $suppress_warning = false,
  $use_external_repository = false,
) {
  include ::apache
  if $::osfamily == 'RedHat' and ! $suppress_warning {
    warning('RedHat distributions do not have Apache mod_shib in their default package repositories.')
  }

  if $::osfamily == 'Debian' and $use_external_repository {
    if ! $suppress_warning {
      warning('You have configure apache::mod::shib in a way that requires the configuration of')
      warning('an external repository such as https://www.switch.ch/aai/guides/sp/installation')
    }
    $package = 'shibboleth'
    $lib = 'mod_shib_22.so'
  } else {
    $package = undef
    $lib = undef 
  }

  $mod_shib = 'shib2'

  apache::mod {$mod_shib:
    id => 'mod_shib',
    package => $package,
    lib => $lib,
  }

}
