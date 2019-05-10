# @summary
#   Installs `mod_auth_gsappi`.
# 
# @see https://github.com/modauthgssapi/mod_auth_gssapi for additional documentation.
#
class apache::mod::auth_gssapi {
  include apache
  include apache::mod::authn_core
  apache::mod { 'auth_gssapi': }
}
