# @summary
#   Installs and configures `mod_status`.
#
# @param requires
#   A Variant type that can be:
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
#
# @param extended_status
#   Determines whether to track extended status information for each request, via the ExtendedStatus directive.
#
# @param status_path 
#   Path assigned to the Location directive which defines the URL to access the server status.
#
# @example
#   # Simple usage allowing access from localhost and a private subnet
#   class { 'apache::mod::status':
#     $requires => 'ip 127.0.0.1 ::1 10.10.10.10/24',
#   }
#
# @see http://httpd.apache.org/docs/current/mod/mod_status.html for additional documentation.
#
class apache::mod::status (
  Optional[Variant[String, Array, Hash]] $requires = undef,
  Enum['On', 'Off', 'on', 'off'] $extended_status  = 'On',
  String $status_path                              = '/server-status',
) inherits apache::params {
  include apache
  ::apache::mod { 'status': }

  $requires_defaults = 'ip 127.0.0.1 ::1'

  # Template uses $extended_status, $status_path
  file { 'status.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/status.conf",
    mode    => $apache::file_mode,
    content => template('apache/mod/status.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
