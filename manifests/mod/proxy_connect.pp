class apache::mod::proxy_connect (
  $apache_version  = undef,
) {
  include ::apache
  $_apache_version = pick($apache_version, $apache::apache_version)
  Class['::apache::mod::proxy'] -> Class['::apache::mod::proxy_connect']
  ::apache::mod { 'proxy_connect': }
}
