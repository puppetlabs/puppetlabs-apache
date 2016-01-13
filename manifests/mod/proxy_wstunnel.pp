class apache::mod::proxy_wstunnel {
  Class['::apache::mod::proxy_http'] -> Class['::apache::mod::proxy_wstunnel']
  ::apache::mod { 'proxy_wstunnel': }
}
