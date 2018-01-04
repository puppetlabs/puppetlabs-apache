class apache::vhosts (
  $vhosts = {},
  $vhost_defaults = {},
) {
  include ::apache
  create_resources('apache::vhost', $vhosts, $vhost_defaults)
}
