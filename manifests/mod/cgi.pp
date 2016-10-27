class apache::mod::cgi {
  case $::osfamily {
    'FreeBSD': {}
    'Suse': {}
    default: {
      Class['::apache::mod::prefork'] -> Class['::apache::mod::cgi']
    }
  }

  ::apache::mod { 'cgi': }
}
