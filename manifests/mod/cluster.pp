# @summary
#   Installs `mod_cluster`.
# 
# @param allowed_network
#   Balanced members network.
# 
# @param balancer_name
#   Name of balancer.
# 
# @param ip
#   Specifies the IP address to listen to.
# 
# @param version
#   Specifies the mod_cluster version. Version 1.3.0 or greater is required for httpd 2.4.
#
# @param enable_mcpm_receive
#   Whether MCPM should be enabled.
#   
# @param port
#   mod_cluster listen port.
#
# @param keep_alive_timeout
#   Specifies how long Apache should wait for a request, in seconds.
# 
# @param manager_allowed_network
#   Whether to allow the network to access the mod_cluster_manager.
# 
# @param max_keep_alive_requests
#   Maximum number of requests kept alive.
# 
# @param server_advertise
#   Whether the server should advertise.
# 
# @param advertise_frequency
#   Sets the interval between advertise messages in seconds.
#
# @example
#   class { '::apache::mod::cluster':
#     ip                      => '172.17.0.1',
#     allowed_network         => '172.17.0.',
#     balancer_name           => 'mycluster',
#     version                 => '1.3.1'
#   }
#
# @note
#   There is no official package available for mod_cluster, so you must make it available outside of the apache module. 
#   Binaries can be found [here](https://modcluster.io/).
#
# @see https://modcluster.io/ for additional documentation.
#
class apache::mod::cluster (
  $allowed_network,
  $balancer_name,
  $ip,
  $version,
  $enable_mcpm_receive = true,
  $port = '6666',
  $keep_alive_timeout = 60,
  $manager_allowed_network = '127.0.0.1',
  $max_keep_alive_requests = 0,
  $server_advertise = true,
  $advertise_frequency = undef,
) {
  include apache

  ::apache::mod { 'proxy': }
  ::apache::mod { 'proxy_ajp': }
  ::apache::mod { 'manager': }
  ::apache::mod { 'proxy_cluster': }
  ::apache::mod { 'advertise': }

  if (versioncmp($version, '1.3.0') >= 0 ) {
    ::apache::mod { 'cluster_slotmem': }
  } else {
    ::apache::mod { 'slotmem': }
  }

  file { 'cluster.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/cluster.conf",
    mode    => $apache::file_mode,
    content => template('apache/mod/cluster.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
