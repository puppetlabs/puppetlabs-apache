define apache::balancermember($url, $target) {

  concat::fragment { "BalancerMember ${url}":
    target  => $target,
    content => "  BalancerMember ${url} \n",
  }
}
