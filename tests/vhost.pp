include apache
# Simple name-based vhosts
apache::vhost { 'one.example.com':
  port       => '80',
  docroot    => '/var/www/one',
}
apache::vhost { 'two.example.com':
  port       => '80',
  docroot    => '/var/www/two',
}
