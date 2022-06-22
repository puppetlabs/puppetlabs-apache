# @summary
#   Installs `mod_proxy_wstunnel`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_wstunnel.html for additional documentation.
#
class apache::mod::proxy_wstunnel {
  include apache
  require apache::mod::proxy
  ::apache::mod { 'proxy_wstunnel': }
}
