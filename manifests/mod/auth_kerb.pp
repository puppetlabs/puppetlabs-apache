class apache::mod::auth_kerb {
  include ::apache
  ::apache::mod { 'auth_kerb': }
}


