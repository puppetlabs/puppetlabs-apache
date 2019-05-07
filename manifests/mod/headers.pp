# @summary
#   Installs and configures `mod_headers`.
# 
# @param apache_version
#   Version of Apache to install module on.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_headers.html for additional documentation.
#
class apache::mod::headers {
  ::apache::mod { 'headers': }
}
