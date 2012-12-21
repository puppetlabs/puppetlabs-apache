class apache::mod::autoindex {
  apache::mod { 'autoindex': }
  # Template uses no variables
  file { "${apache::params::mod_dir}/autoindex.conf":
    ensure  => present,
    content => template('apache/mod/autoindex.conf.erb'),
  }
}
