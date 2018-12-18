class apache::mod::http2 (
  Optional[Boolean] $h2_copy_files              = undef,
  Optional[Boolean] $h2_direct                  = undef,
  Optional[Boolean] $h2_early_hints             = undef,
  Optional[Integer] $h2_max_session_streams     = undef,
  Optional[Integer] $h2_max_worker_idle_seconds = undef,
  Optional[Integer] $h2_max_workers             = undef,
  Optional[Integer] $h2_min_workers             = undef,
  Optional[Boolean] $h2_modern_tls_only         = undef,
  Optional[Boolean] $h2_push                    = undef,
  Optional[Integer] $h2_push_diary_size         = undef,
  Array[String]     $h2_push_priority           = [],
  Array[String]     $h2_push_resource           = [],
  Optional[Boolean] $h2_serialize_headers       = undef,
  Optional[Integer] $h2_stream_max_mem_size     = undef,
  Optional[Integer] $h2_tls_cool_down_secs      = undef,
  Optional[Integer] $h2_tls_warm_up_size        = undef,
  Optional[Boolean] $h2_upgrade                 = undef,
  Optional[Integer] $h2_window_size             = undef,
  Optional[String]  $apache_version             = undef,
) {
  include ::apache
  apache::mod { 'http2': }

  $_apache_version = pick($apache_version, $apache::apache_version)

  file { 'http2.conf':
    ensure  => file,
    content => template('apache/mod/http2.conf.erb'),
    mode    => $::apache::file_mode,
    path    => "${::apache::mod_dir}/http2.conf",
    owner   => $::apache::params::user,
    group   => $::apache::params::group,
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
