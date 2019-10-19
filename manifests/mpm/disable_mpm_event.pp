class apache::mpm::disable_mpm_event {
  exec { '/usr/sbin/a2dismod event':
    onlyif  => "/usr/bin/test -e ${apache::mod_enable_dir}/event.load",
    require => Package['httpd'],
    before  => Class['apache::service'],
  }

}
