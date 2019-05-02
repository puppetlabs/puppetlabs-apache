# @summary
#   Installs `mod_jk`.
# 
# @param ip
#  IP for binding to mod_jk. Useful when the binding address is not the primary network interface IP.
# 
# @param port
#  Port for binding to mod_jk. Useful when something else, like a reverse proxy or cache, is receiving requests at port 80, then 
#  needs to forward them to Apache at a different port.
# 
# @param add_listen
#  Defines if a Listen directive according to parameters ip and port (see below), so that Apache listens to the IP/port combination
#  and redirect to mod_jk. Useful when another Listen directive, like Listen *:<Port> or Listen <Port>, can conflict with the one 
#  necessary for mod_jk binding.
# 
# @param workers_file
#   The name of a worker file for the Tomcat servlet containers.
# 
# @param worker_property
#   Enables setting worker properties inside Apache configuration file.
# 
# @param logroot
#  The base directory for shm_file and log_file is determined by the logroot parameter. If unspecified, defaults to 
#  apache::params::logroot. The default logroot is sane enough therefore it is not recommended to override it.
# 
# @param shm_file
#   Shared memory file name.
# 
# @param shm_size
#   Size of the shared memory file name.
# 
# @param mount_file
#   File containing multiple mappings from a context to a Tomcat worker.
# 
# @param mount_file_reload
#   This directive configures the reload check interval in seconds.
# 
# @param mount
#   A mount point from a context to a Tomcat worker.
# 
# @param un_mount
#   An exclusion mount point from a context to a Tomcat worker.
# 
# @param auto_alias
#   Automatically Alias webapp context directories into the Apache document space
# 
# @param mount_copy
#   If this directive is set to "On" in some virtual server, the mounts from the global server will be copied
#   to this virtual server, more precisely all mounts defined by JkMount or JkUnMount. 
# 
# @param worker_indicator
#   Name of the Apache environment variable that can be used to set worker names in combination with SetHandler 
#   jakarta-servlet. 
# 
# @param watchdog_interval
#   This directive configures the watchdog thread interval in seconds. 
# 
# @param log_file
#   Full or server relative path to the mod_jk log file.
# 
# @param log_level
#   The mod_jk log level, can be debug, info, warn error or trace. 
# 
# @param log_stamp_format
#   The mod_jk date log format, using an extended strftime syntax. 
# 
# @param request_log_format
#   Request log format string.
# 
# @param extract_ssl
#   Turns on SSL processing and information gathering by mod_jk.
# 
# @param https_indicator
#   Name of the Apache environment variable that contains SSL indication.
# 
# @param sslprotocol_indicator
#   Name of the Apache environment variable that contains the SSL protocol name. 
# 
# @param certs_indicator
#   Name of the Apache environment variable that contains SSL client certificates. 
# 
# @param cipher_indicator
#   Name of the Apache environment variable that contains SSL client cipher.
# 
# @param certchain_prefix
#   Name of the Apache environment (prefix) that contains SSL client chain certificates. 
# 
# @param session_indicator
#   Name of the Apache environment variable that contains SSL session. 
# 
# @param keysize_indicator
#   Name of the Apache environment variable that contains SSL key size in use. 
# 
# @param local_name_indicator
#   Name of the Apache environment variable which can be used to overwrite the forwarded local name. 
# 
# @param ignore_cl_indicator
#   Name of the Apache environment variable which forces to ignore an existing Content-Length request header. 
#
# @param local_addr_indicator
#   Name of the Apache environment variable which can be used to overwrite the forwarded local IP address.
#
# @param local_port_indicator
#   Name of the Apache environment variable which can be used to overwrite the forwarded local port.
# 
# @param remote_host_indicator
#   Name of the Apache environment variable which can be used to overwrite the forwarded remote (client) host name. 
#
# @param remote_addr_indicator
#   Name of the Apache environment variable which can be used to overwrite the forwarded remote (client) IP address. 
#
# @param remote_port_indicator
#   Name of the Apache environment variable which can be used to overwrite the forwarded remote (client) IP address. 
#
# @param remote_user_indicator
#   Name of the Apache environment variable which can be used to overwrite the forwarded user name. 
#
# @param auth_type_indicator
#   Name of the Apache environment variable which can be used to overwrite the forwarded authentication type.
#
# @param options
#   Set one of more options to configure the mod_jk module. 
#
# @param env_var
#   Adds a name and an optional default value of environment variable that should be sent to servlet-engine as a request attribute.
#
# @param strip_session
#   If this directive is set to On in some virtual server, the session IDs ;jsessionid=... will be removed for URLs which are not 
#   forwarded but instead are handled by the local server. 
#
# @param workers_file_content
#   Each directive has the format worker.<Worker name>.<Property>=<Value>. This maps as a hash of hashes, where the outer hash specifies
#   workers, and each inner hash specifies each worker properties and values. Plus, there are two global directives, 'worker.list' and
#   'worker.maintain' For example, the workers file below should be parameterized as follows:
#
#   Worker file:
#   ```
#   worker.list = status
#   worker.list = some_name,other_name
#   
#   worker.maintain = 60
#   
#   # Optional comment
#   worker.some_name.type=ajp13
#   worker.some_name.socket_keepalive=true
#   
#   # I just like comments
#   worker.other_name.type=ajp12 (why would you?)
#   worker.other_name.socket_keepalive=false
#   ```
#
#   Puppet file:
#   ```
#   $workers_file_content = {
#     worker_lists    => ['status', 'some_name,other_name'],
#     worker_maintain => '60',
#     some_name       => {
#       comment          => 'Optional comment',
#       type             => 'ajp13',
#       socket_keepalive => 'true',
#     },
#     other_name      => {
#       comment          => 'I just like comments',
#       type             => 'ajp12',
#       socket_keepalive => 'false',
#     },
#   }
#   ```
#
# @param mount_file_content
#   Each directive has the format <URI> = <Worker name>. This maps as a hash of hashes, where the outer hash specifies workers, and 
#   each inner hash contains two items:
#   - uri_list—an array with URIs to be mapped to the worker
#   - comment—an optional string with a comment for the worker. For example, the mount file below should be parameterized as Figure 2:
#
#   Worker file:
#   ```
#   # Worker 1
#   /context_1/ = worker_1
#   /context_1/* = worker_1
#
#   # Worker 2
#   / = worker_2
#   /context_2/ = worker_2
#   /context_2/* = worker_2
#   ``` 
#
#   Puppet file:
#   ```
#   $mount_file_content = {
#     worker_1 => {
#       uri_list => ['/context_1/', '/context_1/*'],
#       comment  => 'Worker 1',
#     },
#     worker_2 => {
#       uri_list => ['/context_2/', '/context_2/*'],
#       comment  => 'Worker 2',
#     },
#   },
#   ```
#
# @example
#   class { '::apache::mod::jk':
#     ip                   => '192.168.2.15',
#     workers_file         => 'conf/workers.properties',
#     mount_file           => 'conf/uriworkermap.properties',
#     shm_file             => 'run/jk.shm',
#     shm_size             => '50M',
#     workers_file_content => {
#       <Content>
#     },
#   }
#
# @note
#   shm_file and log_file
#   Depending on how these files are specified, the class creates their final path differently:
#
#   Relative path: prepends supplied path with logroot (see below)
#   Absolute path or pipe: uses supplied path as-is
#
#   ```
#   shm_file => 'shm_file'
#   # Ends up in
#   $shm_path = '/var/log/httpd/shm_file'
#
#   shm_file => '/run/shm_file'
#   # Ends up in
#   $shm_path = '/run/shm_file'
#
#   shm_file => '"|rotatelogs /var/log/httpd/mod_jk.log.%Y%m%d 86400 -180"'
#   # Ends up in
#   $shm_path = '"|rotatelogs /var/log/httpd/mod_jk.log.%Y%m%d 86400 -180"'
#   ```
#
# @note
#   All parameters are optional. When undefined, some receive default values, while others cause an optional
#   directive to be absent
#   
#   Additionally, There is no official package available for mod_jk and thus it must be made available by means outside of the control of the
#   apache module. Binaries can be found at Apache Tomcat Connectors download page
# 
# @see https://tomcat.apache.org/connectors-doc/reference/apache.html for additional documentation.
#
class apache::mod::jk (
  # Binding to mod_jk
  Optional[String] $ip         = undef,
  Integer          $port       = 80,
  Boolean          $add_listen = true,
  # Conf file content
  $workers_file                = undef,
  $worker_property             = {},
  $logroot                     = undef,
  $shm_file                    = 'jk-runtime-status',
  $shm_size                    = undef,
  $mount_file                  = undef,
  $mount_file_reload           = undef,
  $mount                       = {},
  $un_mount                    = {},
  $auto_alias                  = undef,
  $mount_copy                  = undef,
  $worker_indicator            = undef,
  $watchdog_interval           = undef,
  $log_file                    = 'mod_jk.log',
  $log_level                   = undef,
  $log_stamp_format            = undef,
  $request_log_format          = undef,
  $extract_ssl                 = undef,
  $https_indicator             = undef,
  $sslprotocol_indicator       = undef,
  $certs_indicator             = undef,
  $cipher_indicator            = undef,
  $certchain_prefix            = undef,
  $session_indicator           = undef,
  $keysize_indicator           = undef,
  $local_name_indicator        = undef,
  $ignore_cl_indicator         = undef,
  $local_addr_indicator        = undef,
  $local_port_indicator        = undef,
  $remote_host_indicator       = undef,
  $remote_addr_indicator       = undef,
  $remote_port_indicator       = undef,
  $remote_user_indicator       = undef,
  $auth_type_indicator         = undef,
  $options                     = [],
  $env_var                     = {},
  $strip_session               = undef,
  # Location list
  # See comments in template mod/jk.conf.erb
  $location_list               = [],
  # Workers file content
  # See comments in template mod/jk/workers.properties.erb
  $workers_file_content        = {},
  # Mount file content
  # See comments in template mod/jk/uriworkermap.properties.erb
  $mount_file_content          = {},
){

  # Provides important variables
  include ::apache
  # Manages basic module config
  ::apache::mod { 'jk': }

  # Ensure that we are not using variables with the typo fixed by MODULES-6225
  # anymore:
  if !empty($workers_file_content) and has_key($workers_file_content, 'worker_mantain') {
    fail('Please replace $workers_file_content[\'worker_mantain\'] by $workers_file_content[\'worker_maintain\']. See MODULES-6225 for details.')
  }


  # Binding to mod_jk
  if $add_listen {
    $_ip = $ip ? {
      undef   => $facts['ipaddress'],
      default => $ip,
    }
    ensure_resource('apache::listen', "${_ip}:${port}", {})
  }

  # File resource common parameters
  File {
    ensure  => file,
    mode    => $::apache::file_mode,
    notify  => Class['apache::service'],
  }

  # Shared memory and log paths
  # If logroot unspecified, use default
  $log_dir = $logroot ? {
    undef   => $::apache::logroot,
    default => $logroot,
  }
  # If absolute path or pipe, use as-is
  # If relative path, prepend with log directory
  # If unspecified, use default
  $shm_path = $shm_file ? {
    undef       => "${log_dir}/jk-runtime-status",
    /^\"?[|\/]/ => $shm_file,
    default     => "${log_dir}/${shm_file}",
  }
  $log_path = $log_file ? {
    undef       => "${log_dir}/mod_jk.log",
    /^\"?[|\/]/ => $log_file,
    default     => "${log_dir}/${log_file}",
  }

  # Main config file
  $mod_dir = $::apache::mod_dir
  file {'jk.conf':
    path    => "${mod_dir}/jk.conf",
    content => template('apache/mod/jk.conf.erb'),
    require => [
      Exec["mkdir ${mod_dir}"],
      File[$mod_dir],
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

  # Mount file
  if $mount_file != undef {
    $mount_path = $mount_file ? {
      /^\//   => $mount_file,
      default => "${apache::httpd_dir}/${mount_file}",
    }
    file { $mount_path:
      content => template('apache/mod/jk/uriworkermap.properties.erb'),
      require => Package['httpd'],
    }
  }

}
