# @summary
#   Installs `mod_authz_host`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_authz_host.html for additional documentation.
#
class apache::mod::authz_host {
  if versioncmp($apache_version, '2.4') >= 0 {
    include apache
    apache::mod { 'authz_host': }
  } else {
      fail('This module requires apache version 2.4')
    } 
}
