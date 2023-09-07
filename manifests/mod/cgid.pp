# @summary
#   Installs `mod_cgid`.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_cgid.html
#
class apache::mod::cgid {
  include apache
  case $facts['os']['family'] {
    'FreeBSD': {}
    default: {
      if defined(Class['apache::mod::event']) {
        Class['apache::mod::event'] -> Class['apache::mod::cgid']
      } else {
        Class['apache::mod::worker'] -> Class['apache::mod::cgid']
      }
    }
  }

  # Debian specifies it's cgid sock path, but RedHat uses the default value
  # with no config file
  $cgisock_path = $facts['os']['family'] ? {
    'Debian'  => "\${APACHE_RUN_DIR}/cgisock",
    'FreeBSD' => 'cgisock',
    default   => undef,
  }

  if $facts['os']['family'] == 'Suse' {
    ::apache::mod { 'cgid':
      lib_path => '/usr/lib64/apache2-worker',
    }
  } else {
    ::apache::mod { 'cgid': }
  }

  if $cgisock_path {
    # Template uses $cgisock_path
    file { 'cgid.conf':
      ensure  => file,
      path    => "${apache::mod_dir}/cgid.conf",
      mode    => $apache::file_mode,
      content => epp('apache/mod/cgid.conf.epp', { 'cgisock_path' => $cgisock_path }),
      require => Exec["mkdir ${apache::mod_dir}"],
      before  => File[$apache::mod_dir],
      notify  => Class['apache::service'],
    }
  }
}
