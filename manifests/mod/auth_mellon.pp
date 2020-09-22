# @summary
#   Installs and configures `mod_auth_mellon`.
# 
# @param mellon_cache_size
#   Maximum number of sessions which can be active at once.
# 
# @param mellon_lock_file
#   Full path to a file used for synchronizing access to the session data.
# 
# @param mellon_post_directory
#   Full path of a directory where POST requests are saved during authentication.
# 
# @param mellon_cache_entry_size
#   Maximum size for a single session entry in bytes.
# 
# @param mellon_post_ttl
#   Delay in seconds before a saved POST request can be flushed.
# 
# @param mellon_post_size
#   Maximum size for saved POST requests.
# 
# @param mellon_post_count
#   Maximum amount of saved POST requests.
# 
# @see https://github.com/Uninett/mod_auth_mellon for additional documentation.
#
class apache::mod::auth_mellon (
  $mellon_cache_size = $apache::params::mellon_cache_size,
  $mellon_lock_file  = $apache::params::mellon_lock_file,
  $mellon_post_directory = $apache::params::mellon_post_directory,
  $mellon_cache_entry_size = undef,
  $mellon_post_ttl = undef,
  $mellon_post_size = undef,
  $mellon_post_count = undef
) inherits ::apache::params {
  include apache
  ::apache::mod { 'auth_mellon': }

  # Template uses
  # - All variables beginning with mellon_
  file { 'auth_mellon.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/auth_mellon.conf",
    mode    => $apache::file_mode,
    content => template('apache/mod/auth_mellon.conf.erb'),
    require => [Exec["mkdir ${apache::mod_dir}"],],
    before  => File[$apache::mod_dir],
    notify  => Class['Apache::Service'],
  }
}
