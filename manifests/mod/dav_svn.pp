class apache::mod::dav_svn (
  $authz_svn_enabled = false,
  $suse_lib_path = $::apache::params::suse_lib_path
) {
  Class['::apache::mod::dav'] -> Class['::apache::mod::dav_svn']
  include ::apache
  include ::apache::mod::dav
  if($::operatingsystem == 'SLES' and $::operatingsystemmajrelease < '12'){
    package { 'subversion-server':
      provider => 'zypper',
      ensure => 'installed',
    }
    ::apache::mod {'dav_svn':
      lib_path => $suse_lib_path
    }
    } else {
      ::apache::mod { 'dav_svn': }
    }

  if $::osfamily == 'Debian' and ($::operatingsystemmajrelease != '6' and $::operatingsystemmajrelease != '10.04' and $::operatingsystemrelease != '10.04' and $::operatingsystemmajrelease != '16.04') {
    $loadfile_name = undef
  } else {
    $loadfile_name = 'dav_svn_authz_svn.load'
  }

  if $authz_svn_enabled {
    if ($::operatingsystem == 'SLES' and $::operatingsystemmajrelease < '12'){
      ::apache::mod { 'authz_svn':
        loadfile_name => $loadfile_name,
        lib_path => $suse_lib_path,
        require       => Apache::Mod['dav_svn'],
      }
      } else {
        ::apache::mod { 'authz_svn':
          loadfile_name => $loadfile_name,
          require       => Apache::Mod['dav_svn'],
        }
      }
  }
}
