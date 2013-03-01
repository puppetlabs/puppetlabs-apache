class apache::mod::negotiation {
  apache::mod { 'negotiation': }
  # Template uses no variables
  file { 'negotiation.conf':
    ensure  => present,
    path    => "${apache::mod_dir}/negotiation.conf",
    content => template('apache/mod/negotiation.conf.erb'),
  }
}
