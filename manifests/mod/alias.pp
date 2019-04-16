# @summary
#   This class enables and configues Apache mod_alias
# 
# @param apache_version
#   The version of Apache, if not set will be retrieved from the init class.
# 
# @param icons_options
#   Passes through alias options
# 
# @param icons_path
#   The directory files will be stored in
# 
# See [`Apache mod_alias`](https://httpd.apache.org/docs/2.4/mod/mod_alias.html) 
# for more information.
class apache::mod::alias(
  $apache_version = undef,
  $icons_options  = 'Indexes MultiViews',
  # set icons_path to false to disable the alias
  $icons_path     = $::apache::params::alias_icons_path,
) inherits ::apache::params {
  include ::apache
  $_apache_version = pick($apache_version, $apache::apache_version)
  apache::mod { 'alias': }

  # Template uses $icons_path, $_apache_version
  if $icons_path {
    file { 'alias.conf':
      ensure  => file,
      path    => "${::apache::mod_dir}/alias.conf",
      mode    => $::apache::file_mode,
      content => template('apache/mod/alias.conf.erb'),
      require => Exec["mkdir ${::apache::mod_dir}"],
      before  => File[$::apache::mod_dir],
      notify  => Class['apache::service'],
    }
  }
}
