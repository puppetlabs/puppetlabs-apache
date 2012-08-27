class apache::mod::disk_cache (
  $cache_root = '/var/cache/mod_proxy'
) {
  Class['apache::mod::proxy'] -> Class['apache::mod::disk_cache']
  Class['apache::mod::cache'] -> Class['apache::mod::disk_cache']

  apache::mod { 'disk_cache': }
  # Template uses $cache_proxy
  file { "${apache::params::vdir}/disk_cache.conf":
    ensure  => present,
    content => template('apache/mod/disk_cache.conf.erb'),
  }
}
