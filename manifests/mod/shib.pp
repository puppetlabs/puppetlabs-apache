class apache::mod::shib (
  $suppress_warning = false,
  $mod_full_path = undef,
) {
  $mod_shib = 'shib2'

  if ($::osfamily == 'RedHat' or $::osfamily == 'CentOS') and ! $suppress_warning {
    # RedHat distributions do not have Apache mod_shib in their default package repositories
    # use mod_full_path to set the full path for the shibboleth module
    if ($mod_full_path == undef) {
      warning("os=${::osfamily} apache::mod::shib::mod_full_path undef.")
    }
    ::apache::mod { $mod_shib:
      id   => 'mod_shib',
      path => $mod_full_path,
    }
  }
  else {
    apache::mod {$mod_shib:
      id   => 'mod_shib',
    }
  }
}
