# @summary
#   Installs Apache `mod_vhost_alias`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_vhost_alias.html for additional documentation.
#
class apache::mod::vhost_alias {
  ::apache::mod { 'vhost_alias': }
}
