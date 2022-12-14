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
# @param default_cache_enable
#   Default value is true, which enables "CacheEnable disk /" in disk_cache.conf for the webserver. This would cache
#   every request to apache by default for every vhost. If set to false the default cache all behaviour is supressed.
#   You can then control this behaviour in individual vhosts by explicitly defining CacheEnable.
#
# @note
#   Apache 2.2, mod_disk_cache installed. On Apache 2.4, mod_cache_disk installed.
#
# @see https://httpd.apache.org/docs/2.2/mod/mod_disk_cache.html for additional documentation.
#
class apache::mod::disk_cache (
  Optional[Stdlib::Absolutepath] $cache_root = undef,
  Optional[String] $cache_ignore_headers     = undef,
  Boolean $default_cache_enable              = true,
) {
  include apache
  if $cache_root {
    $_cache_root = $cache_root
  } else {
    $_cache_root = $facts['os']['family'] ? {
      'debian'  => '/var/cache/apache2/mod_cache_disk',
      'redhat'  => '/var/cache/httpd/proxy',
      'freebsd' => '/var/cache/mod_cache_disk',
    }
  }

  apache::mod { 'cache_disk': }

  Class['apache::mod::cache'] -> Class['apache::mod::disk_cache']

  # Template uses $_cache_root
  file { 'disk_cache.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/disk_cache.conf",
    mode    => $apache::file_mode,
    content => template('apache/mod/disk_cache.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
