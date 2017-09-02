
define apache::vhost::http_protocol_options (
  Pattern[/^((Strict|Unsafe)?\s*(\b(Registered|Lenient)Methods)?\s*(\b(Allow0\.9|Require1\.0))?)$/] $http_protocol_options,
  Optional[String] $vhost                                                           = $name,
) {

  # Template uses:
  # - $http_protocol_options
  concat::fragment { "${vhost}-http_protocol_options":
    target  => "apache::vhost::${vhost}",
    order   => 350,
    content => template('apache/vhost/_http_protocol_options.erb'),
  }
}
