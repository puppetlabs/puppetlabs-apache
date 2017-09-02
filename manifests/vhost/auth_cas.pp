
define apache::vhost::auth_cas (
  $cas_attribute_prefix                                                             = undef,
  $cas_attribute_delimiter                                                          = undef,
  $cas_scrub_request_headers                                                        = undef,
  $cas_sso_enabled                                                                  = undef,
  $cas_login_url                                                                    = undef,
  $cas_validate_url                                                                 = undef,
  $cas_validate_saml                                                                = undef,
  $cas_authoritative                                                                = undef,
  $cas_cache_clean_interval                                                         = undef,
  $cas_certificate_path                                                             = undef,
  $cas_cookie_domain                                                                = undef,
  $cas_cookie_entropy                                                               = undef,
  $cas_cookie_http_only                                                             = undef,
  $cas_cookie_path                                                                  = undef,
  $cas_debug                                                                        = undef,
  $cas_idle_timeout                                                                 = undef,
  $cas_proxy_validate_url                                                           = undef,
  $cas_root_proxied_as                                                              = undef,
  $cas_timeout                                                                      = undef,
  $cas_validate_depth                                                               = undef,
  $cas_version                                                                      = undef,
  Optional[String] $vhost                                                           = $name,
) {

  # Is the cas module loaded, and are any cas parameters provided?
  $cas_enabled = defined(Apache::Mod['auth_cas']) and (
                  $cas_attribute_prefix or $cas_attribute_delimiter
                  or $cas_scrub_request_headers or $cas_sso_enabled
                  or $cas_login_url or $cas_validate_url or $cas_validate_saml
                  or $cas_authoritative or $cas_cache_clean_interval
                  or $cas_certificate_path or $cas_cookie_domain
                  or $cas_cookie_entropy or $cas_cookie_http_only
                  or $cas_cookie_path or $cas_debug or $cas_idle_timeout
                  or $cas_proxy_validate_url or $cas_root_proxied_as
                  or $cas_timeout or $cas_validate_depth or $cas_version)

  # Template uses:
  # - $cas_attribute_delimiter
  # - $cas_attribute_prefix
  # - $cas_authoritative
  # - $cas_cache_clean_interval
  # - $cas_certificate_path
  # - $cas_cookie_domain
  # - $cas_cookie_entropy
  # - $cas_cookie_http_only
  # - $cas_cookie_path
  # - $cas_debug
  # - $cas_enabled
  # - $cas_idle_timeout
  # - $cas_login_url
  # - $cas_proxy_validate_url
  # - $cas_root_proxied_as
  # - $cas_scrub_request_headers
  # - $cas_sso_enabled
  # - $cas_timeout
  # - $cas_validate_depth
  # - $cas_validate_saml
  # - $cas_validate_url
  # - $cas_version
  if $cas_enabled {
    concat::fragment { "${vhost}-auth_cas":
      target  => "apache::vhost::${vhost}",
      order   => 350,
      content => template('apache/vhost/_auth_cas.erb'),
    }
  }
}
