# @summary
#   Installs `mod_proxy_connect`.
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_connect.html for additional documentation.
#
class apache::mod::proxy_connect {
  include apache
  require apache::mod::proxy
  apache::mod { 'proxy_connect': }
}
