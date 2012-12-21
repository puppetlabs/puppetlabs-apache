class apache::mod::mime_magic {
  apache::mod { 'mime_magic': }
  # Template uses no variables
  file { "${apache::params::mod_dir}/mime_magic.conf":
    ensure  => present,
    content => template('apache/mod/mime_magic.conf.erb'),
  }
}
