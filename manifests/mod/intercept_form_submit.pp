# @summary
#   Installs `mod_intercept_form_submit`.
# 
# @see https://www.adelton.com/apache/mod_intercept_form_submit for additional documentation.
#
class apache::mod::intercept_form_submit {
  include apache
  ::apache::mod { 'intercept_form_submit': }
}
