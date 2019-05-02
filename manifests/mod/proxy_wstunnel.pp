# @summary
#   Installs `mod_proxy_wstunnel`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_wstunnel.html for additional documentation.
#
class apache::mod::proxy_wstunnel {
  include ::apache, ::apache::mod::proxy
  Class['::apache::mod::proxy'] -> Class['::apache::mod::proxy_wstunnel']
  ::apache::mod { 'proxy_wstunnel': }
}
