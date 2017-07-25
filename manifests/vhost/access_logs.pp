
define apache::vhost::access_logs (
  Boolean $access_log                                                               = true,
  $access_log_file                                                                  = false,
  $access_log_pipe                                                                  = false,
  $access_log_syslog                                                                = false,
  $access_log_format                                                                = false,
  $access_log_env_var                                                               = false,
  Optional[Array] $access_logs                                                      = undef,
  $logroot                                                                          = $::apache::logroot,
  Enum['directory', 'absent'] $logroot_ensure                                       = 'directory',
  $logroot_mode                                                                     = undef,
  $logroot_owner                                                                    = undef,
  $logroot_group                                                                    = undef,
  Boolean $ssl                                                                      = false,
  Optional[String] $vhost                                                           = $name,
) {

  if $access_log_file and $access_log_pipe {
    fail("Apache::Vhost[${name}]: 'access_log_file' and 'access_log_pipe' cannot be defined at the same time")
  }

  if $access_log and !$access_logs {
    $_access_logs = [{
      'file'        => $access_log_file,
      'pipe'        => $access_log_pipe,
      'syslog'      => $access_log_syslog,
      'format'      => $access_log_format,
      'env'         => $access_log_env_var
    }]
  } elsif $access_logs {
    $_access_logs = $access_logs
  }

  # determine fragment name
  if $vhost != $name {
    $fragment_name = "${vhost}-access_log-${name}"
  } else {
    $fragment_name = "${vhost}-access_log"
  }

  # Template uses:
  # - $_access_logs - generated from:
  #   - $access_logs, if defined, else:
  #   - $access_log_file
  #   - $access_log_pipe
  #   - $access_log_syslog
  #   - $access_log_format
  #   - $access_log_env_var
  # - $logroot
  # - $ssl
  concat::fragment { $fragment_name:
    target  => "apache::vhost::${vhost}",
    order   => 100,
    content => template('apache/vhost/_access_log.erb'),
  }
}
