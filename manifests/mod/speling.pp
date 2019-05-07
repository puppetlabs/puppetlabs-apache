# @summary
#   Installs `mod_spelling`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_speling.html for additional documentation.
#
class apache::mod::speling {
  include ::apache
  ::apache::mod { 'speling': }
}
