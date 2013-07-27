class apache::mod::passenger (
  $passenger_root          = $apache::params::passenger_root,
  $passenger_ruby          = $apache::params::passenger_ruby,
  $passenger_max_pool_size = undef,
) {
  if $::osfamily == 'FreeBSD' {
    apache::mod { 'passenger':
      lib_path => "${passenger_root}/buildout/apache2"
    }
  } else {
    apache::mod { 'passenger': }
  }
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
