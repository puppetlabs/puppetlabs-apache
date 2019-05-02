# @summary
#   Installs `mod_proxy_fcgi`.
#
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_fcgi.html for additional documentation.
#
class apache::mod::proxy_fcgi {
  Class['::apache::mod::proxy'] -> Class['::apache::mod::proxy_fcgi']
  ::apache::mod { 'proxy_fcgi': }
}
