# @summary
#   Installs and configures `mod_deflate`.
# 
# @param types
#   An array of MIME types to be deflated. See https://www.iana.org/assignments/media-types/media-types.xhtml.
#
# @param notes
#   A Hash where the key represents the type and the value represents the note name.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_deflate.html for additional documentation.
#
class apache::mod::deflate (
  $types = [
    'text/html text/plain text/xml',
    'text/css',
    'application/x-javascript application/javascript application/ecmascript',
    'application/rss+xml',
    'application/json',
  ],
  $notes = {
    'Input'  => 'instream',
    'Output' => 'outstream',
    'Ratio'  => 'ratio',
  }
) {
  include ::apache
  ::apache::mod { 'deflate': }

  file { 'deflate.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/deflate.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/deflate.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
