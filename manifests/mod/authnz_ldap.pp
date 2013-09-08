class apache::mod::authnz_ldap(
  $ldap_conf = 'apache/mod/authnz_ldap.conf.erb'
) {
  apache::mod { 'authnz_ldap': }
  file { 'authnz_ldap.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/authnz_ldap.conf",
    content => template($ldap_conf),
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }
}
