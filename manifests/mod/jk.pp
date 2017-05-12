class apache::mod::jk {

  include ::apache

  ::apache::mod { 'jk': }

  file {'jk.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/jk.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/jk.conf.erb'),
    require => [
      Exec["mkdir ${::apache::mod_dir}"],
      File[$::apache::mod_dir],
    ],
    notify  => Class['apache::service'],
  }

}
