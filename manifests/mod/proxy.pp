class apache::mod::proxy (
  $proxy_requests = "Off"
) {
  apache::mod { 'proxy': }
  # Template uses $proxy_requests
  file { 'proxy.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/proxy.conf",
    content => template('apache/mod/proxy.conf.erb'),
  }
}
