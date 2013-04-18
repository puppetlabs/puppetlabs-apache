class apache::mod::dav_fs {
  Class['apache::mod::dav'] -> Class['apache::mod::dav_fs']
  apache::mod { 'dav_fs': }
  if $apache_version =~ /^2\.4/ {
    apache::mod { 'dav_lock': }
  }
}
