# @summary
#   Installs `mod_auth_kerb`
#
# @see http://modauthkerb.sourceforge.net for additional documentation.
class apache::mod::auth_kerb {
  include ::apache
  include ::apache::mod::authn_core
  ::apache::mod { 'auth_kerb': }
}


