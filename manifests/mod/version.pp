# @summary
#   Installs `mod_version`.
#
# @see https://httpd.apache.org/docs/current/mod/mod_version.html for additional documentation.
#
class apache::mod::version {
  if $facts['os']['family'] == 'debian' {
    warning("${module_name}: module version_module is built-in and can't be loaded")
  } else {
    ::apache::mod { 'version': }
  }
}
