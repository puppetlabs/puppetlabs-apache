class apache::balancers (
  $balancers = {},
) {
  include ::apache

  $_balancers = keys($balancers)
  apache::balancer { $_balancers: }
  $_balancers.each |$balancer| {
    $_balancermembers = $balancers[$balancer]
    create_resources( apache::balancermember, $_balancermembers )
  }
}
