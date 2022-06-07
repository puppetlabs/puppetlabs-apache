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
      }
      elsif ($facts['os']['name'] == 'Amazon' and $facts['os']['release']['major'] == '2') {
        $default = '2.4'
      } elsif $facts['os']['name'] == 'Fedora' or versioncmp($facts['os']['release']['major'], '7') >= 0 {
        $default = '2.4'
      } else {
        $default = '2.2'
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
      if ($facts['os']['name'] == 'SLES' and versioncmp($facts['os']['release']['major'], '12') >= 0) or ($facts['os']['name'] == 'OpenSuSE' and versioncmp($facts['os']['release']['major'], '42') >= 0) {
        $default = '2.4'
      } else {
        $default = '2.2'
      }
    }
    default: {
      fail("Class['apache::version']: Unsupported osfamily: ${$facts['os']['family']}")
    }
  }
}
