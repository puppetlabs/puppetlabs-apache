class apache::mod::ssl (
  $ssl_compression = false,
  $ssl_options     = [ 'StdEnvVars' ],
  $apache_version  = $apache::apache_version,
) {
  $session_cache = $::osfamily ? {
    'debian'  => "\${APACHE_RUN_DIR}/ssl_scache(512000)${::pass_lint_trick}",
    'redhat'  => '/var/cache/mod_ssl/scache(512000)',
    'freebsd' => '/var/run/ssl_scache(512000)',
  }

  case $::osfamily {
    'debian': {
      if $apache_version >= 2.4 and $::operatingsystem == 'Ubuntu' {
        $ssl_mutex = 'default'
      } else {
        $ssl_mutex = "file:\${APACHE_RUN_DIR}/ssl_mutex${::pass_lint_trick}"
      }
    }
    'redhat': {
      $ssl_mutex = 'default'
    }
    'freebsd': {
      $ssl_mutex = 'default'
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }

  apache::mod { 'ssl': }

  if $apache_version >= 2.4 {
    apache::mod { 'socache_shmcb': }
  }

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
