# @summary
#   Installs `mod_setenvif`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_setenvif.html for additional documentation.
#
class apache::mod::setenvif {
  include ::apache
  ::apache::mod { 'setenvif': }
  # Template uses no variables
  file { 'setenvif.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/setenvif.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/setenvif.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
