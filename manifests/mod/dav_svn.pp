class apache::mod::dav_svn {
  require apache::mod::dav
  apache::mod { 'dav_svn': }
}
