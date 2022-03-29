# @summary
#   Installs `mod_proxy_connect`.
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_connect.html for additional documentation.
#
class apache::mod::proxy_connect {
  include apache
  Class['apache::mod::proxy'] -> Class['apache::mod::proxy_connect']
  apache::mod { 'proxy_connect': }
}
