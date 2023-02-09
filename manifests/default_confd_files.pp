# @summary
#   Helper for setting up default conf.d files.
#
# @api private
class apache::default_confd_files (
  Boolean $all = true,
) {
  # The rest of the conf.d/* files only get loaded if we want them
  if $all {
    case $facts['os']['family'] {
      'FreeBSD': {
        include apache::confd::no_accf
      }
      default: {
        # do nothing
      }
    }
  }
}
