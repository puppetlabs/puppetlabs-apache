class apache::mod::python (
  Optional[String] $loadfile_name = undef,
) {
  include ::apache
  ::apache::mod { 'python':
    loadfile_name => $loadfile_name,
  }
}


