# @summary
#   Installs and configures `mod_disk_cache`.
# 
# @param cache_root
#   Defines the name of the directory on the disk to contain cache files.
#   Default depends on the Apache version and operating system:
#   - Debian: /var/cache/apache2/mod_cache_disk
#   - FreeBSD: /var/cache/mod_cache_disk
#   - Red Hat, Apache 2.4: /var/cache/httpd/proxy
#   - Red Hat, Apache 2.2: /var/cache/mod_proxy
#
# @param cache_ignore_headers
#   Specifies HTTP header(s) that should not be stored in the cache.
#
# @note
#   Apache 2.2, mod_disk_cache installed. On Apache 2.4, mod_cache_disk installed.
#   This class is deprecated, use mode_cache_disk instead
#
# @see https://httpd.apache.org/docs/2.2/mod/mod_disk_cache.html for additional documentation on version 2.2.
#
# @see https://httpd.apache.org/docs/2.4/mod/mod_cache_disk.html for additional documentation on version 2.4.
#
class apache::mod::disk_cache (
  $cache_root                 = undef,
  $cache_ignore_headers       = undef,
) {
  deprecation('apache::mod::disk_cache','This module is deprecated; please use apache::mod::cache_disk')

  class { 'apache::mod::cache_disk':
    cache_root                 => $cache_root,
    cache_enable              => ['/'],
    cache_ignore_headers       => $cache_ignore_headers,
  }
}
