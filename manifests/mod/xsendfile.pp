# @summary
#   Installs `mod_xsendfile`.
# 
# @see https://tn123.org/mod_xsendfile/ for additional documentation.
#
class apache::mod::xsendfile {
  include ::apache::params
  ::apache::mod { 'xsendfile': }
}
