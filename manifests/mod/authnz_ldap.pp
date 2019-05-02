# @summary
#   Installs `mod_authnz_ldap`.
# 
# @param verify_server_cert
#   Whether to force te verification of a server cert or not.
# 
# @param package_name
#   The name of the ldap package.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_authnz_ldap.html for additional documentation.
#
class apache::mod::authnz_ldap (
  Boolean $verify_server_cert = true,
  $package_name               = undef,
) {

  include ::apache
  include '::apache::mod::ldap'
  ::apache::mod { 'authnz_ldap':
    package => $package_name,
  }

  # Template uses:
  # - $verify_server_cert
  file { 'authnz_ldap.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/authnz_ldap.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/authnz_ldap.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
