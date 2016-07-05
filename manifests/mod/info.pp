class apache::mod::info (
  $allow_from      = ['127.0.0.1','::1'],
  $apache_version  = undef,
  $restrict_access = true,
  $info_path       = '/server-info',
){
  include ::apache
  $_apache_version = pick($apache_version, $apache::apache_version)
  apache::mod { 'info': }
  # Template uses $allow_from, $_apache_version
  file { 'info.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/info.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/info.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
