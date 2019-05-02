# @summary
#   Installs and configures `mod_shib`.
# 
# @param suppress_warning
#   Toggles whether to trigger warning on RedHat nodes.
# 
# @param mod_full_path
#   Specifies a path to the module. Do not manually set this parameter without a special reason.
# 
# @param package_name
#   Name of the Shibboleth package to be installed.
# 
# @param mod_lib
#   Specifies a path to the module's libraries. Do not manually set this parameter without special reason. The `path` parameter 
#   overrides this value. 
#
# This class installs and configures only the Apache components of a web application that consumes Shibboleth SSO identities. You
# can manage the Shibboleth configuration manually, with Puppet, or using a [Shibboleth Puppet Module](https://github.com/aethylred/puppet-shibboleth).
# 
# @note
#   The Shibboleth module isn't available on RH/CentOS without providing dependency packages provided by Shibboleth's repositories. 
#   See the [Shibboleth Service Provider Installation Guide](http://wiki.aaf.edu.au/tech-info/sp-install-guide).
#
# @see https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPApacheConfig for additional documentation.
#
class apache::mod::shib (
  $suppress_warning = false,
  $mod_full_path    = undef,
  $package_name     = undef,
  $mod_lib          = undef,
) {
  include ::apache
  if $::osfamily == 'RedHat' and ! $suppress_warning {
    warning('RedHat distributions do not have Apache mod_shib in their default package repositories.')
  }

  $mod_shib = 'shib2'

  apache::mod {$mod_shib:
    id      => 'mod_shib',
    path    => $mod_full_path,
    package => $package_name,
    lib     => $mod_lib,
  }
}
