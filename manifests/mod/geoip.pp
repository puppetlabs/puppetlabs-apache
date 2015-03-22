class apache::mod::geoip (
  $enable                  = 'Off',
  $dbfile                  = '/usr/share/GeoIP/GeoIP.dat',
  $flag                    = 'Standard',
  $output                  = 'All',
  $enableutf8              = undef,
  $scanproxyheaders        = undef,
  $uselastxforwarededforip = undef,
) {
  ::apache::mod { 'geoip': }

  # Template uses:
  # - enable
  # - dbfile
  # - flag
  # - output
  # - enableutf8
  # - scanproxyheaders
  # - uselastxforwarededforip
  file { 'geoip.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/geoip.conf",
    content => template('apache/mod/geoip.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }

}
