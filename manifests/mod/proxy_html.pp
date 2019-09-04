# @summary
#   Installs `mod_proxy_html`.
#
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_html.html for additional documentation.
#
# @param package_name
#   Name of proxy_html package to install.
#
class apache::mod::proxy_html (
  $package_name = undef,
) {
  include ::apache
  Class['::apache::mod::proxy'] -> Class['::apache::mod::proxy_html']
  Class['::apache::mod::proxy_http'] -> Class['::apache::mod::proxy_html']

  # Add libxml2
  case $::osfamily {
    /RedHat|FreeBSD|Gentoo|Suse/: {
      ::apache::mod { 'xml2enc':
        package => $package_name,
      }
      $loadfiles = undef
    }
    'Debian': {
      $gnu_path = $::hardwaremodel ? {
        'i686'  => 'i386',
        default => $::hardwaremodel,
      }
      $loadfiles = $::apache::params::distrelease ? {
        '6'     => ['/usr/lib/libxml2.so.2'],
        '10'    => ['/usr/lib/libxml2.so.2'],
        default => ["/usr/lib/${gnu_path}-linux-gnu/libxml2.so.2"],
      }
      if versioncmp($::apache::apache_version, '2.4') >= 0 {
        ::apache::mod { 'xml2enc':
          package => $package_name,
        }
      }
    }
  }

  ::apache::mod { 'proxy_html':
    loadfiles => $loadfiles,
    package   => $package_name,
  }

  # Template uses $icons_path
  file { 'proxy_html.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/proxy_html.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/proxy_html.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
