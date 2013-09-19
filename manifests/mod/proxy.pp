class apache::mod::proxy (
  $proxy_requests = 'Off',
  $allow_from = ['127.0.0.1','::1'],
) {
  include 'apache'
  apache::mod { 'proxy': }
  # Template uses $proxy_requests
  file { 'proxy.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/proxy.conf",
    content => template('apache/mod/proxy.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }
}
