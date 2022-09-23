# @summary disable Apache-Module event
class apache::mpm::disable_mpm_event {
  $event_command = ['/usr/sbin/a2dismod', 'event']
  $event_onlyif = [['/usr/bin/test', '-e', join([$apache::mod_enable_dir, 'event.load'],'/')]]
  exec { '/usr/sbin/a2dismod event':
    command => $event_command,
    onlyif  => $event_onlyif,
    require => Package['httpd'],
    before  => Class['apache::service'],
  }

  $event_load_command = ['/bin/rm', join([$apache::mod_enable_dir, 'event_event.load'],'/')]
  $event_load_onlyif = [['/usr/bin/test', '-e', join([$apache::mod_enable_dir, 'event_event.load'],'/')]]
  exec { 'remove distribution event load file':
    command => $event_load_command,
    onlyif  => $event_load_onlyif,
    require => Package['httpd'],
    before  => Class['apache::service'],
  }

  $event_conf_command = ['/bin/rm', join([$apache::mod_enable_dir, 'event_event.conf'],'/')]
  $event_conf_onlyif = [['/usr/bin/test', '-e', join([$apache::mod_enable_dir, 'event_event.conf'],'/')]]
  exec { 'remove distribution event conf file':
    command => $event_conf_command,
    onlyif  => $event_conf_onlyif,
    require => Package['httpd'],
    before  => Class['apache::service'],
  }
}
