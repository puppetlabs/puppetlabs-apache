# Class apache::mod::jk
#
# Manages mod_jk connector
#
# All parameters are optional. When undefined, some receive default values,
# while others cause an optional directive to be absent
#
# For help on parameters, pls see official reference at:
# https://tomcat.apache.org/connectors-doc/reference/apache.html
#
class apache::mod::jk (
  $workers_file          = undef,
  $worker_property       = undef,
  $shm_file              = undef,
  $shm_size              = undef,
  $mount_file            = undef,
  $mount_file_reload     = undef,
  $mount                 = undef,
  $un_mount              = undef,
  $auto_alias            = undef,
  $mount_copy            = undef,
  $worker_indicator      = undef,
  $watchdog_interval     = undef,
  $log_file              = undef,
  $log_level             = undef,
  $log_stamp_format      = undef,
  $request_log_format    = undef,
  $extract_ssl           = undef,
  $https_indicator       = undef,
  $sslprotocol_indicator = undef,
  $certs_indicator       = undef,
  $cipher_indicator      = undef,
  $certchain_prefix      = undef,
  $session_indicator     = undef,
  $keysize_indicator     = undef,
  $local_name_indicator  = undef,
  $ignore_cl_indicator   = undef,
  $local_addr_indicator  = undef,
  $local_port_indicator  = undef,
  $remote_host_indicator = undef,
  $remote_addr_indicator = undef,
  $remote_port_indicator = undef,
  $remote_user_indicator = undef,
  $auth_type_indicator   = undef,
  $options               = undef,
  $env_var               = undef,
  $strip_session         = undef,
){

  include ::apache

  ::apache::mod { 'jk': }

  file {'jk.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/jk.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/jk.conf.erb'),
    require => [
      Exec["mkdir ${::apache::mod_dir}"],
      File[$::apache::mod_dir],
    ],
    notify  => Class['apache::service'],
  }

}