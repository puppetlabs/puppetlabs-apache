# @summary
#   This class enabled the proxy module for Apache.
#
# @note
#   This class is deprecated.
#
# @api private
class apache::proxy {
  warning('apache::proxy is deprecated; please use apache::mod::proxy')
  include apache::mod::proxy
}
