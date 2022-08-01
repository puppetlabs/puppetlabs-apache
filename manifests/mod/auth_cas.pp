# @summary
#   Installs and configures `mod_auth_cas`.
# 
# @param cas_login_url
#   Sets the URL to which the module redirects users when they attempt to access a 
#   CAS-protected resource and don't have an active session.
# 
# @param cas_validate_url
#   Sets the URL to use when validating a client-presented ticket in an HTTP query string.
# 
# @param cas_cookie_path
#   Sets the location where information on the current session should be stored. This should
#   be writable by the web server only.
# 
# @param cas_cookie_path_mode
#   The mode of cas_cookie_path.
#
# @param cas_version
#   The version of the CAS protocol to adhere to.
# 
# @param cas_debug
#   Whether to enable or disable debug mode.
# 
# @param cas_validate_server
#   Whether to validate the presented certificate. This has been deprecated and
#   removed from Version 1.1-RC1 onward.
# 
# @param cas_validate_depth
#   The maximum depth for chained certificate validation.
#
# @param cas_certificate_path
#   The path leading to the certificate
# 
# @param cas_proxy_validate_url
#   The URL to use when performing a proxy validation.
# 
# @param cas_root_proxied_as
#   Sets the URL end users see when access to this Apache server is proxied per vhost. 
#   This URL should not include a trailing slash.
# 
# @param cas_cookie_entropy
#   When creating a local session, this many random bytes are used to create a unique 
#   session identifier.
# 
# @param cas_timeout
#   The hard limit, in seconds, for a mod_auth_cas session.
# 
# @param cas_idle_timeout
#   The limit, in seconds, of how long a mod_auth_cas session can be idle.
# 
# @param cas_cache_clean_interval
#   The minimum amount of time that must pass inbetween cache cleanings.
# 
# @param cas_cookie_domain
#   The value for the 'Domain=' parameter in the Set-Cookie header.
# 
# @param cas_cookie_http_only
#   Setting this flag prevents the mod_auth_cas cookies from being accessed by 
#   client side Javascript.
# 
# @param cas_authoritative
#   Determines whether an optional authorization directive is authoritative and thus binding.
# 
# @param cas_validate_saml
#   Parse response from CAS server for SAML.
# 
# @param cas_sso_enabled
#   Enables experimental support for single sign out (may mangle POST data).
# 
# @param cas_attribute_prefix
#   Adds a header with the value of this header being the attribute values when SAML 
#   validation is enabled.
# 
# @param cas_attribute_delimiter
#   Sets the delimiter between attribute values in the header created by `cas_attribute_prefix`.
# 
# @param cas_scrub_request_headers
#   Remove inbound request headers that may have special meaning within mod_auth_cas.
# 
# @param suppress_warning
#   Suppress warning about being on RedHat (mod_auth_cas package is now available in epel-testing repo).
#
# @note The auth_cas module isn't available on RH/CentOS without providing dependency packages provided by EPEL.
#
# @see https://github.com/apereo/mod_auth_cas for additional documentation.
#
class apache::mod::auth_cas (
  String $cas_login_url,
  String $cas_validate_url,
  String $cas_cookie_path                     = $apache::params::cas_cookie_path,
  Stdlib::Filemode $cas_cookie_path_mode      = '0750',
  Integer $cas_version                        = 2,
  String $cas_debug                           = 'Off',
  Optional[String] $cas_validate_server       = undef,
  Optional[String] $cas_validate_depth        = undef,
  Optional[String] $cas_certificate_path      = undef,
  Optional[String] $cas_proxy_validate_url    = undef,
  Optional[String] $cas_root_proxied_as       = undef,
  Optional[String] $cas_cookie_entropy        = undef,
  Optional[String] $cas_timeout               = undef,
  Optional[String] $cas_idle_timeout          = undef,
  Optional[String] $cas_cache_clean_interval  = undef,
  Optional[String] $cas_cookie_domain         = undef,
  Optional[String] $cas_cookie_http_only      = undef,
  Optional[String] $cas_authoritative         = undef,
  Optional[String] $cas_validate_saml         = undef,
  Optional[String] $cas_sso_enabled           = undef,
  Optional[String] $cas_attribute_prefix      = undef,
  Optional[String] $cas_attribute_delimiter   = undef,
  Optional[String] $cas_scrub_request_headers = undef,
  Boolean $suppress_warning                   = false,
) inherits apache::params {
  if $facts['os']['family'] == 'RedHat' and ! $suppress_warning {
    warning('RedHat distributions do not have Apache mod_auth_cas in their default package repositories.')
  }

  include apache
  ::apache::mod { 'auth_cas': }

  file { $cas_cookie_path:
    ensure => directory,
    before => File['auth_cas.conf'],
    mode   => $cas_cookie_path_mode,
    owner  => $apache::user,
    group  => $apache::group,
  }

  # Template uses
  # - All variables beginning with cas_
  file { 'auth_cas.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/auth_cas.conf",
    mode    => $apache::file_mode,
    content => template('apache/mod/auth_cas.conf.erb'),
    require => [Exec["mkdir ${apache::mod_dir}"],],
    before  => File[$apache::mod_dir],
    notify  => Class['Apache::Service'],
  }
}
