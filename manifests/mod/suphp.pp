class apache::mod::suphp (
){
  if ($facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['major'], '18.04') >= 0) {
    fail('mod_fastcgi is no longer supported on Ubuntu 18.04 and above. Please use mod_proxy_fcgi')
  }
  include ::apache
  ::apache::mod { 'suphp': }

  file {'suphp.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/suphp.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/suphp.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}

