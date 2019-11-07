class apache::mpm::disable_mpm_worker {
  exec { '/usr/sbin/a2dismod worker':
    onlyif  => "/usr/bin/test -e ${apache::mod_enable_dir}/worker.load",
    require => Package['httpd'],
    before  => Class['apache::service'],
  }

}
