class apache::mpm::disable_mpm_worker {
  exec { '/usr/sbin/a2dismod mpm_worker':
    onlyif  => "/usr/bin/test -e ${apache::mod_enable_dir}/mpm_worker.load",
    require => Package['httpd'],
    before  => Class['apache::service'],
  }

}
