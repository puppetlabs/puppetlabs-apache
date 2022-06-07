# @summary Configure a reverse proxy for a vhost
#
# @param vhost
#   The title of the vhost resource to which reverse proxy configuration will
#   be appended.
#
# @param priority
#   Set the priority to match the one `apache::vhost` sets. This must match the
#   one `apache::vhost` sets or else the vhost's `concat` resource won't be found.
#
# @param order
#   The order in which the `concat::fragment` containing the proxy configuration
#   will be inserted. Useful when multiple fragments will be attached to a single
#   vhost's configuration.
#
# @param port
#   Set the port to match the one `apache::vhost` sets. This must match the one
#   `apache::vhost` sets or else the vhost's `concat` resource won't be found.
#
# @param proxy_dest
#   Specifies the destination address of a [ProxyPass](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass) configuration for the `/` path.
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
# @param no_proxy_uris
#   Paths to be excluded from reverse proxying. Only valid when already using `proxy_dest`
#   or `proxy_dest_match` to map the `/` path, otherwise it will be absent in the final
#   vhost configuration file. In that case, instead add `no_proxy_uris => [uri1, uri2, ...]`
#   to the `Apache::Vhost::ProxyPass` definitions passed via the `proxy_pass` parameter.
#   See examples for this class, or refer to documentation for the `Apache::Vhost::ProxyPass`
#   data type. This configuration uses the [ProxyPass](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass) directive with `!`.
#
# @param no_proxy_uris_match
#   This directive is equivalent to `no_proxy_uris` but takes regular expressions,
#   as it instead uses [ProxyPassMatch](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassmatch).
#
# @param proxy_pass
#   Specifies an array of `path => URI` values for a [ProxyPass](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass)
#   configuration.
#   See the documentation for the Apache::Vhost::ProxyPass data type for a detailed
#   description of the structure including optional parameters.
#
# @param proxy_pass_match
#   This directive is equivalent to `proxy_pass`, but takes regular expressions, see
#   [ProxyPassMatch](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassmatch)
#   for details.
#
# @param proxy_requests
#   Enables forward (standard) proxy requests. See [ProxyRequests](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxyrequests) for details.
#
# @param proxy_preserve_host
#   When enabled, pass the `Host:` line from the incoming request to the proxied host.
#   See [ProxyPreserveHost](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypreservehost) for details.
#
# @param proxy_add_headers
#   Add X-Forwarded-For, X-Forwarded-Host, and X-Forwarded-Server HTTP headers.
#   See [ProxyAddHeaders](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxyaddheaders) for details.
#
# @param proxy_error_override
#   Override error pages from the proxied host. The current Puppet implementation
#   supports enabling or disabling the directive, but not specifying a custom list
#   of status codes. See [ProxyErrorOverride](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxyerroroverride) for details.
#
# @example Simple configuration proxying "/" but not "/admin"
#   include apache
#   apache::vhost { 'basic-proxy-vhost':
#   }
#   apache::vhost::proxy { 'proxy-to-backend-server':
#     vhost => 'basic-proxy-vhost',
#     proxy_dest => 'http://backend-server/',
#     no_proxy_uris => '/admin',
#   }
#
# @example Granular configuration using `Apache::Vhost::ProxyPass` data type
#   include apache
#   apache::vhost { 'myvhost':
#   }
#   apache::vhost::proxy { 'myvhost-proxy':
#     vhost      => 'myvhost',
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
#
define apache::vhost::proxy (
  String[1] $vhost,
  Optional[Variant[Integer,String,Boolean]] $priority = undef,
  Integer[0] $order = 170,
  Optional[Stdlib::Port] $port = undef,
  Optional[String[1]] $proxy_dest = undef,
  Optional[String[1]] $proxy_dest_match = undef,
  Optional[String[1]] $proxy_dest_reverse_match = undef,
  Variant[Array[String[1]], String[1]] $no_proxy_uris = [],
  Variant[Array[String[1]], String[1]] $no_proxy_uris_match = [],
  Optional[Array[Apache::Vhost::ProxyPass]] $proxy_pass = undef,
  Optional[Array[Apache::Vhost::ProxyPass]] $proxy_pass_match = undef,
  Boolean $proxy_requests = false,
  Boolean $proxy_preserve_host = false,
  Optional[Boolean] $proxy_add_headers = undef,
  Boolean $proxy_error_override = false,
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
