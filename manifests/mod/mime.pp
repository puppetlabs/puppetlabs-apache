# @summary
#   Installs and configures `mod_mime`.
# 
# @param mime_support_package
#   Name of the MIME package to be installed.
#
# @param mime_types_config
#   The location of the mime.types file.
#
# @param mime_types_additional
#   List of additional MIME types to include.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_mime.html for additional documentation.
#
class apache::mod::mime (
  String $mime_support_package          = $apache::params::mime_support_package,
  String $mime_types_config             = $apache::params::mime_types_config,
  Optional[Hash] $mime_types_additional = undef,
) inherits apache::params {
  include apache
  $_mime_types_additional = pick($mime_types_additional, $apache::mime_types_additional)
  apache::mod { 'mime': }
  # Template uses $_mime_types_config
  $parameters = {
    'mime_types_config'      => $mime_types_config,
    '_mime_types_additional' => $_mime_types_additional,
  }

  file { 'mime.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/mime.conf",
    mode    => $apache::file_mode,
    content => epp('apache/mod/mime.conf.epp', $parameters),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
  if $mime_support_package {
    package { $mime_support_package:
      ensure => 'installed',
      before => File['mime.conf'],
    }
  }
}
