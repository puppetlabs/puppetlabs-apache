# @summary
#   Installs `mod_lookup_identity`
# 
# @see https://www.adelton.com/apache/mod_lookup_identity for additional documentation.
#
class apache::mod::lookup_identity {
  include ::apache
  ::apache::mod { 'lookup_identity': }
}
