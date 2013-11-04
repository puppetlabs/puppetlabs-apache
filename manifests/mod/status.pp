class apache::mod::status (
  $allow_from      = ['127.0.0.1','::1'],
  $extended_status = 'On',
){
  validate_array($allow_from)
  validate_re(downcase($extended_status), '^(on|off)$', "${extended_status} is not supported for extended_status.  Allowed values are 'On' and 'Off'.")
  apache::mod { 'status': }
  # Template uses $allow_from, $extended_status
  file { 'status.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/status.conf",
    content => template('apache/mod/status.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }
}
