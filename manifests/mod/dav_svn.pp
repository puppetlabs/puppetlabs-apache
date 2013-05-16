class apache::mod::dav_svn {
  require apache::mod::svn
  apache::mod { 'dav_svn': }
}
