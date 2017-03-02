class apache::balancers (
  $balancers = {},
  $balancermembers = {},
) {
  include ::apache
  create_resources('apache::balancer', $balancers)
  create_resources('apache::balancermember', $balancermembers)
}
