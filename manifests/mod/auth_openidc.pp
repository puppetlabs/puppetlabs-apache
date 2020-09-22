# @summary
#   Installs and configures `mod_auth_openidc`.
# 
# @see https://github.com/zmartzone/mod_auth_openidc for additional documentation.
#
class apache::mod::auth_openidc (
) inherits ::apache::params {
  include apache
  include apache::mod::authz_user
  apache::mod { 'auth_openidc': }
}
