# @summary
#   Installs and configures `mod_reqtimeout`.
# 
# @param timeouts
#   List of timeouts and data rates for receiving requests.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_reqtimeout.html for additional documentation.
#
class apache::mod::reqtimeout (
  $timeouts = ['header=20-40,minrate=500', 'body=10,minrate=500']
){
  include ::apache
  ::apache::mod { 'reqtimeout': }
  # Template uses no variables
  file { 'reqtimeout.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/reqtimeout.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/reqtimeout.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
