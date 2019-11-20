# @summary
#   Installs and configures `mod_proxy`.
# 
# @param proxy_requests
#   Enables forward (standard) proxy requests.
# 
# @param allow_from
#   List of IPs allowed to access proxy.
# 
# @param apache_version
#   Used to verify that the Apache version you have requested is compatible with the module.
# 
# @param package_name
#   Name of the proxy package to install.
# 
# @param proxy_via
#   Set local IP address for outgoing proxy connections.
# 
# @param proxy_timeout
#   Network timeout for proxied requests.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_proxy.html for additional documentation.
#
class apache::mod::proxy (
  $proxy_requests = 'Off',
  $allow_from     = undef,
  $apache_version = undef,
  $package_name   = undef,
  $proxy_via      = 'On',
  $proxy_timeout  = $apache::timeout,
) {
  include ::apache
  $_apache_version = pick($apache_version, $apache::apache_version)
  ::apache::mod { 'proxy':
    package => $package_name,
  }
  # Template uses $proxy_requests, $_apache_version
  file { 'proxy.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/proxy.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/proxy.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
