# @summary
#   Installs and congfigures default mods for Apache
#
# @api private
class apache::default_mods (
  Boolean $all                                         = true,
  Optional[Variant[Array[String[1]], String[1]]] $mods = undef,
  Boolean $use_systemd                                 = $apache::use_systemd,
) {
  # These are modules required to run the default configuration.
  # They are not configurable at this time, so we just include
  # them to make sure it works.
  case $facts['os']['family'] {
    'RedHat': {
      ::apache::mod { 'log_config': }
      if $facts['os']['name'] != 'Amazon' and $use_systemd {
        ::apache::mod { 'systemd': }
      }
      if ($facts['os']['name'] == 'Amazon' and $facts['os']['release']['full'] == '2') {
        ::apache::mod { 'systemd': }
      }
      ::apache::mod { 'unixd': }
    }
    'FreeBSD': {
      ::apache::mod { 'log_config': }
      ::apache::mod { 'unixd': }
    }
    'Suse': {
      ::apache::mod { 'log_config': }
    }
    default: {}
  }
  case $facts['os']['family'] {
    'Gentoo': {}
    default: {
      ::apache::mod { 'authz_host': }
    }
  }
  # The rest of the modules only get loaded if we want all modules enabled
  if $all {
    case $facts['os']['family'] {
      'Debian': {
        include apache::mod::authn_core
        include apache::mod::reqtimeout
      }
      'RedHat': {
        include apache::mod::actions
        include apache::mod::authn_core
        include apache::mod::cache
        include apache::mod::ext_filter
        include apache::mod::mime
        include apache::mod::mime_magic
        include apache::mod::rewrite
        include apache::mod::speling
        include apache::mod::suexec
        include apache::mod::version
        include apache::mod::vhost_alias
        ::apache::mod { 'auth_digest': }
        ::apache::mod { 'authn_anon': }
        ::apache::mod { 'authn_dbm': }
        ::apache::mod { 'authz_dbm': }
        ::apache::mod { 'authz_owner': }
        ::apache::mod { 'expires': }
        ::apache::mod { 'include': }
        ::apache::mod { 'logio': }
        ::apache::mod { 'substitute': }
        ::apache::mod { 'usertrack': }
      }
      'FreeBSD': {
        include apache::mod::actions
        include apache::mod::authn_core
        include apache::mod::cache
        include apache::mod::disk_cache
        include apache::mod::filter
        include apache::mod::headers
        include apache::mod::info
        include apache::mod::mime_magic
        include apache::mod::reqtimeout
        include apache::mod::rewrite
        include apache::mod::speling
        include apache::mod::userdir
        include apache::mod::version
        include apache::mod::vhost_alias

        ::apache::mod { 'asis': }
        ::apache::mod { 'auth_digest': }
        ::apache::mod { 'auth_form': }
        ::apache::mod { 'authn_anon': }
        ::apache::mod { 'authn_dbm': }
        ::apache::mod { 'authn_socache': }
        ::apache::mod { 'authz_dbd': }
        ::apache::mod { 'authz_dbm': }
        ::apache::mod { 'authz_owner': }
        ::apache::mod { 'dumpio': }
        ::apache::mod { 'expires': }
        ::apache::mod { 'file_cache': }
        ::apache::mod { 'imagemap': }
        ::apache::mod { 'include': }
        ::apache::mod { 'logio': }
        ::apache::mod { 'request': }
        ::apache::mod { 'session': }
        ::apache::mod { 'unique_id': }
      }
      default: {}
    }
    case $apache::mpm_module {
      'prefork': {
        include apache::mod::cgi
      }
      'worker': {
        include apache::mod::cgid
      }
      default: {
        # do nothing
      }
    }
    include apache::mod::alias
    include apache::mod::authn_file
    include apache::mod::autoindex
    include apache::mod::dav
    include apache::mod::dav_fs
    include apache::mod::deflate
    include apache::mod::dir
    include apache::mod::mime
    include apache::mod::negotiation
    include apache::mod::setenvif
    include apache::mod::auth_basic
    include apache::mod::log_forensic

    # filter is needed by mod_deflate
    include apache::mod::filter

    # authz_core is needed for 'Require' directive
    include apache::mod::authz_core

    # lots of stuff seems to break without access_compat
    ::apache::mod { 'access_compat': }

    include apache::mod::authz_user
    include apache::mod::authz_groupfile
    include apache::mod::env
  } elsif $mods {
    ::apache::default_mods::load { $mods: }

    # authz_core is needed for 'Require' directive
    include apache::mod::authz_core

    # filter is needed by mod_deflate
    include apache::mod::filter
  } else {
    # authz_core is needed for 'Require' directive
    include apache::mod::authz_core

    # filter is needed by mod_deflate
    include apache::mod::filter
  }
}
