class apache::default_confd_files (
  $all = true,
) {
  # These are conf.d/* files required to run the default configuration.
  case $::osfamily {
    'debian': {}
    'redhat': {}
    'freebsd': {}
    default: {}
  }

  # The rest of the conf.d/* files only get loaded if we want them
  if $all {
    case $::osfamily {
      'debian': {}
      'redhat': {}
      'freebsd': {
        include apache::confd::no_accf
      }
      default: {}
    }
  }
}
