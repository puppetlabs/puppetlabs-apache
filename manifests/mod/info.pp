class apache::mod::info (
  $enable     = false,
  $allow_from = ['127.0.0.1','::1'],
){
  apache::mod { 'info': }
  # Template uses $allow_from
  if $enable {
    file { 'info.conf':
      ensure  => present,
      path    => "${apache::mod_dir}/info.conf",
      content => template('apache/mod/info.conf.erb'),
    }
  }
}
