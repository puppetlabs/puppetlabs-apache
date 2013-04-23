class apache::mod::worker (
  $serverlimit         = '25',
  $startservers        = '2',
  $maxclients          = '150',
  $minsparethreads     = '25',
  $maxsparethreads     = '75',
  $threadsperchild     = '25',
  $maxrequestsperchild = '0',
){

  file { "${apache::params::mod_dir}/worker.conf":
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('apache/mod/worker.conf.erb'),
  }

  case $::osfamily {
    'redhat': {
      file_line { '/etc/sysconfig/httpd worker enable':
        ensure => present,
        path   => '/etc/sysconfig/httpd',
        line   => 'HTTPD=/usr/sbin/httpd.worker',
        match  => '#?HTTPD=',
      }
    }
  }
}
