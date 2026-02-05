# needed by tests
package { 'curl':
  ensure => 'latest',
}

case $facts['os']['family'] {
  'SLES', 'SUSE': {
    # TEMPORARY FIX: Add fallback repo for unregistered SLES systems
    # GCP BYOS images have zero repos configured, SUSEConnect doesn't work
    # Use version-appropriate repos: Leap 42.3 for SLES 12, Leap 15.6 for SLES 15
    if versioncmp($facts['os']['release']['major'], '15') >= 0 {
      $repo_url = 'http://download.opensuse.org/distribution/leap/15.6/repo/oss/'
    } else {
      # SLES 12 needs older repo with PHP 5 support
      $repo_url = 'http://download.opensuse.org/distribution/leap/42.3/repo/oss/'
    }

    exec { 'Configure zypper repo for SLES':
      path      => '/bin:/usr/bin:/sbin:/usr/sbin',
      command   => "zypper --non-interactive --gpg-auto-import-keys ar ${repo_url} opensuse-leap-fallback && zypper --non-interactive --gpg-auto-import-keys refresh",
      unless    => "zypper lr 2>/dev/null | grep -q 'opensuse-leap-fallback\\|http'",
      logoutput => true,
    }

    # needed for netstat, for serverspec checks
    package { 'net-tools-deprecated':
      ensure  => 'latest',
      require => Exec['Configure zypper repo for SLES'],
    }
  }
  'RedHat': {
    # Make sure selinux is disabled so the tests work.
    if $facts['os']['selinux']['enabled'] {
      exec { 'setenforce 0':
        path => $facts['path'],
      }
    }

    if $facts['os']['selinux']['enabled'] {
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
