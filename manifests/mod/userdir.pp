# @summary
#   Installs and configures `mod_userdir`.
# 
# @param home
#   *Deprecated* Path to system home directory.
#   
# @param dir
#   *Deprecated* Path from user's home directory to public directory.
# 
# @param disable_root
#   Toggles whether to allow use of root directory.
# 
# @param apache_version
#   Used to verify that the Apache version you have requested is compatible with the module.
# 
# @param path
#   Path to directory or pattern from which to find user-specific directories.
# 
# @param overrides
#   Array of directives that are allowed in .htaccess files.
# 
# @param options
#   Configures what features are available in a particular directory.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_userdir.html for additional documentation.
#
class apache::mod::userdir (
  $home = undef,
  $dir = undef,
  $disable_root = true,
  $apache_version = undef,
  $path = '/home/*/public_html',
  $overrides = [ 'FileInfo', 'AuthConfig', 'Limit', 'Indexes' ],
  $options = [ 'MultiViews', 'Indexes', 'SymLinksIfOwnerMatch', 'IncludesNoExec' ],
) {
  include ::apache
  $_apache_version = pick($apache_version, $apache::apache_version)

  if $home or $dir {
    $_home = $home ? {
      undef   => '/home',
      default =>  $home,
    }
    $_dir = $dir ? {
      undef   => 'public_html',
      default =>  $dir,
    }
    warning('home and dir are deprecated; use path instead')
    $_path = "${_home}/*/${_dir}"
  } else {
    $_path = $path
  }

  ::apache::mod { 'userdir': }

  # Template uses $home, $dir, $disable_root, $_apache_version
  file { 'userdir.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/userdir.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/userdir.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
