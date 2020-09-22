# @summary
#   Installs and configures `mod_rpaf`.
# 
# @param sethostname
#   Toggles whether to update vhost name so ServerName and ServerAlias work.
# 
# @param proxy_ips
#   List of IPs & bitmasked subnets to adjust requests for
#
# @param header
#   Header to use for the real IP address.
#
# @param template
#   Path to template to use for configuring mod_rpaf.
#
# @see https://github.com/gnif/mod_rpaf for additional documentation.
#
class apache::mod::rpaf (
  $sethostname = true,
  $proxy_ips   = ['127.0.0.1'],
  $header      = 'X-Forwarded-For',
  $template    = 'apache/mod/rpaf.conf.erb'
) {
  include apache
  ::apache::mod { 'rpaf': }

  # Template uses:
  # - $sethostname
  # - $proxy_ips
  # - $header
  file { 'rpaf.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/rpaf.conf",
    mode    => $apache::file_mode,
    content => template($template),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
