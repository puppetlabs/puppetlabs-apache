# @summary
#   Installs and configures `mod_dumpio`.
# 
# @param dump_io_input
#   Dump all input data to the error log
#
# @param dump_io_output
#   Dump all output data to the error log
#
# @example
#   class{'apache':
#     default_mods => false,
#     log_level    => 'dumpio:trace7',
#   }
#   class{'apache::mod::dumpio':
#     dump_io_input  => 'On',
#     dump_io_output => 'Off',
#   }
#
# @see https://httpd.apache.org/docs/current/mod/mod_dumpio.html for additional documentation.
#
class apache::mod::dumpio(
  Enum['Off', 'On', 'off', 'on'] $dump_io_input  = 'Off',
  Enum['Off', 'On', 'off', 'on'] $dump_io_output = 'Off',
) {
  include ::apache

  ::apache::mod { 'dumpio': }
  file{'dumpio.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/dumpio.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/dumpio.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }

}
