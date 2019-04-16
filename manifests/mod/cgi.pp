class apache::mod::cgi {
  include ::apache
  case $::osfamily {
    'FreeBSD': {}
    default: {
      if defined(Class['::apache::mod::itk']) {
        Class['::apache::mod::itk'] -> Class['::apache::mod::cgi']
      } elsif defined(Class['::apache::mod::peruser']) {
        Class['::apache::mod::peruser'] -> Class['::apache::mod::cgi']
      } else {
        Class['::apache::mod::prefork'] -> Class['::apache::mod::cgi']
      }
    }
  }

  if $::osfamily == 'Suse' {
    ::apache::mod { 'cgi':
      lib_path => '/usr/lib64/apache2-prefork',
    }
  } else {
    ::apache::mod { 'cgi': }
  }

}
