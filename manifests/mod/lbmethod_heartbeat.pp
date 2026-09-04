# @summary
#   Installs `lbmethod_heartbeat`.
# 
# @param apache_version
#   Ignored, here for compatibility.
# 
# @see https://httpd.apache.org/docs/2.4/mod/mod_lbmethod_heartbeat.html for additional documentation.
#
class apache::mod::lbmethod_heartbeat (
  Optional[String] $apache_version = undef,
) {
  require apache::mod::proxy_balancer

  apache::mod { 'lbmethod_heartbeat': }
}
