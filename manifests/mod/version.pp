# @summary
#   Installs `mod_version`.
# 
# @param apache_version
#   Used to verify that the Apache version you have requested is compatible with the module.
# 
# @see https://httpd.apache.org/docs/current/mod/mod_version.html for additional documentation.
#
class apache::mod::version(
  $apache_version = $::apache::apache_version
) {

  if ($::osfamily == 'debian' and versioncmp($apache_version, '2.4') >= 0) {
    warning("${module_name}: module version_module is built-in and can't be loaded")
  } else {
    ::apache::mod { 'version': }
  }
}
