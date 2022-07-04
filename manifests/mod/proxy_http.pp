# @summary
#   Installs `mod_proxy_http`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_http.html for additional documentation.
#
class apache::mod::proxy_http {
  require apache::mod::proxy
  ::apache::mod { 'proxy_http': }
}
