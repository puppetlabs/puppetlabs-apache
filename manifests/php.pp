# @summary
#   This class installs PHP for Apache.
#
# @note 
#    This class is deprecated.
#
# @api private
class apache::php {
  warning('apache::php is deprecated; please use apache::mod::php')
  include ::apache::mod::php
}
