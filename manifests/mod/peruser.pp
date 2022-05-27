# @summary
#   Installs `mod_peruser`.
# 
# @param minspareprocessors
# 
# @param minprocessors
#   The minimum amount of processors
# 
# @param maxprocessors
#   The maximum amount of processors
# 
# @param maxclients
#   The maximum amount of clients
# 
# @param maxrequestsperchild
#   The maximum amount of requests per child
# 
# @param idletimeout
# 
# @param expiretimeout
# 
# @param keepalive
# 
class apache::mod::peruser (
  Variant[Integer,String] $minspareprocessors   = '2',
  Variant[Integer,String] $minprocessors        = '2',
  Variant[Integer,String] $maxprocessors        = '10',
  Variant[Integer,String] $maxclients           = '150',
  Variant[Integer,String] $maxrequestsperchild  = '1000',
  Variant[Integer,String] $idletimeout          = '120',
  Variant[Integer,String] $expiretimeout        = '120',
  String $keepalive                             = 'Off',
) {
  include apache
  case $facts['os']['family'] {
    'freebsd' : {
      fail("Unsupported osfamily ${$facts['os']['family']}")
    }
    default: {
      if $facts['os']['family'] == 'gentoo' {
        ::portage::makeconf { 'apache2_mpms':
          content => 'peruser',
        }
      }

      if defined(Class['apache::mod::event']) {
        fail('May not include both apache::mod::peruser and apache::mod::event on the same node')
      }
      if defined(Class['apache::mod::itk']) {
        fail('May not include both apache::mod::peruser and apache::mod::itk on the same node')
      }
      if defined(Class['apache::mod::prefork']) {
        fail('May not include both apache::mod::peruser and apache::mod::prefork on the same node')
      }
      if defined(Class['apache::mod::worker']) {
        fail('May not include both apache::mod::peruser and apache::mod::worker on the same node')
      }
      File {
        owner => 'root',
        group => $apache::params::root_group,
        mode  => $apache::file_mode,
      }

      $mod_dir = $apache::mod_dir

      # Template uses:
      # - $minspareprocessors
      # - $minprocessors
      # - $maxprocessors
      # - $maxclients
      # - $maxrequestsperchild
      # - $idletimeout
      # - $expiretimeout
      # - $keepalive
      # - $mod_dir
      file { "${apache::mod_dir}/peruser.conf":
        ensure  => file,
        mode    => $apache::file_mode,
        content => template('apache/mod/peruser.conf.erb'),
        require => Exec["mkdir ${apache::mod_dir}"],
        before  => File[$apache::mod_dir],
        notify  => Class['apache::service'],
      }
      file { "${apache::mod_dir}/peruser":
        ensure  => directory,
        require => File[$apache::mod_dir],
      }
      file { "${apache::mod_dir}/peruser/multiplexers":
        ensure  => directory,
        require => File["${apache::mod_dir}/peruser"],
      }
      file { "${apache::mod_dir}/peruser/processors":
        ensure  => directory,
        require => File["${apache::mod_dir}/peruser"],
      }

      ::apache::peruser::multiplexer { '01-default': }
    }
  }
}
