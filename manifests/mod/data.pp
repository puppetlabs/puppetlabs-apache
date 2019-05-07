# @summary
#   Installs and configures `mod_data`.
# 
# @param apache_version
#   Version of Apache to install module on.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_data.html for additional documentation.
#
class apache::mod::data (
  $apache_version = undef,
) {
  include ::apache
  $_apache_version = pick($apache_version, $apache::apache_version)
  if versioncmp($_apache_version, '2.3') < 0 {
    fail('mod_data is only available in Apache 2.3 and later')
  }
  ::apache::mod { 'data': }
}
