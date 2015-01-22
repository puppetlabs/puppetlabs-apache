class apache::mod::security (
  $crs_package     = $::apache::params::modsec_crs_package,
  $activated_rules = $::apache::params::modsec_default_rules,
  $modsec_dir      = $::apache::params::modsec_dir,
){

  if $::osfamily == 'FreeBSD' {
    fail('FreeBSD is not currently supported')
  }

  ::apache::mod { 'security':
    id  => 'security2_module',
    lib => 'mod_security2.so',
  }

  ::apache::mod { 'unique_id_module':
    id  => 'unique_id_module',
    lib => 'mod_unique_id.so',
  }

  if $crs_package  {
    package { $crs_package:
      ensure => 'latest',
      before => File['security.conf'],
    }
  }

  # Template uses:
  # - $modsec_dir
  file { 'security.conf':
    ensure  => file,
    content => template('apache/mod/security.conf.erb'),
    path    => "${::apache::mod_dir}/security.conf",
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }

  file { $modsec_dir:
    ensure  => directory,
    owner   => $::apache::params::user,
    group   => $::apache::params::group,
    mode    => '0555',
    purge   => true,
    recurse => true,
  }

  file { "${modsec_dir}/activated_rules":
    ensure => directory,
    owner  => $::apache::params::user,
    group  => $::apache::params::group,
    mode   => '0555',
  }

  file { "${modsec_dir}/security_crs.conf":
    ensure  => file,
    content => template('apache/mod/security_crs.conf.erb'),
    require => File[$modsec_dir],
    notify  => Class['apache::service'],
  }

  apache::security::rule_link { $activated_rules: }

}
