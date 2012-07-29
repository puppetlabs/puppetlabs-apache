include apache
apache::vhost { 'test.vhost':
  port               => 80,
  docroot            => '/tmp/testvhost',
  template           => 'apache/test.vhost.erb',
  serveradmin        => 'foo@bar.com',
  configure_firewall => false,
  auth               => '/tmp/testvhost/.htaccess',
}
