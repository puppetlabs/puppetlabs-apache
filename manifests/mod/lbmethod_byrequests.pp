# @summary
#   Installs `lbmethod_byrequests`.
# 
# @param apache_version
#   Ignored, here for compatibility.
# 
# @see https://httpd.apache.org/docs/2.4/mod/mod_lbmethod_byrequests.html for additional documentation.
#
class apache::mod::lbmethod_byrequests (
  Optional[String] $apache_version = undef,
) {
  require apache::mod::proxy_balancer

  apache::mod { 'lbmethod_byrequests': }
}
