# @summary
#   This class enables Apache mod_auth_kerb
class apache::mod::auth_kerb {
  include ::apache
  include ::apache::mod::authn_core
  ::apache::mod { 'auth_kerb': }
}


