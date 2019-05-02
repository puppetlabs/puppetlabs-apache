# @summary
#   Installs and configures `mod_nss`.
# 
# @param transfer_log
#   Path to `access.log`.
#
# @param error_Log
#   Path to `error.log`
#
# @param passwd_file
#   Path to file containing token passwords used for NSSPassPhraseDialog.
#
# @param port
#   Sets the SSL port that should be used by mod_nss.
# 
# @see https://pagure.io/mod_nss for additional documentation.
#
class apache::mod::nss (
  $transfer_log = "${::apache::params::logroot}/access.log",
  $error_log    = "${::apache::params::logroot}/error.log",
  $passwd_file  = undef,
  $port     = 8443,
) {
  include ::apache
  include ::apache::mod::mime

  apache::mod { 'nss': }

  $httpd_dir = $::apache::httpd_dir

  # Template uses:
  # $transfer_log
  # $error_log
  # $http_dir
  # passwd_file
  file { 'nss.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/nss.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/nss.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
