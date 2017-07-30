
define apache::vhost::proxy (
  $proxy_dest                                                                       = undef,
  $proxy_dest_match                                                                 = undef,
  $proxy_dest_reverse_match                                                         = undef,
  $proxy_pass                                                                       = undef,
  $proxy_pass_match                                                                 = undef,
  $no_proxy_uris                                                                    = [],
  $no_proxy_uris_match                                                              = [],
  $proxy_preserve_host                                                              = false,
  $proxy_add_headers                                                                = undef,
  $proxy_error_override                                                             = false,
  Optional[String] $vhost                                                           = $name,
) {

  # Load mod_proxy if needed and not yet loaded
  if ($proxy_dest or $proxy_pass or $proxy_pass_match or $proxy_dest_match) {
    if ! defined(Class['apache::mod::proxy']) {
      include ::apache::mod::proxy
    }
    if ! defined(Class['apache::mod::proxy_http']) {
      include ::apache::mod::proxy_http
    }
  }

  # Template uses:
  # - $no_proxy_uris
  # - $no_proxy_uris_match
  # - $proxy_add_headers
  # - $proxy_dest
  # - $proxy_dest_match
  # - $proxy_dest_reverse_match
  # - $proxy_error_override
  # - $proxy_pass
  # - $proxy_pass_match
  # - $proxy_preserve_host
  if $proxy_dest or $proxy_pass or $proxy_pass_match or $proxy_dest_match or $proxy_preserve_host {
    concat::fragment { "${vhost}-proxy":
      target  => "apache::vhost::${vhost}",
      order   => 160,
      content => template('apache/vhost/_proxy.erb'),
    }
  }

}
