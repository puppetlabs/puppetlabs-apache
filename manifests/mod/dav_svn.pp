# @summary
#   Installs and configures `mod_dav_svn`.
# 
# @param authz_svn_enabled
#   Specifies whether to install Apache mod_authz_svn
# 
# @see https://httpd.apache.org/docs/current/mod/mod_dav_svn.html for additional documentation.
#
class apache::mod::dav_svn (
  $authz_svn_enabled = false,
) {
  Class['::apache::mod::dav'] -> Class['::apache::mod::dav_svn']
  include apache
  include apache::mod::dav
  if($::operatingsystem == 'SLES' and versioncmp($::operatingsystemmajrelease, '12') < 0) {
    package { 'subversion-server':
      ensure   => 'installed',
      provider => 'zypper',
    }
  }

  ::apache::mod { 'dav_svn': }

  if $authz_svn_enabled {
    ::apache::mod { 'authz_svn':
      # authz_svn depends on symbols from the dav_svn module,
      # therefore, make sure authz_svn is loaded after dav_svn.
      loadfile_name => 'dav_svn_authz_svn.load',
      require       => Apache::Mod['dav_svn'],
    }
  }
}
