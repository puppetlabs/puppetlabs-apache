# @summary
#   Installs and configures `mod_mime_magic`.
# 
# @param magic_file
#   Enable MIME-type determination based on file contents using the specified magic file.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_mime_magic.html for additional documentation.
#
class apache::mod::mime_magic (
  $magic_file = undef,
) {
  include ::apache
  $_magic_file = pick($magic_file, "${::apache::conf_dir}/magic")
  apache::mod { 'mime_magic': }
  # Template uses $magic_file
  file { 'mime_magic.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/mime_magic.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/mime_magic.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
