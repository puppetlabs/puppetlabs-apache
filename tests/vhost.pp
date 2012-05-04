include apache
apache::vhost { 'test.vhost':
  port     => 80,
  docroot  => '/tmp/testvhost',
  template => 'apache/test.vhost.erb'
}
