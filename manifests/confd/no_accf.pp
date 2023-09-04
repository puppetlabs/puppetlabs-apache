# @summary
#   Manages the `no-accf.conf` file.
#
# @api private
class apache::confd::no_accf {
  # Template uses no variables
  file { 'no-accf.conf':
    ensure  => 'file',
    path    => "${apache::confd_dir}/no-accf.conf",
    content => epp('apache/confd/no-accf.conf.epp'),
    require => Exec["mkdir ${apache::confd_dir}"],
    before  => File[$apache::confd_dir],
  }
}
