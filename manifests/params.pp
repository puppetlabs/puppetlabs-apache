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
# - The $conf_contents is the contents of the Apache configuration file
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class apache::params {
  # This will be 5 or 6 on RedHat, 6 or wheezy on Debian, 12 or quantal on Ubuntu, 3 on Amazon, etc.
  $osr_array = split($::operatingsystemrelease,'[\/\.]')
  $distrelease = $osr_array[0]
  if ! $distrelease {
    fail("Class['apache::params']: Unparsable \$::operatingsystemrelease: ${::operatingsystemrelease}")
  }

  if($::fqdn) {
    $servername = $::fqdn
  } else {
    $servername = $::hostname
  }

  if $::osfamily == 'RedHat' or $::operatingsystem == 'amazon' {
    $user                 = 'apache'
    $group                = 'apache'
    $root_group           = 'root'
    $apache_name          = 'httpd'
    $service_name         = 'httpd'
    $httpd_dir            = '/etc/httpd'
    $server_root          = '/etc/httpd'
    $conf_dir             = "${httpd_dir}/conf"
    $confd_dir            = "${httpd_dir}/conf.d"
    $mod_dir              = "${httpd_dir}/conf.d"
    $vhost_dir            = "${httpd_dir}/conf.d"
    $conf_file            = 'httpd.conf'
    $ports_file           = "${conf_dir}/ports.conf"
    $logroot              = '/var/log/httpd'
    $lib_path             = 'modules'
    $mpm_module           = 'prefork'
    $dev_packages         = 'httpd-devel'
    $default_ssl_cert     = '/etc/pki/tls/certs/localhost.crt'
    $default_ssl_key      = '/etc/pki/tls/private/localhost.key'
    $ssl_certs_dir        = $distrelease ? {
      '5'     => '/etc/pki/tls/certs',
      default => '/etc/ssl/certs',
    }
    $passenger_root       = '/usr/share/rubygems/gems/passenger-3.0.17'
    $passenger_ruby       = '/usr/bin/ruby'
    $suphp_addhandler     = 'php5-script'
    $suphp_engine         = 'off'
    $suphp_configpath     = undef
    $mod_packages         = {
      'auth_kerb'  => 'mod_auth_kerb',
      'fcgid'      => 'mod_fcgid',
      'passenger'  => 'mod_passenger',
      'perl'       => 'mod_perl',
      'php5'       => $distrelease ? {
        '5'     => 'php53',
        default => 'php',
      },
      'proxy_html' => 'mod_proxy_html',
      'python'     => 'mod_python',
      'shibboleth' => 'shibboleth',
      'ssl'        => 'mod_ssl',
      'wsgi'       => 'mod_wsgi',
      'dav_svn'    => 'mod_dav_svn',
      'suphp'      => 'mod_suphp',
      'xsendfile'  => 'mod_xsendfile',
    }
    $mod_libs             = {
      'php5' => 'libphp5.so',
    }
    $conf_template        = 'apache/httpd.conf.erb'
    $keepalive            = 'Off'
    $keepalive_timeout    = 15
    # $mime_support_package = '???' # XXX: do we need any package for mime?
    $mime_types_config    = '/etc/mime.types'
  } elsif $::osfamily == 'Debian' {
    $user             = 'www-data'
    $group            = 'www-data'
    $root_group       = 'root'
    $apache_name      = 'apache2'
    $service_name     = 'apache2'
    $httpd_dir        = '/etc/apache2'
    $server_root      = '/etc/apache2'
    $conf_dir         = $httpd_dir
    $confd_dir        = "${httpd_dir}/conf.d"
    $mod_dir          = "${httpd_dir}/mods-available"
    $mod_enable_dir   = "${httpd_dir}/mods-enabled"
    $vhost_dir        = "${httpd_dir}/sites-available"
    $vhost_enable_dir = "${httpd_dir}/sites-enabled"
    $conf_file        = 'apache2.conf'
    $ports_file       = "${conf_dir}/ports.conf"
    $logroot          = '/var/log/apache2'
    $lib_path         = '/usr/lib/apache2/modules'
    $mpm_module       = 'worker'
    $dev_packages     = ['libaprutil1-dev', 'libapr1-dev', 'apache2-prefork-dev']
    $default_ssl_cert = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
    $default_ssl_key  = '/etc/ssl/private/ssl-cert-snakeoil.key'
    $ssl_certs_dir    = '/etc/ssl/certs'
    $passenger_root   = '/usr'
    $passenger_ruby   = '/usr/bin/ruby'
    $suphp_addhandler  = 'x-httpd-php'
    $suphp_engine      = 'off'
    $suphp_configpath  = '/etc/php5/apache2'
    $mod_packages     = {
      'auth_kerb'  => 'libapache2-mod-auth-kerb',
      'fcgid'      => 'libapache2-mod-fcgid',
      'passenger'  => 'libapache2-mod-passenger',
      'perl'       => 'libapache2-mod-perl2',
      'php5'       => 'libapache2-mod-php5',
      'proxy_html' => 'libapache2-mod-proxy-html',
      'python'     => 'libapache2-mod-python',
      'wsgi'       => 'libapache2-mod-wsgi',
      'dav_svn'    => 'libapache2-svn',
      'suphp'      => 'libapache2-mod-suphp',
      'xsendfile'  => 'libapache2-mod-xsendfile',
    }
    $mod_libs         = {
      'php5' => 'libphp5.so',
    }
    $conf_template     = 'apache/httpd.conf.erb'
    $keepalive         = 'Off'
    $keepalive_timeout = 15
    # $mime_support_package = 'mime-support' # XXX: consider uncommenting this
    $mime_types_config = '/etc/mime.types'
  } elsif $::osfamily == 'Archlinux' {
    $user             = 'http'
    $group            = 'http'
    $root_group       = 'root'
    $apache_name      = 'apache'
    $service_name     = 'httpd'
    $httpd_dir        = '/etc/httpd'
    $server_root      = '/etc/httpd'
    $conf_dir         = '/etc/httpd/conf'
    $confd_dir        = '/etc/httpd/conf/extra'
    $mod_dir          = '/etc/httpd/modules'
    $vhost_dir        = '/etc/httpd/conf/extra'
    $conf_file        = 'httpd.conf'
    $ports_file       = '/etc/httpd/ports.conf'
    $logroot          = '/var/log/httpd'
    $lib_path         = '/usr/lib/httpd/modules'
    $mpm_module       = 'worker'
    $dev_packages     = undef
    $default_ssl_cert = '/etc/httpd/conf/server.crt'
    $default_ssl_key  = '/etc/httpd/conf/server.key'
    $ssl_certs_dir    = '/etc/ssl/certs'
    $passenger_root   = '/usr/lib/ruby/gems/2.0.0/gems/passenger-3.0.17'
    $passenger_ruby   = '/usr/bin/ruby'
    $suphp_addhandler  = 'x-httpd-php'
    $suphp_engine      = 'off'
    $suphp_configpath  = '/etc/php'
    $mod_packages     = {
      'auth_kerb'     => 'mod_auth_kerb',
      'fcgid'         => 'mod_fcgid',
      'passenger'     => 'passenger',
      'perl'          => 'mod_perl',
      'php5'          => ['php', 'php-apache',],
      'python'        => 'mod_python',
      'wsgi'          => 'mod_wsgi',
      'xsendfile'     => 'mod_xsendfile',
    }
    $mod_libs         = {
      'php5'          => 'libphp5.so',
    }

    $conf_template     = 'apache/httpd.conf.erb'
    $keepalive         = 'Off'
    $keepalive_timeout = 15
    $mime_types_config = '/etc/httpd/conf/mime.types'
  } elsif $::osfamily == 'FreeBSD' {
    $user             = 'www'
    $group            = 'www'
    $root_group       = 'wheel'
    $apache_name      = 'apache22'
    $service_name     = 'apache22'
    $httpd_dir        = '/usr/local/etc/apache22'
    $server_root      = '/usr/local'
    $conf_dir         = $httpd_dir
    $confd_dir        = "${httpd_dir}/Includes"
    $mod_dir          = "${httpd_dir}/Modules"
    $vhost_dir        = "${httpd_dir}/Vhosts"
    $conf_file        = 'httpd.conf'
    $ports_file       = "${conf_dir}/ports.conf"
    $logroot          = '/var/log/apache22'
    $lib_path         = '/usr/local/libexec/apache22'
    $mpm_module       = 'prefork'
    $dev_packages     = ['www/apache22'] # FIXME: not sure
    $default_ssl_cert = '/usr/local/etc/apache22/server.crt'
    $default_ssl_key  = '/usr/local/etc/apache22/server.key'
    $ssl_certs_dir    = '/usr/local/etc/apache22'
    $passenger_root   = '/usr/local/lib/ruby/gems/1.9/gems/passenger-4.0.10'
    $passenger_ruby   = '/usr/bin/ruby'
    $suphp_addhandler = 'php5-script'
    $suphp_engine     = 'off'
    $suphp_configpath = undef
    $mod_packages     = {
      # NOTE: I list here only modules that are not included in www/apache22
      # NOTE: 'passenger' needs to enable APACHE_SUPPORT in make config
      # NOTE: 'php' needs to enable APACHE option in make config
      # NOTE: 'dav_svn' needs to enable MOD_DAV_SVN make config
      # NOTE: not sure where the shibboleth should come from
      # NOTE: don't know where the shibboleth module should come from
      'auth_kerb'  => 'www/mod_auth_kerb2',
      'fcgid'      => 'www/mod_fcgid',
      'passenger'  => 'www/rubygem-passenger',
      'perl'       => 'www/mod_perl2',
      'php5'       => 'lang/php5',
      'proxy_html' => 'www/mod_proxy_html',
      'python'     => 'www/mod_python3',
      'wsgi'       => 'www/mod_wsgi',
      'dav_svn'    => 'devel/subversion',
      'xsendfile'  => 'www/mod_xsendfile',
    }
    $mod_libs         = {
      'php5' => 'libphp5.so',
    }
    $conf_template        = 'apache/httpd.conf.erb'
    $keepalive            = 'Off'
    $keepalive_timeout    = 15
    $mime_support_package = 'misc/mime-support'
    $mime_types_config    = '/usr/local/etc/mime.types'

  } else {
    fail("Class['apache::params']: Unsupported osfamily: ${::osfamily}")
  }
}
