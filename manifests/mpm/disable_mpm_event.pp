class apache::mpm::disable_mpm_event {
  exec { '/usr/sbin/a2dismod event':
    onlyif  => "/usr/bin/test -e ${apache::mod_enable_dir}/event.load",
    require => Package['httpd'],
    before  => Class['apache::service'],
  }
  exec { 'remove distribution event load file':
    command => "/bin/rm ${apache::mod_enable_dir}/mpm_event.load",
    onlyif  => "/usr/bin/test -e ${apache::mod_enable_dir}/mpm_event.load",
    require => Package['httpd'],
    before  => Class['apache::service'],
  }
  exec { 'remove distribution event conf file':
    command => "/bin/rm ${apache::mod_enable_dir}/mpm_event.conf",
    onlyif  => "/usr/bin/test -e ${apache::mod_enable_dir}/mpm_event.conf",
    require => Package['httpd'],
    before  => Class['apache::service'],
  }
}
