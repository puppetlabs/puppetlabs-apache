# @summary
#   Installs and configures `mod_ext_filter`.
# 
# @param ext_filter_define
#   Hash of filter names and their parameters.
#
# @example
#   class { 'apache::mod::ext_filter':
#     ext_filter_define => {
#       'slowdown'       => 'mode=output cmd=/bin/cat preservescontentlength',
#       'puppetdb-strip' => 'mode=output outtype=application/json cmd="pdb-resource-filter"',
#     },
#   }
#
# @see https://httpd.apache.org/docs/current/mod/mod_ext_filter.html for additional documentation.
#
class apache::mod::ext_filter (
  Optional[Hash] $ext_filter_define = undef
) {
  include apache

  ::apache::mod { 'ext_filter': }

  # Template uses
  # -$ext_filter_define

  if $ext_filter_define {
    file { 'ext_filter.conf':
      ensure  => file,
      path    => "${apache::mod_dir}/ext_filter.conf",
      mode    => $apache::file_mode,
      content => template('apache/mod/ext_filter.conf.erb'),
      require => [Exec["mkdir ${apache::mod_dir}"],],
      before  => File[$apache::mod_dir],
      notify  => Class['Apache::Service'],
    }
  }
}
