# @summary
#   Installs and configures `mod_dir`.
# 
# @param types
#   Specifies the text-based content types to compress.
#
# @param indexes
#   Provides a string for the DirectoryIndex directive
# 
# @todo
#   This sets the global DirectoryIndex directive, so it may be necessary to consider being able to modify the apache::vhost to declare 
#   DirectoryIndex statements in a vhost configuration
#
# @see https://httpd.apache.org/docs/current/mod/mod_dir.html for additional documentation.
#
class apache::mod::dir (
  $dir                   = 'public_html',
  Array[String] $indexes = ['index.html','index.html.var','index.cgi','index.pl','index.php','index.xhtml'],
) {
  include apache
  ::apache::mod { 'dir': }

  # Template uses
  # - $indexes
  file { 'dir.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/dir.conf",
    mode    => $apache::file_mode,
    content => template('apache/mod/dir.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
