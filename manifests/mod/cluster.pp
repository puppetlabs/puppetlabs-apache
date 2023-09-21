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
  String $allowed_network,
  String $balancer_name,
  Stdlib::IP::Address $ip,
  String $version,
  Boolean $enable_mcpm_receive                 = true,
  Stdlib::Port $port                           = 6666,
  Integer $keep_alive_timeout                  = 60,
  Stdlib::IP::Address $manager_allowed_network = '127.0.0.1',
  Integer $max_keep_alive_requests             = 0,
  Boolean $server_advertise                    = true,
  Optional[String] $advertise_frequency        = undef,
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

  $parameters = {
    'ip'                      => $ip,
    'port'                    => $port,
    'allowed_network'         => $allowed_network,
    'keep_alive_timeout'      => $keep_alive_timeout,
    'max_keep_alive_requests' => $max_keep_alive_requests,
    'enable_mcpm_receive'     => $enable_mcpm_receive,
    'balancer_name'           => $balancer_name,
    'server_advertise'        => $server_advertise,
    'advertise_frequency'     => $advertise_frequency,
    'manager_allowed_network' => $manager_allowed_network,
  }

  file { 'cluster.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/cluster.conf",
    mode    => $apache::file_mode,
    content => epp('apache/mod/cluster.conf.epp', $parameters),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
