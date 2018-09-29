# Class: apache::version
#
# Try to automatically detect the version by OS
#
class apache::version {
  # This will be 5 or 6 on RedHat, 6 or wheezy on Debian, 12 or quantal on Ubuntu, etc.
  $osr_array = split($::operatingsystemrelease,'[\/\.]')
  $distrelease = $osr_array[0]
  if ! $distrelease {
    fail("Class['apache::version']: Unparsable \$::operatingsystemrelease: ${::operatingsystemrelease}")
  }

  case $::osfamily {
    'RedHat','Debian','FreeBSD','Gentoo','Suse': {
      $default = '2.4'
    }
    default: {
      fail("Class['apache::version']: Unsupported osfamily: ${::osfamily}")
    }
  }
}
