class apache::mod::proxy_wstunnel (
  $apache_version = $::apache::apache_version,
) {
  # including this class is a no-op for versions without the module
  if versioncmp($apache_version, '2.4') >= 0 {
    Class['::apache::mod::proxy_http'] -> Class['::apache::mod::proxy_wstunnel']
    ::apache::mod { 'proxy_wstunnel': }
  }
}
