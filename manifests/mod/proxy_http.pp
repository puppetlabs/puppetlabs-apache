# @summary
#   Installs `mod_proxy_http`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_http.html for additional documentation.
#
class apache::mod::proxy_http {
  Class['::apache::mod::proxy'] -> Class['::apache::mod::proxy_http']
  ::apache::mod { 'proxy_http': }
}
