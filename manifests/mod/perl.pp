# @summary
#   Installs `mod_perl`.
# 
# @see https://perl.apache.org for additional documentation.
#
class apache::mod::perl {
  include ::apache
  ::apache::mod { 'perl': }
}
