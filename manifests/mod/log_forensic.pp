# @summary
#   Installs `mod_log_forensic`
# 
# @see https://httpd.apache.org/docs/current/mod/mod_log_forensic.html for additional documentation.
#
class apache::mod::log_forensic {
  include apache
  apache::mod { 'log_forensic': }
}
