# @summary
#   Installs `mod_dbd`.
# 
# @param apache_version
#   Used to verify that the Apache version you have requested is compatible with the module.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_dbd.html for additional documentation.
#
class apache::mod::dbd {
  ::apache::mod { 'dbd': }
}
