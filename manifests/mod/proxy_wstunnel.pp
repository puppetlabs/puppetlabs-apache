class apache::mod::proxy_wstunnel (
  $apache_version  = $::apache::apache_version,
) {
  if versioncmp($apache_version, '2.4') >= 0 {
    Class['::apache::mod::proxy'] -> Class['::apache::mod::proxy_wstunnel']
    ::apache::mod { 'proxy_wstunnel': }
  }
}
