# @summary
#   Installs `mod_dev`.
#
# @note
#   This module is deprecated. Please use `apache::dev`.
#
class apache::mod::dev {
  # Development packages are not apache modules
  warning('apache::mod::dev is deprecated; please use apache::dev')
  include ::apache::dev
}
