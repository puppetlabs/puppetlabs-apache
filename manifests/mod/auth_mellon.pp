# @summary
#   This class enables and configures Apache mod_auth_mellon
# 
# @param mellon_cache_size
#   The maximum number of sessions which can be active at once.
# 
# @param mellon_lock_file
#   The full path to a file used for synchronizing access to the session data.
# 
# @param mellon_post_directory
#   The full path of a directory where POST requests are saved during authentication.
# 
# @param mellon_cache_entry_size
#   The maximum size for a single session entry in bytes.
# 
# @param mellon_post_ttl
#   The delay in seconds before a saved POST request can be flushed.
# 
# @param mellon_post_size
#   The maximum size for saved POST requests.
# 
# @param mellon_post_count
#   The maximum amount of saved POST requests.
# 
# See [`Apache mod_auth_mellon`](https://github.com/Uninett/mod_auth_mellon) 
# for more information.
class apache::mod::auth_mellon (
  $mellon_cache_size = $::apache::params::mellon_cache_size,
  $mellon_lock_file  = $::apache::params::mellon_lock_file,
  $mellon_post_directory = $::apache::params::mellon_post_directory,
  $mellon_cache_entry_size = undef,
  $mellon_post_ttl = undef,
  $mellon_post_size = undef,
  $mellon_post_count = undef
) inherits ::apache::params {

  include ::apache
  ::apache::mod { 'auth_mellon': }

  # Template uses
  # - All variables beginning with mellon_
  file { 'auth_mellon.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/auth_mellon.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/auth_mellon.conf.erb'),
    require => [ Exec["mkdir ${::apache::mod_dir}"], ],
    before  => File[$::apache::mod_dir],
    notify  => Class['Apache::Service'],
  }

}
