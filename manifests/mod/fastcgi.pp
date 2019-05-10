# @summary
#   Installs `mod_fastcgi`.
# 
# @see https://github.com/FastCGI-Archives/mod_fastcgi for additional documentation.
#
class apache::mod::fastcgi {
  include ::apache
  if ($::osfamily == 'Redhat' and versioncmp($::operatingsystemrelease, '7.0') >= 0) {
    fail('mod_fastcgi is no longer supported on el7 and above.')
  }
  if ($facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['major'], '18.04') >= 0) {
    fail('mod_fastcgi is no longer supported on Ubuntu 18.04 and above. Please use mod_proxy_fcgi')
  }
  # Debian specifies it's fastcgi lib path, but RedHat uses the default value
  # with no config file
  $fastcgi_lib_path = $::apache::params::fastcgi_lib_path

  ::apache::mod { 'fastcgi': }

  if $fastcgi_lib_path {
    # Template uses:
    # - $fastcgi_server
    # - $fastcgi_socket
    # - $fastcgi_dir
    file { 'fastcgi.conf':
      ensure  => file,
      path    => "${::apache::mod_dir}/fastcgi.conf",
      mode    => $::apache::file_mode,
      content => template('apache/mod/fastcgi.conf.erb'),
      require => Exec["mkdir ${::apache::mod_dir}"],
      before  => File[$::apache::mod_dir],
      notify  => Class['apache::service'],
    }
  }

}
