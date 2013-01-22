class apache::mod::php {
  include apache::params
  apache::mod { 'php5': }
  file { "${apache::params::mods_available_dir}/php5.conf":
    ensure  => present,
    content => template('apache/mod/php.conf.erb'),
  }
}
