# @summary
#   Installs Apache development libraries.
#
# The libraries installed depends on the `dev_packages` parameter of the `apache::params` 
# class, based on your operating system:
# - **Debian** : `libaprutil1-dev`, `libapr1-dev`; `apache2-dev`
# - **FreeBSD**: `undef`; on FreeBSD, you must declare the `apache::package` or `apache` classes before declaring `apache::dev`.
# - **Gentoo**: `undef`.
# - **Red Hat**: `httpd-devel`.
class apache::dev {
  if ! defined(Class['apache']) {
    fail('You must include the apache base class before using any apache defined resources')
  }

  $packages = $apache::dev_packages
  if $packages { # FreeBSD doesn't have dev packages to install
    package { $packages:
      ensure  => present,
      require => Package['httpd'],
    }
  }
}
