# @summary
#   Installs `mod_authn_file`.
# 
# @see https://httpd.apache.org/docs/2.4/mod/mod_authn_file.html for additional documentation.
#
class apache::mod::authn_file {
  ::apache::mod { 'authn_file': }
}
