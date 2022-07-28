# @summary
#   Installs `lbmethod_heartbeat`.
# 
# @param apache_version
#   Version of Apache to install module on.
# 
# @see https://httpd.apache.org/docs/2.4/mod/mod_lbmethod_heartbeat.html for additional documentation.
#
class apache::mod::lbmethod_heartbeat (
  Optional[String] $apache_version   = $apache::apache_version,
) {
  require apache::mod::proxy_balancer

  if versioncmp($apache_version, '2.3') >= 0 {
    apache::mod { 'lbmethod_heartbeat': }
  } else {
    fail('Unsuported version for mod lbmethod_heartbeat')
  }
}
