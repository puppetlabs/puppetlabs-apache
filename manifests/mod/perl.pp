# @api private
class apache::mod::perl {
  include ::apache
  ::apache::mod { 'perl': }
}
