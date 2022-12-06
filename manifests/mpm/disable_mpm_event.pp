# @summary disable Apache-Module event
class apache::mpm::disable_mpm_event {
  $event_command = ['/usr/sbin/a2dismod', 'mpm_event']
  $event_onlyif = [['/usr/bin/test', '-e', join([$apache::mod_enable_dir, 'mpm_event.load'],'/')]]
  exec { '/usr/sbin/a2dismod mpm_event':
    command => $event_command,
    onlyif  => $event_onlyif,
    require => Package['httpd'],
    notify  => Class['apache::service'],
  }
}
