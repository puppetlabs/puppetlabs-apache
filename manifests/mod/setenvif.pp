class apache::mod::setenvif {
  apache::mod { 'setenvif': }
  # Template uses no variables
  file { "${apache::params::mod_dir}/setenvif.conf":
    ensure  => present,
    content => template('apache/mod/setenvif.conf.erb'),
  }
}
