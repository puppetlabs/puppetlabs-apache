class apache::mod::passenger (
  $passenger_root          = $apache::params::passenger_root,
  $passenger_ruby          = $apache::params::passenger_ruby,
  $passenger_max_pool_size = undef,
) {
  apache::mod { 'passenger': }
  # Template uses $passenger_root, $passenger_ruby, $passenger_max_pool_size
  file { "${apache::params::mod_dir}/passenger.conf":
    ensure  => present,
    content => template('apache/mod/passenger.conf.erb'),
  }
}
