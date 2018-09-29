class apache::mod::disk_cache (
  $cache_root           = undef,
  $cache_ignore_headers = undef,
) {
  include ::apache
  if $cache_root {
    $_cache_root = $cache_root
  }
  else {
    $_cache_root = $::osfamily ? {
      'debian'  => '/var/cache/apache2/mod_cache_disk',
      'redhat'  => '/var/cache/httpd/proxy',
      'freebsd' => '/var/cache/mod_cache_disk',
    }
  }

  apache::mod { 'cache_disk': }

  Class['::apache::mod::cache'] -> Class['::apache::mod::disk_cache']

  # Template uses $_cache_root
  file { 'disk_cache.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/disk_cache.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/disk_cache.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
