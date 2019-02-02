# @summary Setup and load Apache `mod_remoteip`
#
# @see https://httpd.apache.org/docs/current/mod/mod_remoteip.html
#
# @param header
#   The header field in which `mod_remoteip` will look for the useragent IP.
#
# @param proxy_ips
#   A list of IP addresses, IP blocks or hostname that are trusted to set a
#   valid value inside specified header. Unlike the `$trusted_proxy_ips`
#   parameter, any IP address (including private addresses) presented by these
#   proxies will trusted by `mod_remoteip`.
#
# @param proxies_header
#   A header into which `mod_remoteip` will collect a list of all of the
#   intermediate client IP addresses trusted to resolve the useragent IP of the
#   request (e.g. `X-Forwarded-By`).
#
# @param trusted_proxy_ips
#   A list of IP addresses, IP blocks or hostname that are trusted to set a
#   valid value inside the specified header. Unlike the `$proxy_ips` parameter,
#   any private IP presented by these proxies will be disgarded by
#   `mod_remoteip`.
#
# @param apache_version
#   A version string used to validate that your apache version supports
#   `mod_remoteip`. If not specified, `$::apache::apache_version` is used.
#
class apache::mod::remoteip (
  String                        $header            = 'X-Forwarded-For',
  Optional[Array[Stdlib::Host]] $proxy_ips         = [ '127.0.0.1' ],
  Optional[String]              $proxies_header    = undef,
  Optional[Array[Stdlib::Host]] $trusted_proxy_ips = undef,
  Optional[String]              $apache_version    = undef,
) {
  include ::apache
  $_apache_version = pick($apache_version, $apache::apache_version)
  if versioncmp($_apache_version, '2.4') < 0 {
    fail('mod_remoteip is only available in Apache 2.4')
  }

  ::apache::mod { 'remoteip': }

  # Template uses:
  # - $header
  # - $proxy_ips
  # - $proxies_header
  # - $trusted_proxy_ips
  file { 'remoteip.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/remoteip.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/remoteip.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
