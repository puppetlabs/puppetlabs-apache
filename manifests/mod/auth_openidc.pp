# @summary
#   Installs and configures `mod_auth_openidc`.
#
# @param manage_dnf_module Whether to manage the DNF module
# @param dnf_module_ensure The DNF module name to ensure. Only relevant if manage_dnf_module is set to true.
# @param dnf_module_name The DNF module name to manage. Only relevant if manage_dnf_module is set to true.
#
# @see https://github.com/zmartzone/mod_auth_openidc for additional documentation.
# @note Unsupported platforms: OracleLinux: 6; RedHat: 6; Scientific: 6; SLES: all
#
class apache::mod::auth_openidc (
  Boolean $manage_dnf_module = $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '8',
  String[1] $dnf_module_ensure = 'present',
  String[1] $dnf_module_name = 'mod_auth_openidc',
) {
  include apache
  include apache::mod::authn_core
  include apache::mod::authz_user

  apache::mod { 'auth_openidc': }

  if $manage_dnf_module {
    package { 'dnf-module-mod_auth_openidc':
      ensure   => $dnf_module_ensure,
      name     => $dnf_module_name,
      provider => 'dnfmodule',
      before   => Apache::Mod['auth_openidc'],
    }
  }
}
