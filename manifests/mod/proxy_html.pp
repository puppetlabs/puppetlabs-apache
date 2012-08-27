class apache::mod::proxy_html {
  Class['apache::mod::proxy'] -> Class['apache::mod::proxy_html']
  Class['apache::mod::proxy_http'] -> Class['apache::mod::proxy_html']
  apache::mod { 'proxy_html': }
  # proxy_html uses libxml2 so we need to load this .so
  file { "${apache::params::mod_dir}/libxml2.load":
    ensure  => present,
    content => "LoadFile /usr/lib/libxml2.so.2\n",
  }
}
