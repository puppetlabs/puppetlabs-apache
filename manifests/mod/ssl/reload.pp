# @summary
#   Manages the puppet_ssl folder for ssl file copies, which is needed to track changes for reloading service on changes
#
# @api private
class apache::mod::ssl::reload () inherits ::apache::params {
  file { $apache::params::puppet_ssl_dir:
    ensure  => directory,
    purge   => true,
    recurse => true,
    require => Package['httpd'],
  }
  file { 'README.txt':
    path    => "${apache::params::puppet_ssl_dir}/README.txt",
    content => 'This directory contains puppet managed copies of ssl files, so it can track changes and reload apache on changes.',
    seltype => 'etc_t',
  }
}
