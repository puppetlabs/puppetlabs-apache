# @summary
#   Installs `mod_authz_user`
# 
# @see https://httpd.apache.org/docs/current/mod/mod_authz_user.html for additional documentation.
#
class apache::mod::authz_user {
  ::apache::mod { 'authz_user': }
}
