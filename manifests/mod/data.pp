# @summary
#   Installs and configures `mod_data`.
# 
# @param apache_version
#   Version of Apache to install module on.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_data.html for additional documentation.
#
class apache::mod::data (
  Optional[String] $apache_version = undef,
) {
  include apache
  $_apache_version = pick($apache_version, $apache::apache_version)
  ::apache::mod { 'data': }
}
