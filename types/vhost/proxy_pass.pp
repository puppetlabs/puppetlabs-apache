# @summary A proxy pass definition for in an Apache vhost
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
