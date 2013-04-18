class apache::mod::cgi {
  if ($apache::params::mpm == 'prefork') {
    apache::mod { 'cgi': }
  } else {
    apache::mod { 'cgid': }
  }
}
