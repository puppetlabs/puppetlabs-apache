
define apache::vhost::ssl (
  Boolean $ssl                                                                      = false,
  $ssl_cert                                                                         = $::apache::default_ssl_cert,
  $ssl_key                                                                          = $::apache::default_ssl_key,
  $ssl_chain                                                                        = $::apache::default_ssl_chain,
  $ssl_ca                                                                           = $::apache::default_ssl_ca,
  $ssl_crl_path                                                                     = $::apache::default_ssl_crl_path,
  $ssl_crl                                                                          = $::apache::default_ssl_crl,
  $ssl_crl_check                                                                    = $::apache::default_ssl_crl_check,
  $ssl_certs_dir                                                                    = $::apache::params::ssl_certs_dir,
  $ssl_protocol                                                                     = undef,
  $ssl_cipher                                                                       = undef,
  $ssl_honorcipherorder                                                             = undef,
  $ssl_verify_client                                                                = undef,
  $ssl_verify_depth                                                                 = undef,
  $ssl_options                                                                      = undef,
  $ssl_openssl_conf_cmd                                                             = undef,
  Optional[Boolean] $ssl_stapling                                                   = undef,
  $ssl_stapling_timeout                                                             = undef,
  $ssl_stapling_return_errors                                                       = undef,
  $apache_version                                                                   = $::apache::apache_version,
  Optional[String] $vhost                                                           = $name,
) {

  if $ssl {
    include ::apache::mod::ssl
    # Required for the AddType lines.
    include ::apache::mod::mime
  }

  # Template uses:
  # - $ssl
  # - $ssl_cert
  # - $ssl_key
  # - $ssl_chain
  # - $ssl_certs_dir
  # - $ssl_ca
  # - $ssl_crl_path
  # - $ssl_crl
  # - $ssl_crl_check
  # - $ssl_protocol
  # - $ssl_cipher
  # - $ssl_honorcipherorder
  # - $ssl_verify_client
  # - $ssl_verify_depth
  # - $ssl_options
  # - $ssl_openssl_conf_cmd
  # - $ssl_stapling
  # - $ssl_stapling_timeout
  # - $ssl_stapling_return_errors
  # - $apache_version
  if $ssl {
    concat::fragment { "${vhost}-ssl":
      target  => "apache::vhost::${vhost}",
      order   => 230,
      content => template('apache/vhost/_ssl.erb'),
    }
  }
}
