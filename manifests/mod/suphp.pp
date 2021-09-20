# @summary
#   Installs `mod_suphp`.
#
# @see https://www.suphp.org/DocumentationView.html?file=apache/INSTALL for additional documentation.
#
class apache::mod::suphp (
) {
  if $facts['os']['family'] == 'Debian' {
    fail("suphp was declared EOL by it's creators as of 2013 and so is no longer supported on Ubuntu 15.10/Debian 8 and above. Please use php-fpm")
  }
  include apache
  ::apache::mod { 'suphp': }

  file { 'suphp.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/suphp.conf",
    mode    => $apache::file_mode,
    content => template('apache/mod/suphp.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
