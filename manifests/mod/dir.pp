# @api private
class apache::mod::dir (
  $dir                   = 'public_html',
  Array[String] $indexes = ['index.html','index.html.var','index.cgi','index.pl','index.php','index.xhtml'],
) {

  include ::apache
  ::apache::mod { 'dir': }

  # Template uses
  # - $indexes
  file { 'dir.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/dir.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/dir.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
