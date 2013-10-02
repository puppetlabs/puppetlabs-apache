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
  $service_manage = true,
) {
  validate_bool($service_enable)
  validate_bool($service_manage)

  # Do we want to manage status of the service
  $manage = $service_manage ? {
    true  => $service_enable,
    false => undef,
  }

  service { 'httpd':
    ensure => $manage,
    name   => $apache::apache_name,
    enable => $service_enable,
  }
}
