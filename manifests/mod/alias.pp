# @summary
#   Installs and configures `mod_alias`.
# 
# @param icons_options
#   Disables directory listings for the icons directory, via Apache [Options](https://httpd.apache.org/docs/current/mod/core.html#options)
#   directive.
# 
# @param icons_path
#   Sets the local path for an /icons/ Alias. Default depends on operating system:
#   - Debian: /usr/share/apache2/icons
#   - FreeBSD: /usr/local/www/apache24/icons
#   - Gentoo: /var/www/icons
#   - Red Hat: /var/www/icons, except on Apache 2.4, where it's /usr/share/httpd/icons
#   Set to 'false' to disable the alias
# 
# @param icons_prefix
#   Change the alias for /icons/.
#
# @see https://httpd.apache.org/docs/current/mod/mod_alias.html for additional documentation.
#
class apache::mod::alias (
  String $icons_options                              = 'Indexes MultiViews',
  # set icons_path to false to disable the alias
  Variant[Boolean, Stdlib::Absolutepath] $icons_path = $apache::params::alias_icons_path,
  String $icons_prefix                               = $apache::params::icons_prefix
) inherits apache::params {
  include apache
  apache::mod { 'alias': }

  # Template uses $icons_path
  $parameters = {
    'icons_prefix'  => $icons_prefix,
    'icons_path'    => $icons_path,
    'icons_options' => $icons_options,
  }

  if $icons_path {
    file { 'alias.conf':
      ensure  => file,
      path    => "${apache::mod_dir}/alias.conf",
      mode    => $apache::file_mode,
      content => epp('apache/mod/alias.conf.epp', $parameters),
      require => Exec["mkdir ${apache::mod_dir}"],
      before  => File[$apache::mod_dir],
      notify  => Class['apache::service'],
    }
  }
}
