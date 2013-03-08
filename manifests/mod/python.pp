class apache::mod::python {
  #include apache
  apache::mod { 'python': }
  include apache::params
  file { "python.conf":
    path => "${apache::params::vdir}/python.conf",
  }
}


