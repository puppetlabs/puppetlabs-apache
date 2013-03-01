define apache::passwd($users, $file='') {

  if (!is_hash($users)) {
    fail 'Parameter users has to be a hash. E.g. { "user" => "password"}'
  }

  if (empty($file)) {
    $target = $name
  } else {
    $target = $file
  }

  file { $target:
    content => template('apache/passwd.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package['httpd']
  }
}
