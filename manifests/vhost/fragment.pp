# @summary Define a fragment within a vhost
#
# @param vhost
#   The title of the vhost resource to append to
#
# @param priority
#   Set the priority to match the one `apache::vhost` sets. This must match the
#   one `apache::vhost` sets or else the concat fragment won't be found.
#
# @param content
#   The content to put in the fragment. Only when it's non-empty the actual
#   fragment will be created.
#
# @param order
#   The order to insert the fragment at
#
# @example With a vhost without priority
#   include apache
#   apache::vhost { 'myvhost':
#   }
#   apache::vhost::fragment { 'myfragment':
#     vhost   => 'myvhost',
#     content => '# Foo',
#   }
#
# @example With a vhost with priority
#   include apache
#   apache::vhost { 'myvhost':
#     priority => '42',
#   }
#   apache::vhost::fragment { 'myfragment':
#     vhost    => 'myvhost',
#     priority => '42',
#     content  => '# Foo',
#   }
#
# @example With a vhost with default vhost
#   include apache
#   apache::vhost { 'myvhost':
#     default_vhost => true,
#   }
#   apache::vhost::fragment { 'myfragment':
#     vhost    => 'myvhost',
#     priority => '10', # default_vhost implies priority 10
#     content  => '# Foo',
#   }
#
# @example Adding a fragment to the built in default vhost
#   include apache
#   apache::vhost::fragment { 'myfragment':
#     vhost    => 'default',
#     priority => '15',
#     content  => '# Foo',
#   }
#
define apache::vhost::fragment(
  String[1] $vhost,
  $priority = undef,
  Optional[String] $content = undef,
  Integer[0] $order = 900,
) {
  # This copies the logic from apache::vhost
  if $priority {
    $priority_real = "${priority}-"
  } elsif $priority == false {
    $priority_real = ''
  } else {
    $priority_real = '25-'
  }

  $filename = regsubst($vhost, ' ', '_', 'G')

  if $content =~ String[1] {
    concat::fragment { "${vhost}-${title}":
      target  => "${priority_real}${filename}.conf",
      order   => $order,
      content => $content,
    }
  }
}
