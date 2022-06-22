# @summary
#   Installs `mod_proxy_ajp`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_ajp.html for additional documentation.
#
class apache::mod::proxy_ajp {
  require apache::mod::proxy
  ::apache::mod { 'proxy_ajp': }
}
