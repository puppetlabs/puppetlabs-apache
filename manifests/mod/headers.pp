# @summary
#   Installs and configures `mod_headers`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_headers.html for additional documentation.
#
class apache::mod::headers {
  ::apache::mod { 'headers': }
}
