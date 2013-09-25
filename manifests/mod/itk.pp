class apache::mod::itk (
  $startservers        = '8',
  $minspareservers     = '5',
  $maxspareservers     = '20',
  $serverlimit         = '256',
  $maxclients          = '256',
  $maxrequestsperchild = '4000',
) {
  if defined(Class['apache::mod::prefork']) {
    fail('May not include both apache::mod::itk and apache::mod::prefork on the same node')
  }
  if defined(Class['apache::mod::worker']) {
    fail('May not include both apache::mod::itk and apache::mod::worker on the same node')
  }
  File {
    owner => 'root',
    group => $apache::params::root_group,
    mode  => '0644',
  }

  # Template uses:
  # - $startservers
  # - $minspareservers
  # - $maxspareservers
  # - $serverlimit
  # - $maxclients
  # - $maxrequestsperchild
  file { "${apache::mod_dir}/itk.conf":
    ensure  => file,
    content => template('apache/mod/itk.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }

  case $::osfamily {
    'debian' : {
      file { "${apache::mod_enable_dir}/itk.conf":
        ensure  => link,
        target  => "${apache::mod_dir}/itk.conf",
        require => Exec["mkdir ${apache::mod_enable_dir}"],
        before  => File[$apache::mod_enable_dir],
        notify  => Service['httpd'],
      }
      package { 'apache2-mpm-itk':
        ensure => present,
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
