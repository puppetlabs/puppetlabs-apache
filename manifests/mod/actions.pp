# @summary
#   This class enables Apache mod_actions
# 
# See [`Apache mod_Actions`](https://httpd.apache.org/docs/2.4/mod/mod_actions.html) 
# for more information.
class apache::mod::actions {
  apache::mod { 'actions': }
}
