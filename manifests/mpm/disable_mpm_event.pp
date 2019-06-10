class apache::mpm::disable_mpm_event {
  exec { '/usr/sbin/a2dismod mpm_event':
    onlyif  => "/usr/bin/test -e ${apache::mod_enable_dir}/mpm_event.load",
    require => Package['httpd'],
    before  => Class['apache::service'],
  }

}
