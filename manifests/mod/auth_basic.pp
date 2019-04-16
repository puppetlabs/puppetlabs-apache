# @summary
#   This class enables Apache mod_auth_basic
# 
# See [`Apache mod_auth_basic`](https://httpd.apache.org/docs/2.4/mod/mod_auth_basic.html) 
# for more information.
class apache::mod::auth_basic {
  ::apache::mod { 'auth_basic': }
}
