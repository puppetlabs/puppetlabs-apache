# @summary
#   Installs `mod_dbd`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_dbd.html for additional documentation.
#
class apache::mod::dbd {
  ::apache::mod { 'dbd': }
}
