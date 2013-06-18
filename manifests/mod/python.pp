class apache::mod::python {
  apache::mod { 'python': }
  include apache::params
  file { "python.conf":
    path => "${apache::params::vdir}/python.conf",
  }
}


