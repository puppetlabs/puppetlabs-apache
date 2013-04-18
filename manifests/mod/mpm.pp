class apache::mod::mpm {
  ## this may work on other platforms that compile it as a module
  ## fedora is the only one I know of
  ## this may also not be the best way to do this because if default mods aren't enabled on fedora it will break
  if (versioncmp($::apache_version, '2.4') >= 0) {
    if $::operatingsystem == fedora {
      apache::mod { "mpm_${apache::params::mpm}": }
    }
  }
}
