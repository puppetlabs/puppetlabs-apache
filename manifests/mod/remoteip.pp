# @summary Setup and load Apache `mod_remoteip`
#
# @see https://httpd.apache.org/docs/current/mod/mod_remoteip.html
#
# @param header
#   The header field in which `mod_remoteip` will look for the useragent IP.
#
# @param internal_proxy
#   A list of IP addresses, IP blocks or hostname that are trusted to set a
#   valid value inside specified header. Unlike the `$trusted_proxy_ips`
#   parameter, any IP address (including private addresses) presented by these
#   proxies will trusted by `mod_remoteip`.
#
# @param proxy_ips
#   *Deprecated*: use `$internal_proxy` instead.
#
# @param proxies_header
#   A header into which `mod_remoteip` will collect a list of all of the
#   intermediate client IP addresses trusted to resolve the useragent IP of the
#   request (e.g. `X-Forwarded-By`).
#
# @param trusted_proxy
#   A list of IP addresses, IP blocks or hostname that are trusted to set a
#   valid value inside the specified header. Unlike the `$proxy_ips` parameter,
#   any private IP presented by these proxies will be disgarded by
#   `mod_remoteip`.
#
# @param trusted_proxy_ips
#   *Deprecated*: use `$trusted_proxy` instead.
#
# @param apache_version
#   A version string used to validate that your apache version supports
#   `mod_remoteip`. If not specified, `$::apache::apache_version` is used.
#
class apache::mod::remoteip (
  String                        $header            = 'X-Forwarded-For',
  Optional[Array[Stdlib::Host]] $internal_proxy    = undef,
  Optional[Array[Stdlib::Host]] $proxy_ips         = undef,
  Optional[String]              $proxies_header    = undef,
  Optional[Array[Stdlib::Host]] $trusted_proxy     = undef,
  Optional[Array[Stdlib::Host]] $trusted_proxy_ips = undef,
  Optional[String]              $apache_version    = undef,
) {
  include ::apache
  $_apache_version = pick($apache_version, $apache::apache_version)
  if versioncmp($_apache_version, '2.4') < 0 {
    fail('mod_remoteip is only available in Apache 2.4')
  }

  if $proxy_ips {
    deprecation('apache::mod::remoteip::proxy_ips', 'This parameter is deprecated, please use `internal_proxy`.')
    $_internal_proxy = $proxy_ips
  } elsif $internal_proxy {
    $_internal_proxy = $internal_proxy
  } else {
    $_internal_proxy = ['127.0.0.1']
  }

  if $trusted_proxy_ips {
    deprecation('apache::mod::remoteip::trusted_proxy_ips', 'This parameter is deprecated, please use `trusted_proxy`.')
    $_trusted_proxy = $trusted_proxy_ips
  } else {
    $_trusted_proxy = $trusted_proxy
  }

  ::apache::mod { 'remoteip': }

  $template_parameters = {
    header                    => $header,
    internal_proxy            => $_internal_proxy,
    proxies_header            => $proxies_header,
    trusted_proxy             => $_trusted_proxy,
  }

  file { 'remoteip.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/remoteip.conf",
    mode    => $::apache::file_mode,
    content => epp('apache/mod/remoteip.conf.epp', $template_parameters),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
