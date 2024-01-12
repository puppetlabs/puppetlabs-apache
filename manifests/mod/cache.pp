# @summary
#   Installs `mod_cache`
#
# @param cache_ignore_headers
#   Specifies HTTP header(s) that should not be stored in the cache.
#
# @param cache_default_expire
#   The default duration to cache a document when no expiry date is specified.
#
# @param cache_max_expire
#   The maximum time in seconds to cache a document
#
# @param cache_ignore_no_lastmod
#   Ignore the fact that a response has no Last Modified header.
#
# @param cache_header
#   Add an X-Cache header to the response.
#
# @param cache_lock
#   Enable the thundering herd lock.
#
# @param cache_ignore_cache_control
#   Ignore request to not serve cached content to client
#
# @see https://httpd.apache.org/docs/current/mod/mod_cache.html for additional documentation.
#
class apache::mod::cache (
  Optional[String] $cache_ignore_headers                               = undef,
  Optional[Integer] $cache_default_expire                              = undef,
  Optional[Integer] $cache_max_expire                                  = undef,
  Optional[Enum['off', 'on', 'Off', 'On']] $cache_ignore_no_lastmod    = undef,
  Optional[Enum['off', 'on', 'Off', 'On']] $cache_header               = undef,
  Optional[Enum['off', 'on', 'Off', 'On']] $cache_lock                 = undef,
  Optional[Enum['off', 'on', 'Off', 'On']] $cache_ignore_cache_control = undef,
) {
  include apache
  ::apache::mod { 'cache': }

  $_configuration_file_name = 'cache.conf'

  file { $_configuration_file_name:
    ensure  => file,
    path    => "${apache::mod_dir}/${_configuration_file_name}",
    mode    => $apache::file_mode,
    content => epp('apache/mod/cache.conf.epp', {
        cache_ignore_headers       => $cache_ignore_headers,
        cache_default_expire       => $cache_default_expire,
        cache_max_expire           => $cache_max_expire,
        cache_ignore_no_lastmod    => $cache_ignore_no_lastmod,
        cache_header               => $cache_header,
        cache_lock                 => $cache_lock,
        cache_ignore_cache_control => $cache_ignore_cache_control,
    }),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
