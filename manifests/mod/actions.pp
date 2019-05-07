# @summary
#   Installs Apache mod_actions
# 
# @see https://httpd.apache.org/docs/current/mod/mod_actions.html for additional documentation.
#
class apache::mod::actions {
  apache::mod { 'actions': }
}
