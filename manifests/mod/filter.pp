# @summary
#   Installs `mod_filter`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_filter.html for additional documentation.
#
class apache::mod::filter {
  ::apache::mod { 'filter': }
}
