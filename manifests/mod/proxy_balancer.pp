# @summary
#   Installs and configures `mod_proxy_balancer`.
# 
# @param manager
#   Toggle whether to enable balancer manager support.
#
# @param maanger_path
#   Server relative path to balancer manager.
#
# @param allow_from
#   List of IPs from which the balancer manager can be accessed.
#
# @param apache_version
#   Version of Apache to install module on.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_balancer.html for additional documentation.
#
class apache::mod::proxy_balancer(
  Boolean $manager                   = false,
  Stdlib::Absolutepath $manager_path = '/balancer-manager',
  Array $allow_from                  = ['127.0.0.1','::1'],
  $apache_version                    = $::apache::apache_version,
) {

  include ::apache::mod::proxy
  include ::apache::mod::proxy_http
  if versioncmp($apache_version, '2.4') >= 0 {
    ::apache::mod { 'slotmem_shm': }
  }

  Class['::apache::mod::proxy'] -> Class['::apache::mod::proxy_balancer']
  Class['::apache::mod::proxy_http'] -> Class['::apache::mod::proxy_balancer']
  ::apache::mod { 'proxy_balancer': }
  if $manager {
    include ::apache::mod::status
    file { 'proxy_balancer.conf':
      ensure  => file,
      path    => "${::apache::mod_dir}/proxy_balancer.conf",
      mode    => $::apache::file_mode,
      content => template('apache/mod/proxy_balancer.conf.erb'),
      require => Exec["mkdir ${::apache::mod_dir}"],
      before  => File[$::apache::mod_dir],
      notify  => Class['apache::service'],
    }
  }
}
