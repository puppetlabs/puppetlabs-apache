# @summary
#   Installs and configures `mod_cache_disk`.
#
# @description
#   This will install an configure the proper module depending on the used apache version, so
#   - mod_cache_disk for apache version >= 2.4
#   - mod_disk_cache for older apache versions
# 
# @param cache_root
#   Defines the name of the directory on the disk to contain cache files.
#   Default depends on the Apache version and operating system:
#   - Debian: /var/cache/apache2/mod_cache_disk
#   - FreeBSD: /var/cache/mod_cache_disk
#   - Red Hat, Apache 2.4: /var/cache/httpd/proxy
#
# @param cache_enable
#   Defines an array of directories to cache, the default is none

# @param cache_dir_length
#   The number of characters in subdirectory names
#
# @param cache_dir_levels
#   The number of levels of subdirectories in the cache.
#
# @param cache_max_filesize
#   The maximum size (in bytes) of a document to be placed in the cache
#
# @param cache_ignore_headers
#   DEPRECATED Ignore request to not serve cached content to client (included for compatibility reasons to support disk_cache)
#
# @param configuration_file_name
#   DEPRECATED Name of module configuration file (used for the compatibility layer for disk_cache)
#
# @note
#   Apache 2.2, mod_disk_cache installed. On Apache 2.4, mod_cache_disk installed.
#
# @see https://httpd.apache.org/docs/2.4/mod/mod_cache_disk.html
#
class apache::mod::cache_disk (
  Optional[Stdlib::Absolutepath] $cache_root              = undef,
  Array[String] $cache_enable               = [],
  Optional[Integer] $cache_dir_length       = undef,
  Optional[Integer] $cache_dir_levels       = undef,
  Optional[Integer] $cache_max_filesize     = undef,
  Optional[String] $cache_ignore_headers    = undef,
  Optional[String] $configuration_file_name = undef,
) {
  include apache

  if $cache_ignore_headers {
    deprecation(
      'apache::mod::cache_disk',
      'The parameter cache_ignore_headers is deprecated. Please use apache::mod::cache::cache_ignore_headers instead.'
    )
  }

  $_cache_root = $cache_root ? {
    undef   => $facts['os']['family'] ? {
      'debian'  => '/var/cache/apache2/mod_cache_disk',
      'redhat'  => '/var/cache/httpd/proxy',
      'freebsd' => '/var/cache/mod_cache_disk',
    },
    default => $cache_root,
  }
  $_configuration_file_name = $configuration_file_name ? {
    undef   => 'cache_disk.conf',
    default => $configuration_file_name
  }
  $_class_name = 'apache::mod::cache_disk'

  apache::mod { 'cache_disk': }

  Class['apache::mod::cache'] -> Class[$_class_name]

  file { $_configuration_file_name:
    ensure  => file,
    path    => "${apache::mod_dir}/${_configuration_file_name}",
    mode    => $apache::file_mode,
    content => epp('apache/mod/cache_disk.conf.epp', {
        cache_root           => $_cache_root,
        cache_enable         => $cache_enable,
        cache_dir_length     => $cache_dir_length,
        cache_dir_levels     => $cache_dir_levels,
        cache_max_filesize   => $cache_max_filesize,
        cache_ignore_headers => $cache_ignore_headers,
    }),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
