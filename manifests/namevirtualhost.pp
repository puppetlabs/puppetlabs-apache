# @summary
#   Enables name-based virtual hosts 
#
# Adds all related directives to the `ports.conf` file in the Apache HTTPD configuration 
# directory. Titles can take the forms `\*`, `\*:\<PORT\>`, `\_default\_:\<PORT\>`, 
# `\<IP\>`, or `\<IP\>:\<PORT\>`.
define apache::namevirtualhost {
  $addr_port = $name

  # Template uses: $addr_port
  concat::fragment { "NameVirtualHost ${addr_port}":
    target  => $apache::ports_file,
    content => template('apache/namevirtualhost.erb'),
  }
}
