# @summary
#   Installs `mod_autoindex`
# 
# @param icons_prefix
#   Change the alias for /icons/.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_autoindex.html for additional documentation.
#
class apache::mod::autoindex (
  String $icons_prefix = $apache::params::icons_prefix
) inherits apache::params {
  include apache
  ::apache::mod { 'autoindex': }

  # Determine icon filename suffix for autoindex.conf.epp
  case $facts['os']['name'] {
    'Debian', 'Ubuntu': {
      $icon_suffix = '-20x22'
    }
    default: {
      $icon_suffix = ''
    }
  }

  file { 'autoindex.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/autoindex.conf",
    mode    => $apache::file_mode,
    content => epp('apache/mod/autoindex.conf.epp', { 'icons_prefix' => $icons_prefix, 'icon_suffix' => $icon_suffix, }),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
