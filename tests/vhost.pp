include apache
apache::vhost { 'test.vhost': template => 'apache/test.vhost.erb' }
