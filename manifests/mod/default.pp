class apache::mod::default {
  apache::mod { 'actions': }
  apache::mod { 'alias': }
  apache::mod { 'auth_basic': }
  apache::mod { 'auth_digest': }
  if (versioncmp($::apache_version, '2.4') >= 0) {
    if $::operatingsystem == fedora {
      apache::mod { 'systemd': }
    }
    apache::mod { 'access_compat': }
    apache::mod { 'allowmethods': }
    apache::mod { 'authn_core': }
    apache::mod { 'authz_core': }
    apache::mod { 'authn_dbd': }
    apache::mod { 'authz_dbd': }
    apache::mod { 'authn_socache': }
    apache::mod { 'unixd': }
    apache::mod { 'data': }
    apache::mod { 'dbd': }
    apache::mod { 'filter': }
    apache::mod { 'dumpio': }
    apache::mod { 'remoteip': }
    apache::mod { 'reqtimeout': }
    apache::mod { 'slotmem_plain': }
    apache::mod { 'socache_dbm': }
    apache::mod { 'socache_memcache': }
    apache::mod { 'slotmem_shm': }
    apache::mod { 'socache_shmcb': }
    apache::mod { 'substitute': }
  } else {
    apache::mod { 'authn_alias': }
    apache::mod { 'authn_default': }
    apache::mod { 'authz_default': }
    apache::mod { 'authnz_ldap': }
    apache::mod { 'ldap': }
  }
  apache::mod { 'authn_anon': }
  apache::mod { 'authn_dbm': }
  apache::mod { 'authn_file': }
  apache::mod { 'authz_dbm': }
  apache::mod { 'authz_groupfile': }
  apache::mod { 'authz_host': }
  apache::mod { 'authz_owner': }
  apache::mod { 'authz_user': }
  apache::mod { 'autoindex': }
  include apache::mod::cache
  include apache::mod::cgi
  include apache::mod::dav
  include apache::mod::dav_fs
  apache::mod { 'deflate': }
  apache::mod { 'dir': }
  apache::mod { 'env': }
  apache::mod { 'expires': }
  apache::mod { 'ext_filter': }
  apache::mod { 'headers': }
  apache::mod { 'include': }
  apache::mod { 'info': }
  apache::mod { 'log_config': }
  apache::mod { 'logio': }
  apache::mod { 'mime': }
  apache::mod { 'mime_magic': }
  apache::mod { 'negotiation': }
  include apache::mod::proxy
  apache::mod { 'proxy_balancer': }
  if (versioncmp($::apache_version, '2.4') >= 0) {
    ## need these for proxy_balancer in apache 2.4.x
    apache::mod { 'lbmethod_bybusyness': }
    apache::mod { 'lbmethod_byrequests': }
    apache::mod { 'lbmethod_bytraffic': }
    apache::mod { 'lbmethod_heartbeat': }
  }
  apache::mod { 'proxy_connect': }
  apache::mod { 'proxy_ftp': }
  apache::mod { 'rewrite': }
  apache::mod { 'setenvif': }
  apache::mod { 'speling': }
  apache::mod { 'status': }
  apache::mod { 'suexec': }
  apache::mod { 'usertrack': }
  apache::mod { 'version': }
  apache::mod { 'vhost_alias': }
}
