# @summary
#   Installs and configures `mod_disk_cache`.
# 
# @param cache_root
#   Defines the name of the directory on the disk to contain cache files.
#   Default depends on the Apache version and operating system:
#   - Debian: /var/cache/apache2/mod_cache_disk
#   - FreeBSD: /var/cache/mod_cache_disk
#
# @param cache_ignore_headers
#   Specifies HTTP header(s) that should not be stored in the cache.
#
# @param default_cache_enable
#   Default value is true, which enables "CacheEnable disk /" in disk_cache.conf for the webserver. This would cache
#   every request to apache by default for every vhost. If set to false the default cache all behaviour is supressed.
#   You can then control this behaviour in individual vhosts by explicitly defining CacheEnable.
#
# @note
#   Apache 2.2, mod_disk_cache installed. On Apache 2.4, mod_cache_disk installed.
#   This class is deprecated, use mode_cache_disk instead
#
# @see https://httpd.apache.org/docs/2.4/mod/mod_cache_disk.html for additional documentation on version 2.4.
#
class apache::mod::disk_cache (
  Optional[Stdlib::Absolutepath] $cache_root = undef,
  Optional[String] $cache_ignore_headers     = undef,
  Boolean $default_cache_enable              = true,
) {
  deprecation('apache::mod::disk_cache', 'This module is deprecated; please use apache::mod::cache_disk')

  class { 'apache::mod::cache_disk':
    cache_root              => $cache_root,
    cache_enable            => ['/'],
    cache_ignore_headers    => $cache_ignore_headers,
    cache_dir_length        => 1,
    cache_dir_levels        => 2,
    configuration_file_name => 'cache_disk.conf'
  }
}
