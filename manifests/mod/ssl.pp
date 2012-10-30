class apache::mod::ssl {
  include apache::params

  apache::mod { 'ssl': }
  # keep mod_ssl rpm's defaults for redhat systems
  if $::osfamily == 'redhat' {
    file { "${apache::params::vdir}/ssl.conf":
      ensure  => present,
      content => template('apache/mod/ssl.conf.erb'),
    }
  }
}
