# @summary
#   Installs and configures `mod_geoip`.
# 
# @param enable
#   Toggles whether to enable geoip.
#
# @param db_file
#   Path to database for GeoIP to use.
# 
# @param flag
#   Caching directive to use. Values: 'CheckCache', 'IndexCache', 'MemoryCache', 'Standard'.
# 
# @param output
#   Output variable locations. Values: 'All', 'Env', 'Request', 'Notes'.
# 
# @param enable_utf8
#   Changes the output from ISO88591 (Latin1) to UTF8.
# 
# @param scan_proxy_headers
#   Enables the GeoIPScanProxyHeaders option.
# 
# @param scan_proxy_headers_field
#   Specifies the header mod_geoip uses to determine the client's IP address.
# 
# @param use_last_xforwarededfor_ip
#   Determines whether to use the first or last IP address for the client's IP in a comma-separated list of IP addresses is found.
# 
# @see https://dev.maxmind.com/geoip/legacy/mod_geoip2 for additional documentation.
#
class apache::mod::geoip (
  $enable                     = false,
  $db_file                    = '/usr/share/GeoIP/GeoIP.dat',
  $flag                       = 'Standard',
  $output                     = 'All',
  $enable_utf8                = undef,
  $scan_proxy_headers         = undef,
  $scan_proxy_header_field    = undef,
  $use_last_xforwarededfor_ip = undef,
) {
  include ::apache
  ::apache::mod { 'geoip': }

  # Template uses:
  # - enable
  # - db_file
  # - flag
  # - output
  # - enable_utf8
  # - scan_proxy_headers
  # - scan_proxy_header_field
  # - use_last_xforwarededfor_ip
  file { 'geoip.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/geoip.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/geoip.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }

}
