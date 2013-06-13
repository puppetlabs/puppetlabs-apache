class apache::mod::python {
  apache::mod { 'python': }
  if $::osfamily == 'RedHat' {
    # Template uses no variables
    file { 'python.conf':
      ensure  => file,
      path    => "${apache::mod_dir}/python.conf",
      content => template('apache/mod/python.conf.erb'),
    }
  }
}
