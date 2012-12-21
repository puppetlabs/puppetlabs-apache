class apache::mod::negotiation {
  apache::mod { 'negotiation': }
  # Template uses no variables
  file { "${apache::params::mod_dir}/negotiation.conf":
    ensure  => present,
    content => template('apache/mod/negotiation.conf.erb'),
  }
}
