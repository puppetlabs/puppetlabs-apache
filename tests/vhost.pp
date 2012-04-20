include apache

apache::vhost { 'test.vhost':
  port     => 80,
  docroot  => '/tmp/testvhost',
  template => 'apache/test.vhost.erb'
}

# Example smoke test of multiple vhosts
# and multiple listening ports
apache::vhost { 'port.80':
  priority => '20',
  port => '80',
  docroot => '/var/www',
}

apache::vhost { 'port.443':
  priority => '21',
  port => '443',
  docroot => '/var/www',
}

apache::vhost { 'second.port.443':
  priority => '22',
  port => '443',
  docroot => '/var/www',
}
