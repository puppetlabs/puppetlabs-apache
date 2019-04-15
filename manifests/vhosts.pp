# @summary
#   Creates `apache::vhost` defined types.
#
# Creates `apache::vhost` defined types.
# 
# > **Note**: See the `apache::vhost` defined type's reference for a list of all virtual 
# host parameters or Configuring virtual hosts in the README section.
#
# For example, to create a [name-based virtual host](https://httpd.apache.org/docs/current/vhosts/name-based.html) 
# `custom_vhost_1`, declare the following manifest:
#
# ``` puppet
# class { 'apache::vhosts':
#   vhosts => {
#     'custom_vhost_1' => {
#       'docroot' => '/var/www/custom_vhost_1',
#       'port'    => '81',
#     },
#   },
# }
# ```
#
# @param vhosts
#   A hash, where the key represents the name and the value represents a hash of 
#   `apache::vhost` defined type's parameters.
class apache::vhosts (
  $vhosts = {},
) {
  include ::apache
  create_resources('apache::vhost', $vhosts)
}
