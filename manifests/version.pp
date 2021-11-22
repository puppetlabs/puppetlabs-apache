# @summary
#   Try to automatically detect the version by OS
#
# @api private
class apache::version (
  Optional[String] $scl_httpd_version = undef,
  Optional[String] $scl_php_version   = undef,
) {
  case $::osfamily {
    'RedHat': {
      if $scl_httpd_version {
        $default = $scl_httpd_version
      }
      elsif ($::operatingsystem == 'Amazon' and $::operatingsystemmajrelease == '2') {
        $default = '2.4'
      } elsif ($::operatingsystem == 'Fedora' and versioncmp($facts['operatingsystemmajrelease'], '18') >= 0) or ($::operatingsystem != 'Fedora' and versioncmp($facts['operatingsystemmajrelease'], '7') >= 0) {
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
      if ($::operatingsystem == 'SLES' and versioncmp($facts['operatingsystemmajrelease'], '12') >= 0) or ($::operatingsystem == 'OpenSuSE' and versioncmp($facts['operatingsystemmajrelease'], '42') >= 0) {
        $default = '2.4'
      } else {
        $default = '2.2'
      }
    }
    default: {
      fail("Class['apache::version']: Unsupported osfamily: ${::osfamily}")
    }
  }
}
