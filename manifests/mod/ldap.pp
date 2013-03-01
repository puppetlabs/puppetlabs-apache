class apache::mod::ldap {
  apache::mod { 'ldap': }
  # Template uses no variables
  file { 'ldap.conf':
    ensure  => present,
    path    => "${apache::mod_dir}/ldap.conf",
    content => template('apache/mod/ldap.conf.erb'),
  }
}
