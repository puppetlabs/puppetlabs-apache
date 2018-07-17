# @summary
#   Installs `mod_version`.
# 
# @param apache_version
#   Used to verify that the Apache version you have requested is compatible with the module.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_version.html for additional documentation.
#
class apache::mod::version (
  Optional[String] $apache_version = $apache::apache_version
) {

  if ($::osfamily == 'debian') {
    warning("${module_name}: module version_module is built-in and can't be loaded")
  } else {
    ::apache::mod { 'version': }
  }
}
