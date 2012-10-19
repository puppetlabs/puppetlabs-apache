class apache::mod::ssl {
  apache::mod { 'ssl': }
  # keep mod_ssl rpm's defaults for redhat systems
  if $::osfamily == 'redhat' {
    file { "${apache::params::vdir}/ssl.conf":
      ensure  => present,
      content => template('apache/mod/ssl.conf.erb'),
    }
  }
}
