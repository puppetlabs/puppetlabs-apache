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
  $worker_property       = {},
  $shm_file              = undef,
  $shm_size              = undef,
  $mount_file            = undef,
  $mount_file_reload     = undef,
  $mount                 = {},
  $un_mount              = {},
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
  $options               = [],
  $env_var               = {},
  $strip_session         = undef,
  # Workers file content
  $workers_file_content  = [],
){

  include ::apache

  # Provides important variables
  include ::apache
  # Manages basic module config
  ::apache::mod { 'jk': }

  # File resource common parameters
  File {
    ensure  => file,
    mode    => $::apache::file_mode,
    notify  => Class['apache::service'],
  }

  # Main config file
  file {'jk.conf':
    path    => "${::apache::mod_dir}/jk.conf",
    content => template('apache/mod/jk.conf.erb'),
    require => [
      Exec["mkdir ${::apache::mod_dir}"],
      File[$::apache::mod_dir],
    ],
  }

  # Workers file
  if $workers_file != undef {
    $workers_path = $workers_file ? {
      /^\//   => $workers_file,
      default => "${apache::httpd_dir}/${workers_file}",
    }
    file { $workers_path:
      content => template('apache/mod/jk/workers.properties.erb'),
      require => Package['httpd'],
    }
  }

}
