class apache::mpm::disable_mpm_prefork {
  exec { '/usr/sbin/a2dismod prefork':
    onlyif  => "/usr/bin/test -e ${apache::mod_enable_dir}/prefork.load",
    require => Package['httpd'],
    before  => Class['apache::service'],
  }
}
