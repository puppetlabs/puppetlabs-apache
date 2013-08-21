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
) {
  validate_bool($service_enable)

  service { 'httpd':
    ensure => $service_enable,
    name   => $apache::apache_name,
    enable => $service_enable,
  }
}
