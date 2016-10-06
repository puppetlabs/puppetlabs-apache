class apache::mod::proxy_balancer(
  $apache_version = $::apache::apache_version,
) {

  include ::apache::mod::proxy
  include ::apache::mod::proxy_http
  if versioncmp($apache_version, '2.4') >= 0 {
    ::apache::mod { 'slotmem_shm': }
  }

  Class['::apache::mod::proxy'] -> Class['::apache::mod::proxy_balancer']
  Class['::apache::mod::proxy_http'] -> Class['::apache::mod::proxy_balancer']
  ::apache::mod { 'proxy_balancer': }

}
