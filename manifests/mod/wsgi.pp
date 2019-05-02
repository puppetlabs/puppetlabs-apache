# @summary
#   Installs and configures `mod_wsgi`.
# 
# @param wsgi_restrict_embedded
#   Enable restrictions on use of embedded mode.
# 
# @param wsgi_socket_prefix
#   Configure directory to use for daemon sockets.
# 
# @param wsgi_python_path
#   Additional directories to search for Python modules.
# 
# @param wsgi_python_home
#   Absolute path to Python prefix/exec_prefix directories.
# 
# @param wsgi_python_optimize
#   Enables basic Python optimisation features.
# 
# @param wsgi_application_group
#   Sets which application group WSGI application belongs to.
# 
# @param package_name
#   Names of package that installs mod_wsgi.
# 
# @param mod_path
#   Defines the path to the mod_wsgi shared object (.so) file.
# 
# @see https://github.com/GrahamDumpleton/mod_wsgi for additional documentation.
#
class apache::mod::wsgi (
  $wsgi_restrict_embedded = undef,
  $wsgi_socket_prefix     = $::apache::params::wsgi_socket_prefix,
  $wsgi_python_path       = undef,
  $wsgi_python_home       = undef,
  $wsgi_python_optimize   = undef,
  $wsgi_application_group = undef,
  $package_name           = undef,
  $mod_path               = undef,
) inherits ::apache::params {
  include ::apache
  if ($package_name != undef and $mod_path == undef) or ($package_name == undef and $mod_path != undef) {
    fail('apache::mod::wsgi - both package_name and mod_path must be specified!')
  }

  if $package_name != undef {
    if $mod_path =~ /\// {
      $_mod_path = $mod_path
    } else {
      $_mod_path = "${::apache::lib_path}/${mod_path}"
    }
    ::apache::mod { 'wsgi':
      package => $package_name,
      path    => $_mod_path,
    }
  }
  else {
    ::apache::mod { 'wsgi': }
  }

  # Template uses:
  # - $wsgi_restrict_embedded
  # - $wsgi_socket_prefix
  # - $wsgi_python_path
  # - $wsgi_python_home
  file {'wsgi.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/wsgi.conf",
    mode    => $::apache::file_mode,
    content => template('apache/mod/wsgi.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}

