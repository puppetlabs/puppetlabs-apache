# @summary
#   Installs and configures `mod_expires`.
# 
# @param expires_active
#   Enables generation of Expires headers.
#
# @param expires_default
#   Specifies the default algorithm for calculating expiration time using ExpiresByType syntax or interval syntax.
#
# @param expires_by_type
#   Describes a set of [MIME content-types](https://www.iana.org/assignments/media-types/media-types.xhtml) and their expiration
#   times. This should be used as an array of Hashes, with each Hash's key a valid MIME content-type (i.e. 'text/json') and its 
#   value following valid interval syntax.
#
# @see https://httpd.apache.org/docs/current/mod/mod_expires.html for additional documentation.
#
class apache::mod::expires (
  $expires_active  = true,
  $expires_default = undef,
  $expires_by_type = undef,
) {
  include apache
  ::apache::mod { 'expires': }

  # Template uses
  # $expires_active
  # $expires_default
  # $expires_by_type
  file { 'expires.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/expires.conf",
    mode    => $apache::file_mode,
    content => template('apache/mod/expires.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
