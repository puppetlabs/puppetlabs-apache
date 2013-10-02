# Class: apache::service
#
# Manages the Apache daemon
#
# Parameters:
#
# Actions:
#   - Manage Apache service
#
# Requires:
#
# Sample Usage:
#
#    sometype { 'foo':
#      notify => Class['apache::service],
#    }
#
#
class apache::service (
  $service_enable = true,
  $service_ensure = 'running',
) {
  validate_bool($service_enable)

  service { 'httpd':
    ensure => $service_ensure,
    name   => $apache::apache_name,
    enable => $service_enable,
  }
}
