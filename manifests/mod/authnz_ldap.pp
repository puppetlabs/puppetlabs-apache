class apache::mod::authnz_ldap(
  $verifyServerCert = true,
) {
  include apache::mod::ldap
  apache::mod { 'authnz_ldap': }

  if $verifyServerCert == true {
    file { 'authnz_ldap.conf':
      ensure  => absent,
      path    => "${apache::mod_dir}/authnz_ldap.conf",
      notify  => Service['httpd'],
    }
  } else {
    file { 'authnz_ldap.conf':
      ensure  => file,
      path    => "${apache::mod_dir}/authnz_ldap.conf",
      content => 'LDAPVerifyServerCert off',
      before  => File[$apache::mod_dir],
      notify  => Service['httpd'],
    }
  }
}
