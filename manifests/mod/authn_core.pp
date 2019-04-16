# @summary
#   This class enables Apache mod_authn_core
# 
# @param apache_version
#   The version of apache being run
# 
# See [`Apache mod_authn_core`](https://httpd.apache.org/docs/2.4/mod/mod_authn_core.html) 
# for more information.
class apache::mod::authn_core(
  $apache_version = $::apache::apache_version
) {
  if versioncmp($apache_version, '2.4') >= 0 {
    ::apache::mod { 'authn_core': }
  }
}
