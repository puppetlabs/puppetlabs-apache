class apache::mod::authn_core(
  $apache_version = $::apache::apache_version
) {
  ::apache::mod { 'authn_core': }
}
