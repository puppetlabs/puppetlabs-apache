# @summary
#   Installs `mod_ssl`.
# 
# @param ssl_compression
#   Enable compression on the SSL level.
#
# @param ssl_sessiontickets
#   Enable or disable use of TLS session tickets
#
# @param ssl_cryptodevice
#   Enable use of a cryptographic hardware accelerator.
#
# @param ssl_options
#   Configure various SSL engine run-time options.
#
# @param ssl_openssl_conf_cmd
#   Configure OpenSSL parameters through its SSL_CONF API.
#
# @param ssl_cert
#   Path to server PEM-encoded X.509 certificate data file.
#
# @param ssl_key
#   Path to server PEM-encoded private key file
#
# @param ssl_ca
#   File of concatenated PEM-encoded CA Certificates for Client Auth.
#
# @param ssl_cipher
#   Cipher Suite available for negotiation in SSL handshake.
#
# @param ssl_honorcipherorder
#   Option to prefer the server's cipher preference order.
#
# @param ssl_protocol
#   Configure usable SSL/TLS protocol versions.
#   Default based on the OS:
#   - RedHat 8: [ 'all' ].
#   - Other Platforms: [ 'all', '-SSLv2', '-SSLv3' ].
#
# @param ssl_proxy_protocol
#   Configure usable SSL protocol flavors for proxy usage.
#
# @param ssl_proxy_cipher_suite
#   Configure usable SSL ciphers for proxy usage. Equivalent to ssl_cipher but for proxy connections.
#
# @param ssl_pass_phrase_dialog
#   Type of pass phrase dialog for encrypted private keys.
#
# @param ssl_random_seed_bytes
#   Pseudo Random Number Generator (PRNG) seeding source.
#
# @param ssl_sessioncache
#   Configures the storage type of the global/inter-process SSL Session Cache
#
# @param ssl_sessioncachetimeout
#   Number of seconds before an SSL session expires in the Session Cache.
#
# @param ssl_stapling
#   Enable stapling of OCSP responses in the TLS handshake.
#
# @param stapling_cache
#   Configures the cache used to store OCSP responses which get included in
#   the TLS handshake if SSLUseStapling is enabled.
#
# @param ssl_stapling_return_errors
#   Pass stapling related OCSP errors on to client.
#
# @param ssl_mutex
#   Configures mutex mechanism and lock file directory for all or specified mutexes.
#   Default based on the OS and/or Apache version:
#   - RedHat/FreeBSD/Suse/Gentoo: 'default'.
#   - Debian/Ubuntu + Apache >= 2.4: 'default'.
#   - Debian/Ubuntu + Apache < 2.4: 'file:${APACHE_RUN_DIR}/ssl_mutex'.
#
# @param ssl_reload_on_change
#   Enable reloading of apache if the content of ssl files have changed. It only affects ssl files configured here and not vhost ones.
#
# @param package_name
#   Name of ssl package to install.
#
# On most operating systems, the ssl.conf is placed in the module configuration directory. On Red Hat based operating systems, this
# file is placed in /etc/httpd/conf.d, the same location in which the RPM stores the configuration.
#
# To use SSL with a virtual host, you must either set the default_ssl_vhost parameter in ::apache to true or the ssl parameter in 
# apache::vhost to true.
#
# @see https://httpd.apache.org/docs/current/mod/mod_ssl.html for additional documentation.
#
class apache::mod::ssl (
  Boolean $ssl_compression                                  = false,
  Optional[Boolean] $ssl_sessiontickets                     = undef,
  String $ssl_cryptodevice                                  = 'builtin',
  Array[String] $ssl_options                                = ['StdEnvVars'],
  Optional[String] $ssl_openssl_conf_cmd                    = undef,
  Optional[Stdlib::Absolutepath] $ssl_cert                  = undef,
  Optional[Stdlib::Absolutepath] $ssl_key                   = undef,
  Optional[Stdlib::Absolutepath] $ssl_ca                    = undef,
  String $ssl_cipher                                        = $apache::params::ssl_cipher,
  Variant[Boolean, Enum['on', 'off']] $ssl_honorcipherorder = true,
  Array[String] $ssl_protocol                               = $apache::params::ssl_protocol,
  Array $ssl_proxy_protocol                                 = [],
  Optional[String[1]] $ssl_proxy_cipher_suite               = $apache::params::ssl_proxy_cipher_suite,
  String $ssl_pass_phrase_dialog                            = 'builtin',
  Integer $ssl_random_seed_bytes                            = 512,
  String $ssl_sessioncache                                  = $apache::params::ssl_sessioncache,
  Integer $ssl_sessioncachetimeout                          = 300,
  Boolean $ssl_stapling                                     = false,
  Optional[String] $stapling_cache                          = undef,
  Optional[Boolean] $ssl_stapling_return_errors             = undef,
  String $ssl_mutex                                         = 'default',
  Boolean $ssl_reload_on_change                             = false,
  Optional[String] $package_name                            = undef,
) inherits apache::params {
  include apache
  include apache::mod::mime

  if $ssl_honorcipherorder =~ Boolean {
    $_ssl_honorcipherorder = $ssl_honorcipherorder
  } else {
    $_ssl_honorcipherorder = $ssl_honorcipherorder ? {
      'on'    => true,
      'off'   => false,
      default => true,
    }
  }

  if $stapling_cache =~ Undef {
    $_stapling_cache = $facts['os']['family'] ? {
      'Debian'  => "\${APACHE_RUN_DIR}/ocsp(32768)",
      'edHat'  => '/run/httpd/ssl_stapling(32768)',
      'FreeBSD' => '/var/run/ssl_stapling(32768)',
      'Gentoo'  => '/var/run/ssl_stapling(32768)',
      'Suse'    => '/var/lib/apache2/ssl_stapling(32768)',
    }
  } else {
    $_stapling_cache = $stapling_cache
  }

  if $facts['os']['family'] == 'Suse' {
    if defined(Class['apache::mod::worker']) {
      $suse_path = '/usr/lib64/apache2-worker'
    } else {
      $suse_path = '/usr/lib64/apache2-prefork'
    }
    ::apache::mod { 'ssl':
      package  => $package_name,
      lib_path => $suse_path,
    }
  } else {
    ::apache::mod { 'ssl':
      package => $package_name,
    }
  }

  include apache::mod::socache_shmcb

  if $ssl_reload_on_change {
    [$ssl_cert, $ssl_key, $ssl_ca].each |$ssl_file| {
      if $ssl_file {
        include apache::mod::ssl::reload
        $_ssl_file_copy = regsubst($ssl_file, '/', '_', 'G')
        file { $_ssl_file_copy:
          path    => "${apache::params::puppet_ssl_dir}/${_ssl_file_copy}",
          source  => "file://${ssl_file}",
          owner   => 'root',
          group   => $apache::params::root_group,
          mode    => '0640',
          seltype => 'cert_t',
          notify  => Class['apache::service'],
        }
      }
    }
  }

  # Template uses
  #
  # $ssl_compression
  # $ssl_sessiontickets
  # $ssl_cryptodevice
  # $ssl_ca
  # $ssl_cipher
  # $ssl_honorcipherorder
  # $ssl_options
  # $ssl_openssl_conf_cmd
  # $ssl_sessioncache
  # $_stapling_cache
  # $ssl_mutex
  # $ssl_random_seed_bytes
  # $ssl_sessioncachetimeout
  file { 'ssl.conf':
    ensure  => file,
    path    => $apache::_ssl_file,
    mode    => $apache::file_mode,
    content => template('apache/mod/ssl.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
