class apache::mod::mime (
  $mime_support_package = $::osfamily ? {
    'freebsd'  => 'misc/mime-support',
    # 'debian' => 'mime-support', # XXX: consider uncommenting this case
    default    => undef,
  },
) {
  apache::mod { 'mime': }
  $types_config = $::osfamily ? {
    'freebsd' => '/usr/local/etc/mime.types',
    default   => '/etc/mime.types',
  }
  # Template uses $types_config
  file { 'mime.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/mime.conf",
    content => template('apache/mod/mime.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }
  if $mime_support_package {
    package { $mime_support_package:
      ensure => 'installed',
      before => File["${apache::mod_dir}/mime.conf"],
    }
  }
}
