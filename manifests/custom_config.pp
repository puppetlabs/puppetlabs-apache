# See README.md for usage information
define apache::custom_config (
  $ensure         = 'present',
  $confdir        = $::apache::confd_dir,
  $content        = undef,
  $priority       = '25',
  $source         = undef,
  $verify_command = $::apache::params::verify_command,
  $verify_config  = true,
) {

  if $content and $source {
    fail('Only one of $content and $source can be specified.')
  }

  if $ensure == 'present' and ! $content and ! $source {
    fail('One of $content and $source must be specified.')
  }

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")

  validate_bool($verify_config)

  ## Apache include does not always work with spaces in the filename
  $filename  = regsubst($name, ' ', '_', 'G')

  if ! $verify_config or $ensure == 'absent' {
    $notifies = Service['httpd']
  } else {
    $notifies = undef
  }

  file { "apache_${name}":
    ensure  => $ensure,
    path    => "${confdir}/${priority}-${filename}.conf",
    content => $content,
    source  => $source,
    require => Package['httpd'],
    notify  => $notifies,
  }

  if $ensure == 'present' and $verify_config {
    exec { "service notify for ${name}":
      command     => $verify_command,
      subscribe   => File["apache_${name}"],
      refreshonly => true,
      notify      => Service['httpd'],
      before      => Exec["remove ${name} if invalid"],
    }

    exec { "remove ${name} if invalid":
      command     => "/bin/rm ${confdir}/${priority}-${filename}.conf",
      unless      => $verify_command,
      subscribe   => File["apache_${name}"],
      refreshonly => true,
    }
  }
}
