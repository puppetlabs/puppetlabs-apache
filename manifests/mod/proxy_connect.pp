# @summary
#   Installs `mod_proxy_connect`.
# 
# @param apache_version
#   Used to verify that the Apache version you have requested is compatible with the module.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_connect.html for additional documentation.
#
class apache::mod::proxy_connect (
  $apache_version  = undef,
) {
  include apache
  $_apache_version = pick($apache_version, $apache::apache_version)
  if versioncmp($_apache_version, '2.2') >= 0 {
    Class['::apache::mod::proxy'] -> Class['::apache::mod::proxy_connect']
    ::apache::mod { 'proxy_connect': }
  }
}
