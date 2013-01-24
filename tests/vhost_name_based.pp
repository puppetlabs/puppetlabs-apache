## Name-based vhosts
# Name-based vhosts respond to requests to specific domain names.

# Base class. Turn off the default vhosts; we will be declaring
# all vhosts below.
class { 'apache':
  default_vhost     => false,
  default_ssl_vhost => false,
}

# Name-based vhosts
apache::vhost { 'first.example.com':
  port    => '80',
  docroot => '/var/www/first',
}
apache::vhost { 'second.example.com':
  port    => '80',
  docroot => '/var/www/second',
}
