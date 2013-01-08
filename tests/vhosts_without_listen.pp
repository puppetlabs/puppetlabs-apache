# Mixing Name-based vhost with IP-specific vhosts requires `add_listen =>
# 'false'` on non-IP vhosts

class { 'apache':
  default_vhost     => false,
  default_ssl_vhost => false,
}

# Simple name-based vhost that doesn't declare conflicting "Listen 80"
apache::vhost { 'one.example.com':
  port       => '80',
  add_listen => false,
  docroot    => '/var/www/one',
}
# Second vhost with the same port
apache::vhost { 'two.example.com':
  port       => '80',
  add_listen => false,
  docroot    => '/var/www/two',
}

# Name-based vhost with IP
apache::vhost { 'three.example.com':
  port    => '80',
  ip      => '10.0.0.10',
  docroot => '/var/www/three',
}
# Name-based vhost with the same IP
apache::vhost { 'four.example.com':
  port    => '80',
  ip      => '10.0.0.10',
  docroot => '/var/www/four',
}
# Name-based vhost with servername parameter instead of ip/port
apache::vhost { '10.0.0.10:80':
  servername => 'five.example.com',
  docroot    => '/var/www/five',
}

# IP-based vhost
apache::vhost { '10.0.0.20:80':
  servername => 'six.example.com',
  ip_based   => true,
  docroot    => '/var/www/six',
}

# Same IP-based SSL vhost on a different port
apache::vhost { 'seven.example.com':
  ip       => '10.0.0.20',
  port     => '443',
  ip_based => true,
  docroot  => '/var/www/seven',
  ssl      => true,
}
