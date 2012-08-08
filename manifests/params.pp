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
    $vdir                  = "${httpd_dir}/conf.d"
    $conf_file             = 'httpd.conf'
  } elsif $::osfamily == 'debian' {
    $user                  = 'www-data'
    $group                 = 'www-data'
    $apache_name           = 'apache2'
    $php_package           = 'libapache2-mod-php5'
    $mod_python_package    = 'libapache2-mod-python'
    $mod_wsgi_package      = 'libapache2-mod-wsgi'
    $mod_auth_kerb_package = 'libapache2-mod-auth-kerb'
    $ssl_package           = 'apache-ssl'
    $apache_dev            = ['libaprutil1-dev', 'libapr1-dev', 'apache2-prefork-dev']
    $vdir                  = '/etc/apache2/sites-enabled/'
    $proxy_modules         = ['proxy', 'proxy_http']
  } else {
    $user                  = 'www-data'
    $group                 = 'www-data'
    $apache_name           = 'apache2'
    $php_package           = 'libapache2-mod-php5'
    $mod_python_package    = 'libapache2-mod-python'
    $mod_wsgi_package      = 'libapache2-mod-wsgi'
    $mod_auth_kerb_package = 'libapache2-mod-auth-kerb'
    $ssl_package           = 'apache-ssl'
    $apache_dev            = 'apache-dev'
    $vdir                  = '/etc/apache2/sites-enabled/'
    $proxy_modules         = ['proxy', 'proxy_http']
  }
}
