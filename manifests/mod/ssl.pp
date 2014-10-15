class apache::mod::ssl (
  $ssl_compression = false,
  $ssl_options     = [ 'StdEnvVars' ],
  # Recommendation from Mozilla Foundation (https://wiki.mozilla.org/Security/Server_Side_TLS):
  $ssl_cipher      = 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA',
  # $ssl_cipher      = 'HIGH:MEDIUM:!aNULL:!MD5',
  $apache_version  = $::apache::apache_version,
  $package_name    = undef,
) {
  $session_cache = $::osfamily ? {
    'debian'  => "\${APACHE_RUN_DIR}/ssl_scache(512000)",
    'redhat'  => '/var/cache/mod_ssl/scache(512000)',
    'freebsd' => '/var/run/ssl_scache(512000)',
  }

  case $::osfamily {
    'debian': {
      if versioncmp($apache_version, '2.4') >= 0 {
        $ssl_mutex = 'default'
      } elsif $::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '10.04' {
        $ssl_mutex = 'file:/var/run/apache2/ssl_mutex'
      } else {
        $ssl_mutex = "file:\${APACHE_RUN_DIR}/ssl_mutex"
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

  ::apache::mod { 'ssl':
    package => $package_name,
  }

  if versioncmp($apache_version, '2.4') >= 0 {
    ::apache::mod { 'socache_shmcb': }
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
    path    => "${::apache::mod_dir}/ssl.conf",
    content => template('apache/mod/ssl.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Service['httpd'],
  }
}
