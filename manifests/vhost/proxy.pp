# @summary Configure a reverse reverse proxy for a vhost
#
# @param proxy_dest
#   Specifies the destination address of a [ProxyPass](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass) configuration.
#
# @param proxy_pass
#   Specifies an array of `path => URI` values for a [ProxyPass](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass)
#   configuration. Optionally, parameters can be added as an array.
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     proxy_pass => [
#       { 'path' => '/a', 'url' => 'http://backend-a/' },
#       { 'path' => '/b', 'url' => 'http://backend-b/' },
#       { 'path' => '/c', 'url' => 'http://backend-a/c', 'params' => {'max'=>20, 'ttl'=>120, 'retry'=>300}},
#       { 'path' => '/l', 'url' => 'http://backend-xy',
#         'reverse_urls' => ['http://backend-x', 'http://backend-y'] },
#       { 'path' => '/d', 'url' => 'http://backend-a/d',
#         'params' => { 'retry' => '0', 'timeout' => '5' }, },
#       { 'path' => '/e', 'url' => 'http://backend-a/e',
#         'keywords' => ['nocanon', 'interpolate'] },
#       { 'path' => '/f', 'url' => 'http://backend-f/',
#         'setenv' => ['proxy-nokeepalive 1','force-proxy-request-1.0 1']},
#       { 'path' => '/g', 'url' => 'http://backend-g/',
#         'reverse_cookies' => [{'path' => '/g', 'url' => 'http://backend-g/',}, {'domain' => 'http://backend-g', 'url' => 'http:://backend-g',},], },
#       { 'path' => '/h', 'url' => 'http://backend-h/h',
#         'no_proxy_uris' => ['/h/admin', '/h/server-status'] },
#     ],
#   }
#   ```
#   * `reverse_urls`. *Optional.* This setting is useful when used with `mod_proxy_balancer`. Values: an array or string.
#   * `reverse_cookies`. *Optional.* Sets `ProxyPassReverseCookiePath` and `ProxyPassReverseCookieDomain`.
#   * `params`. *Optional.* Allows for ProxyPass key-value parameters, such as connection settings.
#   * `setenv`. *Optional.* Sets [environment variables](https://httpd.apache.org/docs/current/mod/mod_proxy.html#envsettings) for the proxy directive. Values: array.
#
# @param proxy_dest_match
#   This directive is equivalent to `proxy_dest`, but takes regular expressions, see
#   [ProxyPassMatch](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassmatch)
#   for details.
#
# @param proxy_dest_reverse_match
#   Allows you to pass a ProxyPassReverse if `proxy_dest_match` is specified. See
#   [ProxyPassReverse](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassreverse)
#   for details.
#
# @param proxy_pass_match
#   This directive is equivalent to `proxy_pass`, but takes regular expressions, see
#   [ProxyPassMatch](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassmatch)
#   for details.
define apache::vhost::proxy(
  String[1] $vhost,
  $priority = undef,
  Integer[0] $order = 170,
  Optional[Stdlib::Port] $port = undef,
  Optional[String[1]] $proxy_dest = undef,
  Optional[Array[Apache::Vhost::ProxyPass]] $proxy_pass = undef,
  Optional[Array[Apache::Vhost::ProxyPass]] $proxy_pass_match = undef,
  Optional[String[1]] $proxy_dest_match = undef,
  Optional[String[1]] $proxy_dest_reverse_match = undef,
  Boolean $proxy_requests = false,
  Boolean $proxy_preserve_host = false,
  Optional[Boolean] $proxy_add_headers = undef,
  Boolean $proxy_error_override = false,
  Variant[Array[String[1]], String[1]] $no_proxy_uris = [],
  Variant[Array[String[1]], String[1]] $no_proxy_uris_match = [],
) {
  include apache::mod::proxy
  include apache::mod::proxy_http

  unless $proxy_dest or $proxy_pass or $proxy_pass_match or $proxy_dest_match {
    fail('At least one of proxy_dest, proxy_pass, proxy_pass_match or proxy_dest_match must be given')
  }

  apache::vhost::fragment { "${name}-proxy":
    vhost    => $vhost,
    port     => $port,
    priority => $priority,
    order    => $order,
    content  => template('apache/vhost/_proxy.erb'),
  }
}
