# @summary
#   Installs `mod_apreq2`.
#
# @see http://httpd.apache.org/apreq/docs/libapreq2/group__mod__apreq2.html for additional documentation.
#

class apache::mod::apreq2 {
  ::apache::mod { 'apreq2':
    id => 'apreq_module',
  }
}
