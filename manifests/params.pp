# Class: apache::params
#
# This class manages Apache parameters
#
# Parameters:
# - The $user that Apache runs as
# - The $group that Apache runs as
# - The $apache_name is the name of the package and service on the relevant
#   distribution
# - The $php_package is the name of the package that provided PHP
# - The $ssl_package is the name of the Apache SSL package
# - The $apache_dev is the name of the Apache development libraries package
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class apache::params {

  $ssl           = true
  $template      = 'apache/vhost-default.conf.erb'
  $priority      = '25'
  $servername    = ''
  $serveraliases = ''
  $auth          = false
  $redirect_ssl  = false
  $options       = 'Indexes FollowSymLinks MultiViews'
  $override      = 'None'
  $vhost_name    = '*'

  if $::osfamily == 'redhat' or $::operatingsystem == 'amazon' {
    $user                  = 'apache'
    $group                 = 'apache'
    $apache_name           = 'httpd'
    $php_package           = 'php'
    $mod_python_package    = 'mod_python'
    $mod_wsgi_package      = 'mod_wsgi'
    $mod_auth_kerb_package = 'mod_auth_kerb'
    $ssl_package           = 'mod_ssl'
    $apache_dev            = 'httpd-devel'
    $httpd_dir             = '/etc/httpd'
    $conf_dir              = "${httpd_dir}/conf"
    $mod_dir               = "${httpd_dir}/mod.d"
    $vdir                  = "${httpd_dir}/conf.d"
    $conf_file             = 'httpd.conf'
    $mod_packages          = {
      'dev'        => 'httpd-devel',
      'fcgid'      => 'mod_fcgid',
      'perl'       => 'mod_perl',
      'php5'       => 'php',
      'proxy_html' => 'mod_proxy_html',
      'python'     => 'mod_python',
      'ssl'        => 'mod_ssl',
      'wsgi'       => 'mod_wsgi',
    }
    $mod_libs              = {
      'php5' => 'libphp5.so',
    }
  } elsif $::osfamily == 'debian' {
    $user                  = 'www-data'
    $group                 = 'www-data'
    $apache_name           = 'apache2'
    $php_package           = 'libapache2-mod-php5'
    $mod_python_package    = 'libapache2-mod-python'
    $mod_wsgi_package      = 'libapache2-mod-wsgi'
    $mod_auth_kerb_package = 'libapache2-mod-auth-kerb'
    $apache_dev            = ['libaprutil1-dev', 'libapr1-dev', 'apache2-prefork-dev']
    $vdir                  = '/etc/apache2/sites-enabled/'
    $proxy_modules         = ['proxy', 'proxy_http']
    $mod_packages          = {
      'dev'    => ['libaprutil1-dev', 'libapr1-dev', 'apache2-prefork-dev'],
      'fcgid'  => 'libapache2-mod-fcgid',
      'perl'   => 'libapache2-mod-perl2',
      'php5'   => 'libapache2-mod-php5',
      'python' => 'libapache2-mod-python',
      'wsgi'   => 'libapache2-mod-wsgi',
    }
    $mod_libs              = {}
  } else {
    fail("Class['apache::params']: Unsupported operatingsystem: $operatingsystem")
  }
}
