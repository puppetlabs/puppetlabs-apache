
define apache::vhost::security (
  # $ssl is only used to determine the default audit log if no other audit parameters are given
  Optional[Boolean] $ssl                                                            = false,
  # TODO: $modsec_audit_log should be Optional[Boolean]
  $modsec_audit_log                                                                 = undef,
  # TODO: $modsec_audit_log_file should be Optional[String]
  $modsec_audit_log_file                                                            = undef,
  # TODO: $modsec_audit_log_pipe should be Optional[String]
  $modsec_audit_log_pipe                                                            = undef,
  # TODO: $logroot should be Optional[String]
  $logroot                                                                          = $::apache::logroot,
  # TODO: $modsec_disable_vhost should be Optional[Boolean]
  $modsec_disable_vhost                                                             = undef,
  Optional[Variant[Hash, Array]] $modsec_disable_ids                                = undef,
  # TODO: $modsec_disable_ips should be Optional[Variant[Array, String]]
  $modsec_disable_ips                                                               = undef,
  Optional[Variant[Hash, Array]] $modsec_disable_msgs                               = undef,
  Optional[Variant[Hash, Array]] $modsec_disable_tags                               = undef,
  # TODO: $modsec_body_limit should be Optional[Integer]
  $modsec_body_limit                                                                = undef,
  Optional[String] $vhost                                                           = $name,
) {

  if $modsec_audit_log_file and $modsec_audit_log_pipe {
    fail("Apache::Vhost::Security[${name}]: 'modsec_audit_log_file' and 'modsec_audit_log_pipe' cannot be defined at the same time")
  }

  if $modsec_audit_log == false {
    $modsec_audit_log_destination = undef
  } elsif $modsec_audit_log_file {
    $modsec_audit_log_destination = "${logroot}/${modsec_audit_log_file}"
  } elsif $modsec_audit_log_pipe {
    $modsec_audit_log_destination = $modsec_audit_log_pipe
  } elsif $modsec_audit_log {
    if $ssl {
      $modsec_audit_log_destination = "${logroot}/${vhost}_security_ssl.log"
    } else {
      $modsec_audit_log_destination = "${logroot}/${vhost}_security.log"
    }
  } else {
    $modsec_audit_log_destination = undef
  }

  ## Create a global LocationMatch if locations aren't defined
  if $modsec_disable_ids {
    if $modsec_disable_ids =~ Array {
      $_modsec_disable_ids = { '.*' => $modsec_disable_ids }
    } else {
      $_modsec_disable_ids = $modsec_disable_ids
    }
  }

  if $modsec_disable_msgs {
    if $modsec_disable_msgs =~ Array {
      $_modsec_disable_msgs = { '.*' => $modsec_disable_msgs }
    } else {
      $_modsec_disable_msgs = $modsec_disable_msgs
    }
  }

  if $modsec_disable_tags {
    if $modsec_disable_tags =~ Array {
      $_modsec_disable_tags = { '.*' => $modsec_disable_tags }
    } else {
      $_modsec_disable_tags = $modsec_disable_tags
    }
  }

  # Template uses:
  # - $modsec_disable_vhost
  # - $modsec_disable_ids
  # - $modsec_disable_ips
  # - $modsec_disable_msgs
  # - $modsec_disable_tags
  # - $modsec_body_limit
  # - $modsec_audit_log_destination
  #   (built from $ssl, $modsec_audit_log, $modsec_audit_log_file,
  #    $modsec_audit_log_pipe, and $logroot)
  if $modsec_disable_vhost or $modsec_disable_ids or $modsec_disable_ips or $modsec_disable_msgs or $modsec_disable_tags or $modsec_audit_log_destination or $modsec_body_limit {
    concat::fragment { "${vhost}-security":
      target  => "apache::vhost::${vhost}",
      order   => 320,
      content => template('apache/vhost/_security.erb'),
    }
  }
}
