class apache::mod::data (
  $apache_version = undef,
) {
  include ::apache
  $_apache_version = pick($apache_version, $apache::apache_version)
  ::apache::mod { 'data': }
}
