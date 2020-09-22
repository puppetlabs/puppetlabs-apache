# @summary
#   Defines one or more external FastCGI servers to handle specific file types. Use this 
#   defined type with `mod_fastcgi`.
#
# @param host
#   Determines the FastCGI's hostname or IP address and TCP port number (1-65535).
#
# @param timeout
#   Sets the number of seconds a [FastCGI](http://www.fastcgi.com/) application can be inactive before aborting the 
#   request and logging the event at the error LogLevel. The inactivity timer applies only as 
#   long as a connection is pending with the FastCGI application. If a request is queued to an 
#   application, but the application doesn't respond by writing and flushing within this period, 
#   the request is aborted. If communication is complete with the application but incomplete with 
#   the client (the response is buffered), the timeout does not apply.
#
# @param flush
#   Forces `mod_fastcgi` to write to the client as data is received from the 
#   application. By default, `mod_fastcgi` buffers data in order to free the application 
#   as quickly as possible.
#
# @param faux_path
#   Apache has FastCGI handle URIs that resolve to this filename. The path set in this 
#   parameter does not have to exist in the local filesystem.
#
# @param fcgi_alias
#   Internally links actions with the FastCGI server. This alias must be unique.
#
# @param file_type
#   Sets the MIME `content-type` of the file to be processed by the FastCGI server.
#
define apache::fastcgi::server (
  $host          = '127.0.0.1:9000',
  $timeout       = 15,
  $flush         = false,
  $faux_path     = "/var/www/${name}.fcgi",
  $fcgi_alias    = "/${name}.fcgi",
  $file_type     = 'application/x-httpd-php',
  $pass_header   = undef,
) {
  include apache::mod::fastcgi

  Apache::Mod['fastcgi'] -> Apache::Fastcgi::Server[$title]

  if $host =~ Stdlib::Absolutepath {
    $socket = $host
  }

  file { "fastcgi-pool-${name}.conf":
    ensure  => file,
    path    => "${apache::confd_dir}/fastcgi-pool-${name}.conf",
    owner   => 'root',
    group   => $apache::params::root_group,
    mode    => $apache::file_mode,
    content => template('apache/fastcgi/server.erb'),
    require => Exec["mkdir ${apache::confd_dir}"],
    before  => File[$apache::confd_dir],
    notify  => Class['apache::service'],
  }
}
