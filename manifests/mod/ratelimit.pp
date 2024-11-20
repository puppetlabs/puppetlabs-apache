# @summary
#   Installs Apache mod_ratelimit
# 
# @see https://httpd.apache.org/docs/2.4/mod/mod_ratelimit.html for additional documentation.
#
class apache::mod::ratelimit {
  apache::mod { 'ratelimit': }
}
