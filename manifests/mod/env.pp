# @summary
#   Installs `mod_env`.
#
# @see https://httpd.apache.org/docs/current/mod/mod_env.html for additional documentation.
#
class apache::mod::env {
  ::apache::mod { 'env': }
}
