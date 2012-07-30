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
# - The $apache_dev is the name of the Apache development libraries package
# - The $logroot is the directory where logs are kept
# - The $ssl_package is the name of the Apache SSL package
# - The $ssl_cert points to your SSL cert. Defaults to Debian's snakeoil
# - The $ssl_key points to your SSL key. Defaults to Debian's snakeoil
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class apache::params {

  case $::operatingsystem {
    'centos', 'redhat', 'fedora', 'scientific', 'amazon': {
      $user               = 'apache'
      $group              = 'apache'
      $apache_name        = 'httpd'
      $php_package        = 'php'
      $mod_python_package = 'mod_python'
      $mod_wsgi_package   = 'mod_wsgi'
      $ssl_package        = 'mod_ssl'
      $apache_dev         = 'httpd-devel'
      $vdir               = '/etc/httpd/conf.d/'
      $logroot            = '/var/log/httpd'
      $ssl_cert           = '/etc/httpd/conf/ssl.crt'
      $ssl_key            = '/etc/httpd/conf/ssl.key'
    }
    'ubuntu', 'debian': {
      $user               = 'www-data'
      $group              = 'www-data'
      $apache_name        = 'apache2'
      $php_package        = 'libapache2-mod-php5'
      $mod_python_package = 'libapache2-mod-python'
      $mod_wsgi_package   = 'libapache2-mod-wsgi'
      $ssl_package        = 'apache-ssl'
      $apache_dev         = ['libaprutil1-dev', 'libapr1-dev', 'apache2-prefork-dev']
      $vdir               = '/etc/apache2/sites-enabled/'
      $logroot            = '/var/log/apache2'
      $ssl_cert           = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
      $ssl_key            = '/etc/ssl/private/ssl-cert-snakeoil.key'
    }
    default: {
      # NOTE: If "default" can refer to anything from SuSE to FreeBSD, then these defaults
      # are wrong. -jtopjian
      $apache_name        = 'apache2'
      $php_package        = 'libapache2-mod-php5'
      $mod_python_package = 'libapache2-mod-python'
      $mod_wsgi_package   = 'libapache2-mod-wsgi'
      $ssl_package        = 'apache-ssl'
      $apache_dev         = 'apache-dev'
      $vdir               = '/etc/apache2/sites-enabled/'
      $ssl_cert          = false
      $ssl_key           = false
    }
  }
}
