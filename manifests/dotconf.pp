# = Define: apache::dotconf
#
# Define to create custom .conf files.
# It is simply a wrapper to a normal file type that
# notifies to apache service.
# Use source, content or template to define the source or content of
# the config file.
#
# == Parameters
#
# [*ensure*]
#   Sets the ensure parameter of the file resource.
#
# [*source*]
#   Sets the content of source parameter for the dotconf file
#   If defined, apache dotconf file will have the param: source => $source
#   Note source, content and template parameters are mutually
#   exclusive: don't use both
#
# [*content*]
#   Sets the content of content parameter for the dotconf file
#   If defined, apache dotconf file will have the param: content => $content
#   Note source, content and template parameters are mutually
#   exclusive: don't use both
#
# [*template*]
#   Sets the path to the template to use as content for dotconf file
#   If defined, apache dotconf file has: content => content("$template")
#   Note source, content and template parameters are mutually
#   exclusive: don't use both
#
# [*owner*]
#   Sets the owner of the file. It defaults to 'root'
#
# [*group*]
#   Sets the group of the file. It defaults to 'root'.
#
# [*mode*]
#   Sets the mode of the file. It defaults to 0644.
#
# [*path*]
#   Path of the config file. It sets the directory for the file created.
#   It defaults to $::apache::confd_dir
#
# == Usage
# apache::dotconf { "sarg": source => 'puppet://$servername/sarg/sarg.conf' }
# or
# apache::dotconf { "trac": content => 'template("trac/apache.conf.erb")' }
#
define apache::dotconf (
  $ensure   = 'present',
  $source   = '' ,
  $content  = '' ,
  $template = '',
  $owner    = 'root',
  $mode     = '0644',
  $group    = $::apache::params::root_group,
  $path     = '',
) {
  if ! defined(Class['apache']) {
    fail('You must include the apache base class before using any apache defined resources')
  }

  validate_re($ensure, '^(present|absent)$',
    'ensure parameter must be \'present\' or \'absent\'')

  $manage_source = $source ? {
    ''      => undef,
    default => $source,
  }

  $manage_content = $content ? {
    ''        => $template ? {
      ''      => undef,
      default => template($template),
    },
    default   => $content,
  }

  $manage_path = $path ? {
    ''      => "${::apache::confd_dir}/${name}.conf",
    default => "${path}/${name}.conf",
  }

  file { "apache_dotconf_${name}.conf":
    ensure  => $ensure,
    path    => $manage_path,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    source  => $manage_source,
    content => $manage_content,
    require => Package['httpd'],
    notify  => Class['::apache::service'],
  }
}
