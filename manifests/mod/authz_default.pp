# @summary
#   Installs and configures `mod_authz_default`.
# 
# @param apache_version
#   Version of Apache to install module on.
#
# @see https://httpd.apache.org/docs/current/mod/mod_authz_default.html for additional documentation.
#
class apache::mod::authz_default (
  $apache_version = $apache::apache_version
) {
  if versioncmp($apache_version, '2.4') >= 0 {
    warning('apache::mod::authz_default has been removed in Apache 2.4')
  } else {
    ::apache::mod { 'authz_default': }
  }
}
