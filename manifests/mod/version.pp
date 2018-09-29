class apache::mod::version(
  $apache_version = $::apache::apache_version
) {

  if ($::osfamily == 'debian') {
    warning("${module_name}: module version_module is built-in and can't be loaded")
  } else {
    ::apache::mod { 'version': }
  }
}
