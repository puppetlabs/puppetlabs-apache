class apache::mod::php (
  $package_name   = undef,
  $package_ensure = 'present',
  $path           = undef,
  $content        = '',
  $template       = 'apache/mod/php5.conf.erb',
  $source         = '',
) {
  if ! defined(Class['apache::mod::prefork']) {
    fail('apache::mod::php requires apache::mod::prefork; please enable mpm_module => \'prefork\' on Class[\'apache\']')
  }
  $manage_content = $source ? {
    ''      => $content ? {
      ''      => template($template),
      default => $content,
    },
    default => undef,
  }

  $manage_source = $source ? {
    ''      => undef,
    default => $source,
  }

  ::apache::mod { 'php5':
    package        => $package_name,
    package_ensure => $package_ensure,
    path           => $path,
  }

  include ::apache::mod::mime
  include ::apache::mod::dir
  Class['::apache::mod::mime'] -> Class['::apache::mod::dir'] -> Class['::apache::mod::php']

  file { 'php5.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/php5.conf",
    content => $manage_content,
    source  => $manage_source,
    require => [
      Class['::apache::mod::prefork'],
      Exec["mkdir ${::apache::mod_dir}"],
    ],
    before  => File[$::apache::mod_dir],
    notify  => Service['httpd'],
  }
}
