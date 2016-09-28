class apache::mod::passenger (
  $passenger_conf_file              = $::apache::params::passenger_conf_file,
  $passenger_conf_package_file      = $::apache::params::passenger_conf_package_file,
  $passenger_high_performance       = undef,
  $passenger_pool_idle_time         = undef,
  $passenger_max_request_queue_size = undef,
  $passenger_max_requests           = undef,
  $passenger_spawn_method           = undef,
  $passenger_stat_throttle_rate     = undef,
  $rack_autodetect                  = undef,
  $rails_autodetect                 = undef,
  $passenger_root                   = $::apache::params::passenger_root,
  $passenger_ruby                   = $::apache::params::passenger_ruby,
  $passenger_default_ruby           = $::apache::params::passenger_default_ruby,
  $passenger_max_pool_size          = undef,
  $passenger_min_instances          = undef,
  $passenger_max_instances_per_app  = undef,
  $passenger_use_global_queue       = undef,
  $passenger_app_env                = undef,
  $passenger_log_file               = undef,
  $passenger_log_level              = undef,
  $manage_repo                      = true,
  $mod_package                      = undef,
  $mod_package_ensure               = undef,
  $mod_lib                          = undef,
  $mod_lib_path                     = undef,
  $mod_id                           = undef,
  $mod_path                         = undef,
) inherits ::apache::params {
  include ::apache
  if $passenger_spawn_method {
    validate_re($passenger_spawn_method, '(^smart$|^direct$|^smart-lv2$|^conservative$)', "${passenger_spawn_method} is not permitted for passenger_spawn_method. Allowed values are 'smart', 'direct', 'smart-lv2', or 'conservative'.")
  }
  if $passenger_log_file {
    validate_absolute_path($passenger_log_file)
  }

  # Managed by the package, but declare it to avoid purging
  if $passenger_conf_package_file {
    file { 'passenger_package.conf':
      path => "${::apache::confd_dir}/${passenger_conf_package_file}",
    }
  }

  $_package = $mod_package
  $_package_ensure = $mod_package_ensure
  $_lib = $mod_lib
  if $::osfamily == 'FreeBSD' {
    if $mod_lib_path {
      $_lib_path = $mod_lib_path
    } else {
      $_lib_path = "${passenger_root}/buildout/apache2"
    }
  } else {
    $_lib_path = $mod_lib_path
  }

  if $::osfamily == 'Suse' {
    package {'rack':
      provider => 'gem',
      ensure => "1.6.4",
      before => Exec['passenger']
    }
    package {'rake':
      provider => 'gem',
      ensure => '10.5.0',
      before => Exec['passenger']
    }
    package {'passenger':
      provider => 'gem',
      ensure => 'installed',
      before => Exec['passenger']
    }
    package {'gcc':
      provider => 'zypper',
      before => Package['gcc-c++']
    }
    package {'gcc43-c++':
      provider => 'zypper',
      before => Package['gcc-c++']
    }
    package {'gcc-c++':
      provider => 'rpm',
      source => 'http://download.opensuse.org/repositories/home:/zhy20120210:/SLES-11-SP1-x86-64/SLE_11/x86_64/gcc-c++-4.3-62.8.x86_64.rpm',
      before => Exec['passenger'],
    }
    package {'apache2-devel':
      provider => 'zypper',
      before => Exec['passenger'],
    }
    package {'libcurl-devel':
      provider => 'zypper',
      before => Exec['passenger'],
    }
    exec {'passenger':
      command => '/usr/bin/passenger-install-apache2-module -a',
    }
    file {'/etc/apache2/mods-available/passenger.load':
      ensure => present,
      content => 'LoadModule passenger_module /usr/lib64/apache2/mod_passenger.so'
    }
    file {'/usr/lib64/apache2/mod_passenger.so':
      target => "/usr/lib64/ruby/gems/1.8/gems/passenger-5.0.30/buildout/apache2/mod_passenger.so"

    }

  }

  if $::osfamily == 'RedHat' and $manage_repo {
    yumrepo { 'passenger':
      ensure        => 'present',
      baseurl       => 'https://oss-binaries.phusionpassenger.com/yum/passenger/el/$releasever/$basearch',
      descr         => 'passenger',
      enabled       => '1',
      gpgcheck      => '0',
      gpgkey        => 'https://packagecloud.io/gpg.key',
      repo_gpgcheck => '1',
      sslcacert     => '/etc/pki/tls/certs/ca-bundle.crt',
      sslverify     => '1',
      before        => Apache::Mod['passenger'],
    }
  }

  unless ($::operatingsystem == 'SLES' and $::operatingsystemmajrelease < '12') {
    $_id = $mod_id
    $_path = $mod_path
    ::apache::mod { 'passenger':
      package        => $_package,
      package_ensure => $_package_ensure,
      lib            => $_lib,
      lib_path       => $_lib_path,
      id             => $_id,
      path           => $_path,
      loadfile_name  => 'zpassenger.load',
    }
  }

  # Template uses:
  # - $passenger_root
  # - $passenger_ruby
  # - $passenger_default_ruby
  # - $passenger_max_pool_size
  # - $passenger_min_instances
  # - $passenger_max_instances_per_app
  # - $passenger_high_performance
  # - $passenger_max_requests
  # - $passenger_spawn_method
  # - $passenger_stat_throttle_rate
  # - $passenger_use_global_queue
  # - $passenger_log_file
  # - $passenger_log_level
  # - $passenger_app_env
  # - $rack_autodetect
  # - $rails_autodetect
  file { 'passenger.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/${passenger_conf_file}",
    content => template('apache/mod/passenger.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
