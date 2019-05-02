# @summary
#   Installs `mod_auth_basic`
# 
# @see https://httpd.apache.org/docs/current/mod/mod_auth_basic.html for additional documentation.
#
class apache::mod::auth_basic {
  ::apache::mod { 'auth_basic': }
}
