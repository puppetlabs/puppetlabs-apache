# @summary
#   Installs and configures `mod_userdir`.
# 
# @param home
#   *Deprecated* Path to system home directory.
#   
# @param dir
#   *Deprecated* Path from user's home directory to public directory.
#
# @param userdir
#   Path or directory name to be used as the UserDir.
#
# @param disable_root
#   Toggles whether to allow use of root directory.
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
# @param unmanaged_path
#   Toggles whether to manage path in userdir.conf
#
# @param custom_fragment
#   Custom configuration to be added to userdir.conf
# 
# @see https://httpd.apache.org/docs/current/mod/mod_userdir.html for additional documentation.
#
class apache::mod::userdir (
  Optional[String] $home            = undef,
  Optional[String] $dir             = undef,
  Optional[String[1]] $userdir      = undef,
  Boolean $disable_root             = true,
  String $path                      = '/home/*/public_html',
  Array[String] $overrides          = ['FileInfo', 'AuthConfig', 'Limit', 'Indexes'],
  Array[String] $options            = ['MultiViews', 'Indexes', 'SymLinksIfOwnerMatch', 'IncludesNoExec'],
  Boolean $unmanaged_path           = false,
  Optional[String] $custom_fragment = undef,
) {
  include apache

  if $home or $dir {
    $_home = $home ? {
      undef   => '/home',
      default => $home,
    }
    $_dir = $dir ? {
      undef   => 'public_html',
      default => $dir,
    }
    warning('home and dir are deprecated; use path instead')
    $_path = "${_home}/*/${_dir}"
  } else {
    $_path = $path
  }

  $_userdir = pick($userdir, $_path)

  ::apache::mod { 'userdir': }

  # Template uses $home, $dir, $disable_root
  file { 'userdir.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/userdir.conf",
    mode    => $apache::file_mode,
    content => template('apache/mod/userdir.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
