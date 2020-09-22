# @summary
#   Installs and configures `mod_http2`.
# 
# @param h2_copy_files
#   Determine file handling in responses.
#
# @param h2_direct
#   H2 Direct Protocol Switch.
# 
# @param h2_early_hints
#   Determine sending of 103 status codes.
# 
# @param h2_max_session_streams
#   Sets maximum number of active streams per HTTP/2 session.
# 
# @param h2_max_worker_idle_seconds
#   Sets maximum number of seconds h2 workers remain idle until shut down.
# 
# @param h2_max_workers
#   Sets maximum number of worker threads to use per child process.
# 
# @param h2_min_workers
#   Sets minimal number of worker threads to use per child process.
# 
# @param h2_modern_tls_only
#   Toggles the security checks on HTTP/2 connections in TLS mode
#
# @param h2_push
#   Toggles the usage of the HTTP/2 server push protocol feature.
# 
# @param h2_push_diary_size
#   Sets maximum number of HTTP/2 server pushes that are remembered per HTTP/2 connection.
# 
# @param h2_priority
#   Require HTTP/2 connections to be "modern TLS" only
# 
# @param h2_push_resource
#   When added to a directory/location, HTTP/2 PUSHes will be attempted for all paths added 
#   via this directive
# 
# @param h2_serialize_headers
#   Toggles if HTTP/2 requests shall be serialized in HTTP/1.1 format for processing by httpd 
#   core or if received binary data shall be passed into the request_recs directly.
# 
# @param h2_stream_max_mem_size
#   Sets the maximum number of outgoing data bytes buffered in memory for an active streams.
# 
# @param h2_tls_cool_down_secs
#   Sets the number of seconds of idle time on a TLS connection before the TLS write size falls 
#   back to small (~1300 bytes) length. 
# 
# @param h2_tls_warm_up_size
#   Sets the number of bytes to be sent in small TLS records (~1300 bytes) until doing maximum 
#   sized writes (16k) on https: HTTP/2 connections. 
# 
# @param h2_upgrade
#   Toggles the usage of the HTTP/1.1 Upgrade method for switching to HTTP/2. 
# 
# @param h2_window_size
#   Sets the size of the window that is used for flow control from client to server and limits 
#   the amount of data the server has to buffer. 
# 
# @param apache_version
#   Version of Apache to install module on.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_http2.html for additional documentation.
#
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
  include apache
  apache::mod { 'http2': }

  $_apache_version = pick($apache_version, $apache::apache_version)

  file { 'http2.conf':
    ensure  => file,
    content => template('apache/mod/http2.conf.erb'),
    mode    => $apache::file_mode,
    path    => "${apache::mod_dir}/http2.conf",
    owner   => $apache::params::user,
    group   => $apache::params::group,
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
