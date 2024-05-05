# @summary
#   Installs `mod_php`.
#
# @param package_name
#   The package name
#
# @param package_ensure
#   Whether the package is `present` or `absent`
#
# @param path
#
# @param extensions
#
# @param content
#
# @param template
#
# @param source
#
# @param root_group
#   UNIX group of the root user
#
# @param php_version
#   The php version. This is a required parameter, but optional allows showing a clear error message
#
# @param libphp_prefix
#
# @note Unsupported platforms: RedHat: 9
class apache::mod::php (
  Optional[String] $package_name = undef,
  String $package_ensure         = 'present',
  Optional[String] $path         = undef,
  Array $extensions              = ['.php'],
  Optional[String] $content      = undef,
  String $template               = 'apache/mod/php.conf.erb',
  Optional[String] $source       = undef,
  Optional[String] $root_group   = $apache::params::root_group,
  Optional[String] $php_version  = $apache::params::php_version,
  String $libphp_prefix          = 'libphp'
) inherits apache::params {
  unless $php_version {
    fail("${facts['os']['name']} ${facts['os']['release']['major']} does not support mod_php")
  }

  include apache
  # RedHat + PHP 8 drop the major version in apache module name.
  if ($facts['os']['family'] == 'RedHat') and (versioncmp($php_version, '8') >= 0) {
    $mod = 'php'
  } else {
    $mod = "php${php_version}"
  }

  if $apache::version::scl_httpd_version == undef and $apache::version::scl_php_version != undef {
    fail('If you define apache::version::scl_php_version, you also need to specify apache::version::scl_httpd_version')
  }
  if defined(Class['apache::mod::prefork']) {
    Class['apache::mod::prefork'] ->File["${mod}.conf"]
  }
  elsif defined(Class['apache::mod::itk']) {
    Class['apache::mod::itk'] ->File["${mod}.conf"]
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
      undef   => $template ? {
        /\.epp\z/ => epp($template, { 'extensions' => $extensions }),
        default   => template($template),
      },
      default => $content,
    },
    default => undef,
  }

  # Determine if we have a package
  $mod_packages = $apache::mod_packages
  if $package_name {
    $_package_name = $package_name
  } elsif $mod in $mod_packages { # 2.6 compatibility hack
    $_package_name = $mod_packages[$mod]
  } elsif 'phpXXX' in $mod_packages { # 2.6 compatibility hack
    $_package_name = regsubst($mod_packages['phpXXX'], 'XXX', $php_version)
  } else {
    $_package_name = undef
  }

  $_php_major = regsubst($php_version, '^(\d+)\..*$', '\1')
  $_php_version_no_dot = regsubst($php_version, '\.', '')
  if $apache::version::scl_httpd_version {
    $_lib = "librh-php${_php_version_no_dot}-php${_php_major}.so"
  } elsif ($facts['os']['family'] == 'RedHat') and (versioncmp($php_version, '8') >= 0) {
    # RedHat + PHP 8 drop the major version in apache module name.
    $_lib = "${libphp_prefix}.so"
  } else {
    $_lib = "${libphp_prefix}${php_version}.so"
  }
  $_module_id = $_php_major ? {
    '5'     => 'php5_module',
    '7'     => 'php7_module',
    default => 'php_module',
  }

  if $facts['os']['name'] == 'SLES' {
    # Enable legacy repo to install apache2-mod_php7 package
    # if SUSE OS major version is >= 15 and minor version is > 3
    if ($_package_name == 'apache2-mod_php7' and versioncmp($facts['os']['release']['major'], '15') >= 0 and versioncmp($facts['os']['release']['minor'], '3') == 1) {
      exec { 'enable legacy repos':
        path    => '/bin:/usr/bin/:/sbin:/usr/sbin',
        command => 'SUSEConnect --product sle-module-legacy/15.5/x86_64',
        unless  => 'SUSEConnect --status-text | grep sle-module-legacy/15.5/x86_64',
      }
    }

    ::apache::mod { $mod:
      package        => $_package_name,
      package_ensure => $package_ensure,
      lib            => "mod_${mod}.so",
      id             => $_module_id,
      path           => "${apache::lib_path}/mod_${mod}.so",
    }
  } else {
    ::apache::mod { $mod:
      package        => $_package_name,
      package_ensure => $package_ensure,
      lib            => $_lib,
      id             => $_module_id,
      path           => $path,
    }
  }

  include apache::mod::mime
  include apache::mod::dir
  Class['apache::mod::mime'] -> Class['apache::mod::dir'] -> Class['apache::mod::php']

  # Template uses $extensions
  file { "${mod}.conf":
    ensure  => file,
    path    => "${apache::mod_dir}/${mod}.conf",
    owner   => 'root',
    group   => $root_group,
    mode    => $apache::file_mode,
    content => $manage_content,
    source  => $source,
    require => [
      Exec["mkdir ${apache::mod_dir}"],
    ],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
