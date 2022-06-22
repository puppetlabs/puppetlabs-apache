# @summary
#   Installs `mod_proxy_fcgi`.
#
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_fcgi.html for additional documentation.
#
class apache::mod::proxy_fcgi {
  require apache::mod::proxy
  ::apache::mod { 'proxy_fcgi': }
}
