class apache::mod::php (
  $package_name     = undef,
  $package_ensure   = 'present',
  $path             = undef,
  Array $extensions = ['.php'],
  $content          = undef,
  $template         = 'apache/mod/php.conf.erb',
  $source           = undef,
  $root_group       = $::apache::params::root_group,
  $php_version      = $::apache::params::php_version,
  # php security settings
  $php_date_timezone = 'UTC',
  $php_expose_php   = 'Off',
  $php_allow_url_fopen    = 'Off',
  $php_disable_functions  = 'pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,chown,diskfreespace,disk_free_space,disk_total_space,dl,exec,escapeshellarg,escapeshellcmd,fileinode,highlight_file,max_execution_time,passthru,pclose,phpinfo,popen,proc_close,proc_open,proc_get_status,proc_nice,proc_open,proc_terminate,set_time_limit,shell_exec,show_source,system,serialize,unserialize,__construct, __destruct, __call,__wakeup',
  $php_memory_limit       = '128M',
  $php_include_path       = '/usr/share/pear:/usr/share/php',
  $php_session_use_strict_mode    = 1,
  $php_session_cookie_secure      = true,
  $php_session_cookie_httponly    = true,
  $php_assert_active      = 'Off',
  $php_file_uploads       = 'Off',
) inherits apache::params {

  include ::apache
  $mod = "php${php_version}"

  if defined(Class['::apache::mod::prefork']) {
    Class['::apache::mod::prefork']->File["${mod}.conf"]
  }
  elsif defined(Class['::apache::mod::itk']) {
    Class['::apache::mod::itk']->File["${mod}.conf"]
  }
  else {
    fail('apache::mod::php requires apache::mod::prefork or apache::mod::itk; please enable mpm_module => \'prefork\' or mpm_module => \'itk\' on Class[\'apache\']')
  }

  if $source and ($content or $template != 'apache/mod/php.conf.erb') {
    warning('source and content or template parameters are provided. source parameter will be used')
  } elsif $content and $template != 'apache/mod/php.conf.erb' {
    warning('content and template parameters are provided. content parameter will be used')
  }

  $manage_content = $source ? {
    undef   => $content ? {
      undef   => template($template),
      default => $content,
    },
    default => undef,
  }

  # Determine if we have a package
  $mod_packages = $::apache::mod_packages
  if $package_name {
    $_package_name = $package_name
  } elsif has_key($mod_packages, $mod) { # 2.6 compatibility hack
    $_package_name = $mod_packages[$mod]
  } elsif has_key($mod_packages, 'phpXXX') { # 2.6 compatibility hack
    $_package_name = regsubst($mod_packages['phpXXX'], 'XXX', $php_version)
  } else {
    $_package_name = undef
  }

  $_lib = "libphp${php_version}.so"
  $_php_major = regsubst($php_version, '^(\d+)\..*$', '\1')

  if $::operatingsystem == 'SLES' {
      ::apache::mod { $mod:
        package        => $_package_name,
        package_ensure => $package_ensure,
        lib            => 'mod_php5.so',
        id             => "php${_php_major}_module",
        path           => "${::apache::lib_path}/mod_php5.so",
      }
    } else {
      ::apache::mod { $mod:
        package        => $_package_name,
        package_ensure => $package_ensure,
        lib            => $_lib,
        id             => "php${_php_major}_module",
        path           => $path,
      }

    }


  include ::apache::mod::mime
  include ::apache::mod::dir
  Class['::apache::mod::mime'] -> Class['::apache::mod::dir'] -> Class['::apache::mod::php']

  # Template uses $extensions
  file { "${mod}.conf":
    ensure  => file,
    path    => "${::apache::mod_dir}/${mod}.conf",
    owner   => 'root',
    group   => $root_group,
    mode    => $::apache::file_mode,
    content => $manage_content,
    source  => $source,
    require => [
      Exec["mkdir ${::apache::mod_dir}"],
    ],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }

  # Harden apache php.ini config
  # FIXME! is it applied before package installation? worked on second converge
  file { "${apache::mod::php::php_ini}":
    ensure => present,
  }
  file_line { 'php.ini: Configure timezone':
    path   => "${apache::mod::php::php_ini}",
    line   => "date.timezone = '${apache::mod::php::php_date_timezone}'",
    match  => '^date.timezone = .*',
    notify => Class['apache::service'],
  }
  file_line { 'php.ini: Configure expose_php':
    path   => "${apache::mod::php::php_ini}",
    line   => "expose_php = ${apache::mod::php::php_expose_php}",
    match  => '^expose_php = .*',
    notify => Class['apache::service'],
  }
  file_line { 'php.ini: Configure allow_url_fopen':
    path   => "${apache::mod::php::php_ini}",
    line   => "allow_url_fopen = ${apache::mod::php::php_allow_url_fopen}",
    match  => '^allow_url_fopen = .*',
    notify => Class['apache::service'],
  }
  file_line { 'php.ini: Configure disable_functions':
    path   => "${apache::mod::php::php_ini}",
    line   => "disable_functions = ${apache::mod::php::php_disable_functions}",
    match  => '^disable_functions =.*',
    notify => Class['apache::service'],
  }
  file_line { 'php.ini: Configure memory_limit':
    path   => "${apache::mod::php::php_ini}",
    line   => "memory_limit = ${apache::mod::php::php_memory_limit}",
    match  => '^memory_limit = .*',
    notify => Class['apache::service'],
  }
  file_line { 'php.ini: Configure include_path':
    path   => "${apache::mod::php::php_ini}",
    line   => "include_path = ${apache::mod::php::php_include_path}",
    match  => '^include_path = .*',
    notify => Class['apache::service'],
  }
  file_line { 'php.ini: Configure session.use_strict_mode':
    path   => "${apache::mod::php::php_ini}",
    line   => "session.use_strict_mode = ${apache::mod::php::php_session_use_strict_mode}",
    match  => '^session.use_strict_mode = .*',
    notify => Class['apache::service'],
  }
  file_line { 'php.ini: Configure session.cookie_secure':
    path   => "${apache::mod::php::php_ini}",
    line   => "session.cookie_secure = ${apache::mod::php::php_session_cookie_secure}",
    match  => '^session.cookie_secure = .*',
    notify => Class['apache::service'],
  }
  file_line { 'php.ini: Configure session.cookie_httponly':
    path   => "${apache::mod::php::php_ini}",
    line   => "session.cookie_httponly = ${apache::mod::php::php_session_cookie_httponly}",
    match  => '^session.cookie_httponly = .*',
    notify => Class['apache::service'],
  }
  file_line { 'php.ini: Configure assert.active':
    path   => "${apache::mod::php::php_ini}",
    line   => "assert.active = ${apache::mod::php::php_assert_active}",
    match  => '^assert.active = .*',
    notify => Class['apache::service'],
  }
  file_line { 'php.ini: Configure file_uploads':
    path   => "${apache::mod::php::php_ini}",
    line   => "file_uploads = ${apache::mod::php::php_file_uploads}",
    match  => '^file_uploads = .*',
    notify => Class['apache::service'],
  }

}
