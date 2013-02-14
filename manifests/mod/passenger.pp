class apache::mod::passenger (
  $passenger_high_performance   = undef,
  $passenger_pool_idletime      = undef,
  $passenger_max_requests       = undef,
  $passenger_stat_throttle_rate = undef,
  $rack_auto_detect             = undef,
  $rails_auto_detect            = undef,
  $passenger_root               = $apache::params::passenger_root,
  $passenger_ruby               = $apache::params::passenger_ruby,
  $passenger_max_pool_size      = undef,
) {
  apache::mod { 'passenger': }
  # Template uses: $passenger_root, $passenger_ruby, $passenger_max_pool_size
  file { 'passenger.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/passenger.conf",
    content => template('apache/mod/passenger.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }
}
