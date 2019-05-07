# @summary
#   Installs `mod_macro`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_macro.html for additional documentation.
#
class apache::mod::macro {
  include ::apache
  ::apache::mod { 'macro': }
}
