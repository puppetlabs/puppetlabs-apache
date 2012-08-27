class apache::mod::dav_fs {
  Class['apache::mod::dav'] -> Class['apache::mod::dav_fs']
  apache::mod { 'dav_fs': }
}
