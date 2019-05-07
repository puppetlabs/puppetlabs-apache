# @summary
#   Installs `mod_php`.
# 
# @todo
#   Add docs
class apache::mod::php (
  $package_name     = undef,
  $package_ensure   = 'present',
  $path             = undef,
  Array $extensions = ['.php'],
  $content          = undef,
  $template         = 'apache/mod/php.conf.erb',
  $source           = undef,
  $root_group       = $::apache::params::root_group,
  $php_version      = $::apache::params::php_version,
  $libphp_prefix    = 'libphp'
) inherits apache::params {

  include ::apache
  $mod = "php${php_version}"

  if $::apache::version::scl_httpd_version == undef and $::apache::version::scl_php_version != undef {
    fail('If you define apache::version::scl_php_version, you also need to specify apache::version::scl_httpd_version')
  }
  if defined(Class['::apache::mod::prefork']) {
    Class['::apache::mod::prefork']->File["${mod}.conf"]
  }
  elsif defined(Class['::apache::mod::itk']) {
    Class['::apache::mod::itk']->File["${mod}.conf"]
  }
  else {
    fail('apache::mod::php requires apache::mod::prefork or apache::mod::itk; please enable mpm_module => \'prefork\' or mpm_module => \'itk\' on Class[\'apache\']')
  }

  if $source and ($content or $template != 'apache/mod/php.conf.erb') {
    warning('source and content or template parameters are provided. source parameter will be used')
  } elsif $content and $template != 'apache/mod/php.conf.erb' {
    warning('content and template parameters are provided. content parameter will be used')
  }

  $manage_content = $source ? {
    undef   => $content ? {
      undef   => template($template),
      default => $content,
    },
    default => undef,
  }

  # Determine if we have a package
  $mod_packages = $::apache::mod_packages
  if $package_name {
    $_package_name = $package_name
  } elsif has_key($mod_packages, $mod) { # 2.6 compatibility hack
    $_package_name = $mod_packages[$mod]
  } elsif has_key($mod_packages, 'phpXXX') { # 2.6 compatibility hack
    $_package_name = regsubst($mod_packages['phpXXX'], 'XXX', $php_version)
  } else {
    $_package_name = undef
  }

  $_php_major = regsubst($php_version, '^(\d+)\..*$', '\1')
  $_php_version_no_dot = regsubst($php_version, '\.', '')
  if $apache::version::scl_httpd_version {
    $_lib = "librh-php${_php_version_no_dot}-php${_php_major}.so"
  } else {
    # Controls php version and libphp prefix
    $_lib = "${libphp_prefix}${php_version}.so"
  }

  if $::operatingsystem == 'SLES' {
    ::apache::mod { $mod:
      package        => $_package_name,
      package_ensure => $package_ensure,
      lib            => "mod_${mod}.so",
      id             => "php${_php_major}_module",
      path           => "${::apache::lib_path}/mod_${mod}.so",
    }
  } else {
    ::apache::mod { $mod:
      package        => $_package_name,
      package_ensure => $package_ensure,
      lib            => $_lib,
      id             => "php${_php_major}_module",
      path           => $path,
    }
  }

  include ::apache::mod::mime
  include ::apache::mod::dir
  Class['::apache::mod::mime'] -> Class['::apache::mod::dir'] -> Class['::apache::mod::php']

  # Template uses $extensions
  file { "${mod}.conf":
    ensure  => file,
    path    => "${::apache::mod_dir}/${mod}.conf",
    owner   => 'root',
    group   => $root_group,
    mode    => $::apache::file_mode,
    content => $manage_content,
    source  => $source,
    require => [
      Exec["mkdir ${::apache::mod_dir}"],
    ],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
