# @summary disable Apache-Module event
class apache::mpm::disable_mpm_event {
  $mod_names = ['event', 'mpm_event']
  $mod_names.each | $mod_name| {
    $event_command = ['/usr/sbin/a2dismod', $mod_name]
    $event_onlyif = [['/usr/bin/test', '-e', join([$apache::mod_enable_dir, "${mod_name}.load"],'/')]]
    exec { "/usr/sbin/a2dismod ${mod_name}":
      command => $event_command,
      onlyif  => $event_onlyif,
      require => Package['httpd'],
      notify  => Class['apache::service'],
    }
  }
}
