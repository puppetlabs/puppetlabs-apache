class apache::mod::negotiation {
  apache::mod { 'negotiation': }
  # Template uses no variables
  file { 'negotiation.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/negotiation.conf",
    content => template('apache/mod/negotiation.conf.erb'),
  }
}
