# @summary
#   Installs `mod_proxy_html`.
#
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_html.html for additional documentation.
#
class apache::mod::proxy_html {
  include apache
  Class['::apache::mod::proxy'] -> Class['::apache::mod::proxy_html']
  Class['::apache::mod::proxy_http'] -> Class['::apache::mod::proxy_html']

  # Add libxml2
  case $::osfamily {
    /RedHat|FreeBSD|Gentoo|Suse/: {
      ::apache::mod { 'xml2enc': }
      $loadfiles = undef
    }
    'Debian': {
      $gnu_path = $::hardwaremodel ? {
        'i686'  => 'i386',
        default => $::hardwaremodel,
      }
      case $::operatingsystem {
        'Ubuntu': {
          $loadfiles = $facts['operatingsystemmajrelease'] ? {
            '10'    => ['/usr/lib/libxml2.so.2'],
            default => ["/usr/lib/${gnu_path}-linux-gnu/libxml2.so.2"],
          }
        }
        'Debian': {
          $loadfiles = $facts['operatingsystemmajrelease'] ? {
            '6'     => ['/usr/lib/libxml2.so.2'],
            default => ["/usr/lib/${gnu_path}-linux-gnu/libxml2.so.2"],
          }
        }
        default: {
          $loadfiles = ["/usr/lib/${gnu_path}-linux-gnu/libxml2.so.2"]
        }
      }
      if versioncmp($apache::apache_version, '2.4') >= 0 {
        ::apache::mod { 'xml2enc': }
      }
    }
    default: {}
  }

  ::apache::mod { 'proxy_html':
    loadfiles => $loadfiles,
  }

  # Template uses $icons_path
  file { 'proxy_html.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/proxy_html.conf",
    mode    => $apache::file_mode,
    content => template('apache/mod/proxy_html.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
