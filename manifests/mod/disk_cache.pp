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
# @param cache_dir_length
#   The number of characters in subdirectory names
#
# @param cache_dir_levels
#   The number of levels of subdirectories in the cache.
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
# @param cache_max_filesize
#   The maximum size (in bytes) of a document to be placed in the cache
#
# @note
#   Apache 2.2, mod_disk_cache installed. On Apache 2.4, mod_cache_disk installed.
#
# @see https://httpd.apache.org/docs/2.2/mod/mod_disk_cache.html for additional documentation on version 2.2.
#
# @see https://httpd.apache.org/docs/2.4/mod/mod_cache_disk.html for additional documentation on version 2.4.
#
class apache::mod::disk_cache (
  $cache_root                 = undef,
  $cache_ignore_headers       = undef,
  $cache_dir_length           = undef,
  $cache_dir_levels           = undef,
  $cache_default_expire       = undef,
  $cache_max_expire           = undef,
  $cache_ignore_no_lastmod    = undef,
  $cache_header               = undef,
  $cache_lock                 = undef,
  $cache_ignore_cache_control = undef,
  $cache_max_filesize         = undef,
) {
  include apache
  if $cache_root {
    $_cache_root = $cache_root
  }
  elsif versioncmp($apache::apache_version, '2.4') >= 0 {
    $_module_name = 'cache_disk'
    $_cache_root = $::osfamily ? {
      'debian'  => '/var/cache/apache2/mod_cache_disk',
      'redhat'  => '/var/cache/httpd/proxy',
      'freebsd' => '/var/cache/mod_cache_disk',
    }
  }
  else {
    $_module_name = 'disk_cache'
    $_cache_root = $::osfamily ? {
      'debian'  => '/var/cache/apache2/mod_disk_cache',
      'redhat'  => '/var/cache/mod_proxy',
      'freebsd' => '/var/cache/mod_disk_cache',
    }
  }
  $_configuration_file_name = "${_module_name}.conf"
  $_class_name = "::apache::mod::${_module_name}"

  apache::mod { $_module_name: }

  Class['::apache::mod::cache'] -> Class[$_class_name]

  # Template uses
  # - $_cache_root
  # - $cache_dir_length
  # - $cache_ignore_headers
  # - $cache_dir_length
  # - $cache_dir_levels
  # - $cache_default_expire
  # - $cache_max_expire
  # - $cache_ignore_no_lastmod
  # - $cache_header
  # - $cache_lock
  # - $cache_ignore_cache_control
  # - $cache_max_filesize
  file { 'disk_cache.conf':

    ensure  => file,
    path    => "${apache::mod_dir}/${_configuration_file_name}",
    mode    => $apache::file_mode,
    content => template('apache/mod/disk_cache.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
