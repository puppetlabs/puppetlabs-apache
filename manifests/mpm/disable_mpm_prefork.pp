# @summary disable Apache-Module prefork
class apache::mpm::disable_mpm_prefork {
  $mod_names = ['itk', 'mpm_itk', 'prefork', 'mpm_prefork']
  $mod_names.each | $mod_name| {
    $prefork_command = ['/usr/sbin/a2dismod', $mod_name]
    $prefork_onlyif = [['/usr/bin/test', '-e', join([$apache::mod_enable_dir, "${mod_name}.load"],'/')]]
    exec { "/usr/sbin/a2dismod ${mod_name}":
      command => $prefork_command,
      onlyif  => $prefork_onlyif,
      require => Package['httpd'],
      notify  => Class['apache::service'],
    }
  }
}
