# @summary
#   This class installs Apache SSL capabilities
#
# @note
#   This class is deprecated.
#
# @api private
class apache::ssl {
  warning('apache::ssl is deprecated; please use apache::mod::ssl')
  include ::apache::mod::ssl
}
