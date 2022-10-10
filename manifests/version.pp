# @summary
#   Try to automatically detect the version by OS
#
# @api private
class apache::version (
  Optional[String] $scl_httpd_version = undef,
  Optional[String] $scl_php_version   = undef,
) {
}
