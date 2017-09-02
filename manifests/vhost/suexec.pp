
define apache::vhost::suexec (
  Optional[Pattern[/^[\w-]+ [\w-]+$/]] $suexec_user_group                           = undef,
  Optional[String] $vhost                                                           = $name,
) {

  if $suexec_user_group {
    include ::apache::mod::suexec
  }

  # Template uses:
  # - $suexec_user_group
  if $suexec_user_group {
    concat::fragment { "${vhost}-suexec":
      target  => "apache::vhost::${vhost}",
      order   => 290,
      content => template('apache/vhost/_suexec.erb'),
    }
  }
}
