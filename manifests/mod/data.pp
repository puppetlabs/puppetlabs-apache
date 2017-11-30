class apache::mod::data {
  $_apache_version = pick($apache_version, $apache::apache_version)
  if versioncmp($_apache_version, '2.3') < 0 {
    fail('mod_data is only available in Apache 2.3 and later')
  }
  ::apache::mod { 'data': }
}
