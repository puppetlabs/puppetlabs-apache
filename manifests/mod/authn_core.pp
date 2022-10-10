# @summary
#   Installs `mod_authn_core`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_authn_core.html for additional documentation.
#
class apache::mod::authn_core {
  ::apache::mod { 'authn_core': }
}
