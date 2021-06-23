# @summary
#   Installs `mod_authnz_host`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_authz_host.html for additional documentation.
#
class apache::mod::authz_host {
  include apache
  ::apache::mod { 'authz_host': }
}
