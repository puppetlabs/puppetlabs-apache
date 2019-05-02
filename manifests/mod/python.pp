# @summary
#   Installs and configures `mod_python`.
# 
# @param loadfile_name
#   Sets the name of the configuration file that is used to load the python module.
# 
# @see https://github.com/grisha/mod_python for additional documentation.
#
class apache::mod::python (
  Optional[String] $loadfile_name = undef,
) {
  include ::apache
  ::apache::mod { 'python':
    loadfile_name => $loadfile_name,
  }
}


