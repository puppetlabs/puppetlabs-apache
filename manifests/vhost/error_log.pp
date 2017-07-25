
define apache::vhost::error_log (
  Boolean $error_log                                                                = true,
  $error_log_file                                                                   = undef,
  $error_log_pipe                                                                   = undef,
  $error_log_syslog                                                                 = undef,
  $log_level                                                                        = undef,
  Boolean $ssl                                                                      = false,
  $logroot                                                                          = $::apache::logroot,
  Optional[String] $vhost                                                           = $name,
) {

  if ! ( $error_log or $log_level ) {
    fail("Apache::Vhost::Error_log[${name}]: Either 'error_log' or 'log_level' must be defined")
  }

  if $error_log and $error_log_file and $error_log_pipe {
    fail("Apache::Vhost::Error_log[${name}]: 'error_log_file' and 'error_log_pipe' cannot be defined at the same time")
  }

  if $error_log and $error_log_file and $error_log_syslog {
    fail("Apache::Vhost::Error_log[${name}]: 'error_log_file' and 'error_log_syslog' cannot be defined at the same time")
  }

  if $error_log and $error_log_pipe and $error_log_syslog {
    fail("Apache::Vhost::Error_log[${name}]: 'error_log_pipe' and 'error_log_syslog' cannot be defined at the same time")
  }

  if $error_log_file {
    if $error_log_file =~ /^\// {
      # Absolute path provided - don't prepend $logroot
      $error_log_destination = $error_log_file
    } else {
      $error_log_destination = "${logroot}/${error_log_file}"
    }
  } elsif $error_log_pipe {
    $error_log_destination = $error_log_pipe
  } elsif $error_log_syslog {
    $error_log_destination = $error_log_syslog
  } else {
    if $ssl {
      $error_log_destination = "${logroot}/${name}_error_ssl.log"
    } else {
      $error_log_destination = "${logroot}/${name}_error.log"
    }
  }

  if $log_level {
    validate_apache_log_level($log_level)
  }

  # Template uses:
  # - $error_log
  # - $error_log_destination
  # - $log_level
  concat::fragment { "${vhost}-logging":
    target  => "apache::vhost::${vhost}",
    order   => 80,
    content => template('apache/vhost/_logging.erb'),
  }

}
