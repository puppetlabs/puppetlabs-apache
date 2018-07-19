# @summary
#   Try to automatically detect the version by OS
#
# @api private
class apache::version (
  Optional[String] $scl_httpd_version = undef,
  Optional[String] $scl_php_version   = undef,
) {
  case $facts['os']['family'] {
    'RedHat': {
      if $scl_httpd_version {
        $default = $scl_httpd_version
      } else {
        $default = '2.4'
      }
    }
    'Debian': {
      $default = '2.4'
    }
    'FreeBSD': {
      $default = '2.4'
    }
    'Gentoo': {
      $default = '2.4'
    }
    'Suse': {
      $default = '2.4'
    }
    default: {
      fail("Class['apache::version']: Unsupported osfamily: ${$facts['os']['family']}")
    }
  }
}
