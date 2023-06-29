# @summary
#   Installs `mod_proxy_http2`.
#
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_http2.html for additional documentation.
#
class apache::mod::proxy_http2 {
  require apache::mod::proxy
  apache::mod { 'proxy_http2': }
}
