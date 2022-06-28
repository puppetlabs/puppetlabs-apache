# @summary
#   Installs `mod_authz_groupfile`
#
# @see https://httpd.apache.org/docs/current/mod/mod_authz_groupfile.html for additional documentation.
#
class apache::mod::authz_groupfile {
  include apache
  apache::mod { 'authz_groupfile': }
}
