# @summary
#   Installs `mod_dav`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_dav.html for additional documentation.
#
class apache::mod::dav {
  ::apache::mod { 'dav': }
}
