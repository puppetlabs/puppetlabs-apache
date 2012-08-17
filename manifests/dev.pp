# Class: apache::dev
#
# This class installs Apache development libraries
#
# Parameters:
#
# Actions:
#   - Install Apache development libraries
#
# Requires:
#
# Sample Usage:
#
class apache::dev {
  warning('apache::dev is deprecated; please use apache::mod::dev')
  include apache::mod::dev
}
