include apache
apache::vhost { 'test.vhost-ssl':
  port               => 443,
  docroot            => '/tmp/testvhost',
  serveradmin        => 'foo@bar.com',
  configure_firewall => false,
}
