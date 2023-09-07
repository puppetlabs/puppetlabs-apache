# @summary
#   Installs `mod_proxy_html`.
#
# @see https://httpd.apache.org/docs/current/mod/mod_proxy_html.html for additional documentation.
#
class apache::mod::proxy_html {
  include apache
  require apache::mod::proxy
  require apache::mod::proxy_http

  # Add libxml2
  case $facts['os']['family'] {
    /RedHat|FreeBSD|Gentoo|Suse/: {
      ::apache::mod { 'xml2enc': }
      $loadfiles = undef
    }
    'Debian': {
      $gnu_path = $facts['os']['hardware'] ? {
        'i686'  => 'i386',
        default => $facts['os']['hardware'],
      }
      case $facts['os']['name'] {
        'Ubuntu': {
          $loadfiles = $facts['os']['release']['major'] ? {
            '10'    => ['/usr/lib/libxml2.so.2'],
            default => ["/usr/lib/${gnu_path}-linux-gnu/libxml2.so.2"],
          }
        }
        'Debian': {
          $loadfiles = $facts['os']['release']['major'] ? {
            '6'     => ['/usr/lib/libxml2.so.2'],
            default => ["/usr/lib/${gnu_path}-linux-gnu/libxml2.so.2"],
          }
        }
        default: {
          $loadfiles = ["/usr/lib/${gnu_path}-linux-gnu/libxml2.so.2"]
        }
      }
      ::apache::mod { 'xml2enc': }
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
    content => epp('apache/mod/proxy_html.conf.epp'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
