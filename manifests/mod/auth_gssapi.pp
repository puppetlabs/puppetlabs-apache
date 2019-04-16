# @summary
#   This class enables Apache mod_auth_gsappi
# 
# See [`Apache mod_auth_gsappi`](https://github.com/modauthgssapi/mod_auth_gssapi) 
# for more information.
class apache::mod::auth_gssapi {
  include apache
  include apache::mod::authn_core
  apache::mod { 'auth_gssapi': }
}
