# @summary
#   Installs `mod_include`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_include.html for additional documentation.
#
class apache::mod::include {
  ::apache::mod { 'include': }
}
