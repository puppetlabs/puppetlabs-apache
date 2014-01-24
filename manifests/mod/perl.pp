class apache::mod::perl (
  $perl_load_module = undef,
  $perl_set_var     = undef,
  $perl_switches    = undef,
) {

  apache::mod { 'perl': }

  # Template uses:
  # - $perl_load_module
  # - $perl_set_var
  # - $perl_switches
  file { 'perl.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/perl.conf",
    content => template('apache/mod/perl.conf.erb'),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Service['httpd'],
  }
}
