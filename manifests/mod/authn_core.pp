# @summary
#   Installs `mod_authn_core`.
# 
# @param apache_version
#   The version of apache being run.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_authn_core.html for additional documentation.
#
class apache::mod::authn_core (
  Optional[String] $apache_version = $apache::apache_version
) {
  ::apache::mod { 'authn_core': }
}
