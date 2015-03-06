# Class: apache::mod::geoip
#
# This class enables and configures Apache mod_geoip
#
# Actions:
# - Enable and configure Apache mod_geoip
#
# Requires:
# - The apache class
#
# Sample Usage:
#
#  include apache::mod::geoip
#
class apache::mod::geoip (
  $enabled        = true,
  $db_file        = '/usr/share/GeoIP/GeoIP.dat',
  $package_ensure = 'present',
){

  validate_re($db_file, '^[\'"]?(?:/[^/]+)*[\'"]?$', "${db_file} is not supported for db_file.  Allowed values are paths.")
  validate_bool($enabled)

  apache::mod { 'geoip':
    package        => 'mod_geoip',
    package_ensure => $package_ensure,
  }

  # Template uses all class parameters
  file { 'geoip.conf':
    ensure  => 'present',
    path    => "${apache::mod_dir}/geoip.conf",
    content => template('apache/mod/geoip.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['::apache::service'],
  }
}
