class apache::mod::status (
  $enable     = false,
  $allow_from = ['127.0.0.1'],
) {
  if $enable {
    $ensure   = 'present'
    $template = template('apache/mod/status.conf.erb')
  }else{
    $ensure   = 'absent'
    $template = undef
  }

  apache::mod { 'status': }
  # Template uses $allow_from
  file { "${apache::params::vdir}/status.conf":
    ensure  => $ensure,
    content => $template,
  }
}
