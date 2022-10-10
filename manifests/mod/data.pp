# @summary
#   Installs and configures `mod_data`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_data.html for additional documentation.
#
class apache::mod::data {
  include apache
  ::apache::mod { 'data': }
}
