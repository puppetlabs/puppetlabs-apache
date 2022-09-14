# @summary disable Apache-Module prefork
class apache::mpm::disable_mpm_prefork {
  $prefork_command = ['/usr/sbin/a2dismod', 'prefork']
  $prefork_onlyif = [['/usr/bin/test', '-e', join([$apache::mod_enable_dir, 'prefork.load'],'/')]]
  exec { '/usr/sbin/a2dismod prefork':
    command => $prefork_command,
    onlyif  => $prefork_onlyif,
    require => Package['httpd'],
    before  => Class['apache::service'],
  }
}
