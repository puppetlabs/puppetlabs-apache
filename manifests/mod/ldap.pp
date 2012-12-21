class apache::mod::ldap {
  apache::mod { 'ldap': }
  # Template uses no variables
  file { "${apache::params::mod_dir}/ldap.conf":
    ensure  => present,
    content => template('apache/mod/ldap.conf.erb'),
  }
}
