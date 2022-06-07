# @summary Struct representing reverse proxy configuration for an Apache vhost, used by the Apache::Vhost::Proxy defined resource type.
#
# @param [String[1]] path
#   The virtual path on the local server to map.
#
# @param [String[1]] url
#   The URL to which the path and its children will be mapped.
#
# @param [Optional[Hash]] params
#   Optional [ProxyPass](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass) key-value parameters, such as connection settings.
#
# @param [Array[String[1]]] reverse_urls
#   Optional (but usually recommended) URLs for [ProxyPassReverse](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassreverse) configuration.
#   Allows Apache to adjust certain headers on HTTP redirect responses, to prevent
#   redirects on the back-end from bypassing the reverse proxy.
#
# @param [Optional[Array[Hash]]] reverse_cookies
#   Optional Array of Hashes, each representing a ProxyPassReverseCookieDomain or
#   ProxyPassReverseCookiePath configuration. These are similar to ProxyPassReverse but
#   operate on Domain or Path strings respectively in Set-Cookie headers. Each Hash
#   must contain one `url => value` pair, and exactly one `path => value` or `domain => value`
#   pair, representing the internal domain or internal path.
# @option reverse_cookies [String[1]] :url
#   Required partial URL representing public domain or public path.
# @option reverse_cookies [Optional[String[1]]] :path
#   Internal path for [ProxyPassReverseCookiePath](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassreversecookiepath) configuration.
# @option reverse_cookies [Optional[String[1]]] :domain
#   Internal domain for [ProxyPassReverseCookieDomain](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassreversecookiedomain) configuration.
#
# @param [Optional[Array[String[1]]]] keywords
#   Array of optional keywords such as `nocanon`, `interpolate`, or `noquery` supported
#   by [ProxyPass](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass) (refer
#   to subsection under heading "Additional ProxyPass Keywords").
#
# @param [Optional[Array[String[1]]]] setenv
#   Optional Array of Strings of the form "${env_var_name} ${value}".
#   Uses [SetEnv](https://httpd.apache.org/docs/current/mod/mod_env.html#setenv) to make [Protocol Adjustments](https://httpd.apache.org/docs/current/mod/mod_proxy.html#envsettings) to mod_proxy in the virtual
# host context. Because the implementation uses SetEnv, you must `include apache::mod::env`;
# for the same reason, this cannot set the newer `no-proxy` environment variable, which
# would require an implementation using SetEnvIf.
#
# @param [Optional[Array[String[1]]]] no_proxy_uris
#   Optional Array of paths to exclude from proxying, using the `!` directive to [ProxyPass](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass).
#
# @param [Optional[Array[String[1]]]] no_proxy_uris_match
#   Similar to `no_proxy_uris` but uses [ProxyPassMatch](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassmatch) to allow regular
#   expressions.
#
# @example Basic example
#   { 'path' => '/a', 'url' => 'http://backend-a/', }
#
# @example With parameters
#   { 'path' => '/b', 'url' => 'http://backend-a/b',
#     'params' => {'max'=>20, 'ttl'=>120, 'retry'=>300,}, }
#
# @example With ProxyPassReverse
#   { 'path' => '/l', 'url' => 'http://backend-xy',
#     'reverse_urls' => ['http://backend-x', 'http://backend-y'], }
#
# @example With additional keywords
#   { 'path' => '/e', 'url' => 'http://backend-a/e',
#     'keywords' => ['nocanon', 'interpolate'], }
#
# @example With mod_proxy environment variables
#   { 'path' => '/f', 'url' => 'http://backend-f/',
#     'setenv' => ['proxy-nokeepalive 1','force-proxy-request-1.0 1'], }
#
# @example With ProxyPassReverseCookieDomain and ProxyPassReverseCookiePath
#   { 'path' => '/g', 'url' => 'http://backend-g/',
#     'reverse_cookies' => [{'path' => '/g', 'url' => 'http://backend-g/',}, {'domain' => 'http://backend-g', 'url' => 'http:://backend-g',}], }
#
# @example With exclusions
#   { 'path' => '/h', 'url' => 'http://backend-h/h',
#     'no_proxy_uris' => ['/h/admin', '/h/server-status'], }
#
# @see https://httpd.apache.org/docs/current/mod/mod_proxy.html for additional documentation.
#
type Apache::Vhost::ProxyPass = Struct[{
  path                          => String[1],
  url                           => String[1],
  Optional[params]              => Hash[String[1], Variant[String[1], Integer]],
  Optional[keywords]            => Array[String[1]],
  Optional[reverse_cookies]     => Array[Struct[{
    url    => String[1],
    path   => Optional[String[1]],
    domain => Optional[String[1]],
  }]],
  Optional[reverse_urls]        => Array[String[1]],
  Optional[setenv]              => Array[String[1]],
  Optional[no_proxy_uris]       => Array[String[1]],
  Optional[no_proxy_uris_match] => Array[String[1]],
}]
