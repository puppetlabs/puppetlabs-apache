# @summary
#   Installs `mod_autoindex`
# 
# @see https://httpd.apache.org/docs/current/mod/mod_autoindex.html for additional documentation.
#
class apache::mod::autoindex {
  include ::apache
  ::apache::mod { 'autoindex': }
  # Template uses no variables
  file { 'autoindex.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/autoindex.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/autoindex.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
