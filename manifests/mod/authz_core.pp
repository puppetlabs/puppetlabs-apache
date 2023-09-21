# @summary
#   Installs `mod_authz_core`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_authz_core.html for additional documentation.
#
class apache::mod::authz_core {
  apache::mod { 'authz_core': }
}
