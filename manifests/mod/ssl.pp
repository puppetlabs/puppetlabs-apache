class apache::mod::ssl (
  $ssl_compression = false,
  $ssl_options     = [ 'StdEnvVars' ],
  $apache_version  = $apache::apache_version,
) {
  $session_cache = $::osfamily ? {
    'debian'  => '${APACHE_RUN_DIR}/ssl_scache(512000)',
    'redhat'  => '/var/cache/mod_ssl/scache(512000)',
    'freebsd' => '/var/run/ssl_scache(512000)',
  }
  $ssl_mutex = $::osfamily ? {
    'debian'  => 'file:${APACHE_RUN_DIR}/ssl_mutex',
    'redhat'  => 'default',
    'freebsd' => 'default',
  }
  apache::mod { 'ssl': }

  # Template uses
  #
  # $ssl_compression
  # $ssl_options
  # $session_cache,
  # $ssl_mutex
  # $apache_version
  #
  file { 'ssl.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/ssl.conf",
    content => template('apache/mod/ssl.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }
}
