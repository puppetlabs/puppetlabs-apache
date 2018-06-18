class apache::mod::auth_gssapi {
  include apache
  include apache::mod::authn_core
  apache::mod { 'auth_gssapi': }
}
