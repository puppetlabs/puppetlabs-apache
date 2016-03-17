class apache::mod::ssl (
  $ssl_compression         = false,
  $ssl_cryptodevice        = 'builtin',
  $ssl_options             = [ 'StdEnvVars' ],
  $ssl_openssl_conf_cmd    = undef,
  $ssl_cipher              = 'HIGH:MEDIUM:!aNULL:!MD5:!RC4',
  $ssl_honorcipherorder    = true,
  $ssl_protocol            = [ 'all', '-SSLv2', '-SSLv3' ],
  $ssl_pass_phrase_dialog  = 'builtin',
  $ssl_random_seed_bytes   = '512',
  $ssl_sessioncachetimeout = '300',
  $ssl_mutex               = undef,
  $apache_version          = undef,
  $package_name            = undef,
) {
  include ::apache
  include ::apache::mod::mime
  $_apache_version = pick($apache_version, $apache::apache_version)
  if $ssl_mutex {
    $_ssl_mutex = $ssl_mutex
  } else {
    case $::osfamily {
      'debian': {
        if versioncmp($_apache_version, '2.4') >= 0 {
          $_ssl_mutex = 'default'
        } elsif $::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '10.04' {
          $_ssl_mutex = 'file:/var/run/apache2/ssl_mutex'
        } else {
          $_ssl_mutex = "file:\${APACHE_RUN_DIR}/ssl_mutex"
        }
      }
      'redhat': {
        $_ssl_mutex = 'default'
      }
      'freebsd': {
        $_ssl_mutex = 'default'
      }
      'gentoo': {
        $_ssl_mutex = 'default'
      }
      'Suse': {
        $_ssl_mutex = 'default'
      }
      default: {
        fail("Unsupported osfamily ${::osfamily}, please explicitly pass in \$ssl_mutex")
      }
    }
  }

  validate_bool($ssl_compression)

  if is_bool($ssl_honorcipherorder) {
    $_ssl_honorcipherorder = $ssl_honorcipherorder
  } else {
    $_ssl_honorcipherorder = $ssl_honorcipherorder ? {
      'on'    => true,
      'off'   => false,
      default => true,
    }
  }

  $session_cache = $::osfamily ? {
    'debian'  => "\${APACHE_RUN_DIR}/ssl_scache(512000)",
    'redhat'  => '/var/cache/mod_ssl/scache(512000)',
    'freebsd' => '/var/run/ssl_scache(512000)',
    'gentoo'  => '/var/run/ssl_scache(512000)',
    'Suse'    => '/var/lib/apache2/ssl_scache(512000)'
  }

  ::apache::mod { 'ssl':
    package => $package_name,
  }

  if versioncmp($_apache_version, '2.4') >= 0 {
    ::apache::mod { 'socache_shmcb': }
  }

  # Template uses
  #
  # $ssl_compression
  # $ssl_cryptodevice
  # $ssl_cipher
  # $ssl_honorcipherorder
  # $ssl_options
  # $ssl_openssl_conf_cmd
  # $session_cache
  # $ssl_mutex
  # $ssl_random_seed_bytes
  # $ssl_sessioncachetimeout
  # $_apache_version
  file { 'ssl.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/ssl.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/ssl.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
