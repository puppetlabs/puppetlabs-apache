
define apache::vhost::sslproxy (
  Optional[Enum['none', 'optional', 'require', 'optional_no_ca']] $ssl_proxy_verify = undef,
  $ssl_proxy_verify_depth                                                           = undef,
  $ssl_proxy_ca_cert                                                                = undef,
  Optional[Enum['on', 'off']] $ssl_proxy_check_peer_cn                              = undef,
  Optional[Enum['on', 'off']] $ssl_proxy_check_peer_name                            = undef,
  Optional[Enum['on', 'off']] $ssl_proxy_check_peer_expire                          = undef,
  $ssl_proxy_machine_cert                                                           = undef,
  $ssl_proxy_cipher_suite                                                           = undef,
  $ssl_proxy_protocol                                                               = undef,
  Boolean $ssl_proxyengine                                                          = false,
  Optional[String] $vhost                                                           = $name,
) {

  if $ssl_proxy_verify_depth {
    validate_integer($ssl_proxy_verify_depth)
  }

  # Template uses:
  # - $ssl_proxyengine
  # - $ssl_proxy_verify
  # - $ssl_proxy_verify_depth
  # - $ssl_proxy_ca_cert
  # - $ssl_proxy_check_peer_cn
  # - $ssl_proxy_check_peer_name
  # - $ssl_proxy_check_peer_expire
  # - $ssl_proxy_machine_cert
  # - $ssl_proxy_cipher_suite
  # - $ssl_proxy_protocol
  if $ssl_proxyengine {
    concat::fragment { "${vhost}-sslproxy":
      target  => "apache::vhost::${vhost}",
      order   => 230,
      content => template('apache/vhost/_sslproxy.erb'),
    }
  }
}
