# @summary
#   Installs `mod_authz_core`.
# 
# @param apache_version
#   The version of apache being run.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_authz_core.html for additional documentation.
#
class apache::mod::authz_core {
  apache::mod { 'authz_core':
    id => 'authz_core_module',
  }
}
