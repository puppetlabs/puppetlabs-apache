include apache
apache::vhost {
  'test.vhost':
    port     => 80,
    docroot  => '/tmp/testvhost',
    template => 'apache/test.vhost.erb';
  'test.vhost-override':
    port     => 80,
    docroot  => '/tmp/testvhost',
    override => ['Options', 'FileInfo'],
    template => 'apache/test.vhost.erb';
}
