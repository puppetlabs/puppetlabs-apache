# @summary disable Apache-Module worker
class apache::mpm::disable_mpm_worker {
  $mod_names = ['worker', 'mpm_worker']
  $mod_names.each | $mod_name| {
    $worker_command = ['/usr/sbin/a2dismod', $mod_name]
    $worker_onlyif = [['/usr/bin/test', '-e', join([$apache::mod_enable_dir, "${mod_name}.load"],'/')]]
    exec { "/usr/sbin/a2dismod ${mod_name}":
      command => $worker_command,
      onlyif  => $worker_onlyif,
      require => Package['httpd'],
      notify  => Class['apache::service'],
    }
  }
}
