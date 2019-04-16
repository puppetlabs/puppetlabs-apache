
#
# @summary
#   This class enables and configures Apache mod_status
#
# See: http://httpd.apache.org/docs/current/mod/mod_status.html
#
# Parameters:
# @param allow_from is an array of hosts, ip addresses, partial network numbers
#   or networks in CIDR notation specifying what hosts can view the special
#   /server-status URL.  Defaults to ['127.0.0.1', '::1'].
#   > Creates Apache < 2.4 directive "Allow from"
# @param requires is either a:
#   - String with:
#     - '' or 'unmanaged' - Host auth control done elsewhere
#     - 'ip <List of IPs>' - Allowed IPs/ranges
#     - 'host <List of names>' - Allowed names/domains
#     - 'all [granted|denied]'
#   - Array of strings with ip or host as above
#   - Hash with following keys:
#     - 'requires' - Value => Array as above
#     - 'enforce' - Value => String 'Any', 'All' or 'None'
#       This encloses "Require" directives in "<Require(Any|All|None)>" block
#       Optional - If unspecified, "Require" directives follow current flow
#   > Creates Apache >= 2.4 directives "Require"
# @param extended_status track and display extended status information. Valid
#   values are 'On' or 'Off'.  Defaults to 'On'.
# @param status_path is the path assigned to the Location directive which
#   defines the URL to access the server status. Defaults to '/server-status'.
# @param apache_version
#
# Actions:
# - Enable and configure Apache mod_status
#
# Requires:
# - The apache class
#
# Sample Usage:
#
#  # Simple usage allowing access from localhost and a private subnet
#  class { 'apache::mod::status':
#    $allow_from => ['127.0.0.1', '10.10.10.10/24'],
#  }
#
class apache::mod::status (
  Optional[Array] $allow_from                      = undef,
  Optional[Variant[String, Array, Hash]] $requires = undef,
  Enum['On', 'Off', 'on', 'off'] $extended_status  = 'On',
  $apache_version                                  = undef,
  $status_path                                     = '/server-status',
) inherits ::apache::params {

  include ::apache
  $_apache_version = pick($apache_version, $apache::apache_version)
  ::apache::mod { 'status': }

  # Defaults for "Allow from" or "Require" directives
  $allow_defaults = ['127.0.0.1','::1']
  $requires_defaults = 'ip 127.0.0.1 ::1'

  # Template uses $allow_from, $extended_status, $_apache_version, $status_path
  file { 'status.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/status.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/status.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
