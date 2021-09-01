# needed by tests
package { 'curl':
  ensure => 'latest',
}

case $facts['os']['family'] {
  'SLES', 'SUSE': {
    # needed for netstat, for serverspec checks
    package { 'net-tools-deprecated':
      ensure => 'latest',
    }
  }
  'RedHat': {
    # Make sure selinux is disabled so the tests work.
    if $facts['os']['selinux']['enabled'] {
      exec { 'setenforce 0':
        path => $facts['path'],
      }
    }

    if $facts['selinux'] {
      $semanage_package = $facts['os']['release']['major'] ? {
        '6'     => 'policycoreutils-python',
        '7'     => 'policycoreutils-python',
        default => 'policycoreutils-python-utils',
      }
      package { $semanage_package:
        ensure => installed,
      }
    }

    if versioncmp($facts['os']['release']['major'], '8') >= 0 {
      package { 'iproute':
        ensure => installed,
      }
    }
    include epel
  }
  'Debian': {
    if $facts['os']['name'] == 'Debian' and versioncmp($facts['os']['release']['major'], '11') >= 0 {
      # Ensure ipv6 is enabled on our Debian 11 Docker boxes
      exec { 'sysctl -w net.ipv6.conf.all.disable_ipv6=0':
        path => $facts['path'],
      }
    }
  }
}
