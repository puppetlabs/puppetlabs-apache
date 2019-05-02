# @summary
#   Installs `mod_rewrite`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_rewrite.html for additional documentation.
#
class apache::mod::rewrite {
  include ::apache::params
  ::apache::mod { 'rewrite': }
}
