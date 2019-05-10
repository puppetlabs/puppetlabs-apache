# @summary
#   Installs `mod_proxy_ajp`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_ajp.html for additional documentation.
#
class apache::mod::proxy_ajp {
  Class['::apache::mod::proxy'] -> Class['::apache::mod::proxy_ajp']
  ::apache::mod { 'proxy_ajp': }
}
