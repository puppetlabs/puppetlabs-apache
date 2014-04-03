class apache::mod::negotiation (
  $content  = '',
  $template = 'apache/mod/negotiation.conf.erb',
  $source   = '',
) {
  $manage_content = $content ? {
    ''      => $template ? {
      ''      => undef,
      default => template($template),
    },
    default => $content,
  }
  $manage_source = $source ? {
    ''      => undef,
    default => $source,
  }

  ::apache::mod { 'negotiation': }
  # Template uses no variables
  file { 'negotiation.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/negotiation.conf",
    content => $manage_content,
    source  => $manage_source,
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Service['httpd'],
  }
}
