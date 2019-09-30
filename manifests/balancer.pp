# @summary
#   This type will create an apache balancer cluster file inside the conf.d
#   directory. 
#
# Each balancer cluster needs one or more balancer members (that can
# be declared with the apache::balancermember defined resource type). Using
# storeconfigs, you can export the apache::balancermember resources on all
# balancer members, and then collect them on a single apache load balancer
# server.
#
# @note 
#   Currently requires the puppetlabs/concat module on the Puppet Forge and uses
#   storeconfigs on the Puppet Master to export/collect resources from all
#   balancer members.
#
# @param name
#   The namevar of the defined resource type is the balancer clusters name.<br />
#   This name is also used in the name of the conf.d file
#
# @param proxy_set
#   Configures key-value pairs to be used as a ProxySet lines in the configuration.
#
# @param target
#   The path to the file the balancer definition will be written in.
#
# @param collect_exported
#   Determines whether to use exported resources.<br />
#   If you statically declare all of your backend servers, set this parameter to false to rely 
#   on existing, declared balancer member resources. Also, use apache::balancermember with array 
#   arguments.<br />
#   To dynamically declare backend servers via exported resources collected on a central node, 
#   set this parameter to true to collect the balancer member resources exported by the balancer 
#   member nodes.<br />
#   If you don't use exported resources, a single Puppet run configures all balancer members. If 
#   you use exported resources, Puppet has to run on the balanced nodes first, then run on the 
#   balancer.
#
# @param options
#   Specifies an array of [options](https://httpd.apache.org/docs/current/mod/mod_proxy.html#balancermember) 
#   after the balancer URL, and accepts any key-value pairs available to `ProxyPass`.
#
# @example
#   apache::balancer { 'puppet00': }
#
define apache::balancer (
  $proxy_set = {},
  $collect_exported = true,
  $target = undef,
  $options = [],
) {
  include ::apache::mod::proxy_balancer

  if versioncmp($apache::mod::proxy_balancer::apache_version, '2.4') >= 0 {
    $lbmethod = $proxy_set['lbmethod'] ? {
      undef   => 'byrequests',
      default => $proxy_set['lbmethod'],
    }
    ensure_resource('apache::mod', "lbmethod_${lbmethod}", {
      'loadfile_name' => "proxy_balancer_lbmethod_${lbmethod}.load"
    })
  }

  if $target {
    $_target = $target
  } else {
    $_target = "${::apache::confd_dir}/balancer_${name}.conf"
  }

  if !empty($options) {
    $_options = " ${join($options, ' ')}"
  } else {
    $_options = ''
  }

  concat { "apache_balancer_${name}":
    owner  => '0',
    group  => '0',
    path   => $_target,
    mode   => $::apache::file_mode,
    notify => Class['Apache::Service'],
  }

  concat::fragment { "00-${name}-header":
    target  => "apache_balancer_${name}",
    order   => '01',
    content => "<Proxy balancer://${name}${_options}>\n",
  }

  if $collect_exported {
    Apache::Balancermember <<| balancer_cluster == $name |>>
  }
  # else: the resources have been created and they introduced their
  # concat fragments. We don't have to do anything about them.

  concat::fragment { "01-${name}-proxyset":
    target  => "apache_balancer_${name}",
    order   => '19',
    content => inline_template("<% @proxy_set.keys.sort.each do |key| %> Proxyset <%= key %>=<%= @proxy_set[key] %>\n<% end %>"),
  }

  concat::fragment { "01-${name}-footer":
    target  => "apache_balancer_${name}",
    order   => '20',
    content => "</Proxy>\n",
  }
}
