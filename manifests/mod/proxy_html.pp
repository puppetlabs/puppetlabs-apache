class apache::mod::proxy_html {
  Class['apache::mod::proxy'] -> Class['apache::mod::proxy_html']
  Class['apache::mod::proxy_http'] -> Class['apache::mod::proxy_html']
  apache::mod { 'proxy_html': }
  # proxy_html uses libxml2 so we need to load this .so
  file { 'libxml2.load':
    ensure  => present,
    path    => "${apache::mod_dir}/libxml2.conf",
    content => "LoadFile /usr/lib/libxml2.so.2\n",
  }
  # ...that Debian thing!
  if $::osfamily == 'Debian' {
    $enable_dir = $apache::params::mod_enable_dir
    file{ "enable.libxml2.load":
      path    => "${enable_dir}/libxml2.load",
      ensure  => link,
      target  => "${mod_dir}/libxml2.load",
      owner   => $apache::params::user,
      group   => $apache::params::group,
      mode    => '0644',
      require => File["libxml2.load"],
      notify  => Service['httpd'],
    }
  }
}
