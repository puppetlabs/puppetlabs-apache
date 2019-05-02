# @summary
#   Installs `mod_cache`
# 
# @see https://httpd.apache.org/docs/current/mod/mod_cache.html for additional documentation.
#
class apache::mod::cache {
  ::apache::mod { 'cache': }
}
