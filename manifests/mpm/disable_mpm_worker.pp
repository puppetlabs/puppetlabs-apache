# @summary disable Apache-Module worker
class apache::mpm::disable_mpm_worker {
  $worker_command = ['/usr/sbin/a2dismod', 'worker']
  $worker_onlyif = [['/usr/bin/test', '-e', join([$apache::mod_enable_dir, 'worker.load'],'/')]]
  exec { '/usr/sbin/a2dismod worker':
    command => $worker_command,
    onlyif  => $worker_onlyif,
    require => Package['httpd'],
    before  => Class['apache::service'],
  }
}
