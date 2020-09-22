# @summary
#   Installs `mod_authnz_pam`.
# 
# @see https://www.adelton.com/apache/mod_authnz_pam for additional documentation.
#
class apache::mod::authnz_pam {
  include apache
  ::apache::mod { 'authnz_pam': }
}
