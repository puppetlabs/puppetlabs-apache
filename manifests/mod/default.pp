class apache::mod::default {
  apache::mod { 'actions': }
  apache::mod { 'alias': }
  apache::mod { 'auth_basic': }
  apache::mod { 'auth_digest': }
  apache::mod { 'authn_alias': }
  apache::mod { 'authn_anon': }
  apache::mod { 'authn_dbm': }
  apache::mod { 'authn_default': }
  apache::mod { 'authn_file': }
  apache::mod { 'authnz_ldap': }
  apache::mod { 'authz_dbm': }
  apache::mod { 'authz_default': }
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
  apache::mod { 'ldap': }
  apache::mod { 'log_config': }
  apache::mod { 'logio': }
  apache::mod { 'mime': }
  apache::mod { 'mime_magic': }
  apache::mod { 'negotiation': }
  include apache::mod::proxy
  apache::mod { 'proxy_balancer': }
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
