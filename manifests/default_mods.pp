# @summary
#   Installs and congfigures default mods for Apache
#
# @api private
class apache::default_mods (
  Boolean $all                                   = true,
  Optional[Variant[Array[String], String]] $mods = undef,
  String $apache_version                         = $apache::apache_version,
  Boolean $use_systemd                           = $apache::use_systemd,
) {
  # These are modules required to run the default configuration.
  # They are not configurable at this time, so we just include
  # them to make sure it works.
  case $facts['os']['family'] {
    'redhat': {
      ::apache::mod { 'log_config': }
      if versioncmp($apache_version, '2.4') >= 0 {
        # Lets fork it
        # Do not try to load mod_systemd on RHEL/CentOS 6 SCL.
        if ( !($facts['os']['family'] == 'redhat' and versioncmp($facts['os']['release']['major'], '7') == -1) and !($facts['os']['name'] == 'Amazon') ) {
          if ($use_systemd) {
            ::apache::mod { 'systemd': }
          }
        }
        if ($facts['os']['name'] == 'Amazon' and $facts['os']['release']['full'] == '2') {
          ::apache::mod { 'systemd': }
        }
        ::apache::mod { 'unixd': }
      }
    }
    'freebsd': {
      ::apache::mod { 'log_config': }
      ::apache::mod { 'unixd': }
    }
    'Suse': {
      ::apache::mod { 'log_config': }
    }
    default: {}
  }
  case $facts['os']['family'] {
    'gentoo': {}
    default: {
      ::apache::mod { 'authz_host': }
    }
  }
  # The rest of the modules only get loaded if we want all modules enabled
  if $all {
    case $facts['os']['family'] {
      'debian': {
        include apache::mod::authn_core
        include apache::mod::reqtimeout
        if versioncmp($apache_version, '2.4') < 0 {
          ::apache::mod { 'authn_alias': }
        }
      }
      'redhat': {
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

        if versioncmp($apache_version, '2.4') < 0 {
          ::apache::mod { 'authn_alias': }
          ::apache::mod { 'authn_default': }
        }
      }
      'freebsd': {
        include apache::mod::actions
        include apache::mod::authn_core
        include apache::mod::cache
        include apache::mod::disk_cache
        include apache::mod::headers
        include apache::mod::info
        include apache::mod::mime_magic
        include apache::mod::reqtimeout
        include apache::mod::rewrite
        include apache::mod::userdir
        include apache::mod::version
        include apache::mod::vhost_alias
        include apache::mod::speling
        include apache::mod::filter

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
    # filter is needed by mod_deflate
    include apache::mod::filter
    # authz_core is needed for 'Require' directive
    ::apache::mod { 'authz_core':
      id => 'authz_core_module',
    }
    # lots of stuff seems to break without access_compat
    ::apache::mod { 'access_compat': }

    include apache::mod::authz_user
    include apache::mod::authz_groupfile
    include apache::mod::env
  } elsif $mods {
    ::apache::default_mods::load { $mods: }

    if versioncmp($apache_version, '2.4') >= 0 {
      # authz_core is needed for 'Require' directive
      ::apache::mod { 'authz_core':
        id => 'authz_core_module',
      }

      # filter is needed by mod_deflate
      include apache::mod::filter
    }
  } else {
    if versioncmp($apache_version, '2.4') >= 0 {
      # authz_core is needed for 'Require' directive
      ::apache::mod { 'authz_core':
        id => 'authz_core_module',
      }

      # filter is needed by mod_deflate
      include apache::mod::filter
    }
  }
}
