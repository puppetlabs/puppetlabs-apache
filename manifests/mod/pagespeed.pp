# @summary
#   Installs and manages mod_pagespeed, which is a Google module that rewrites web pages to reduce latency and bandwidth.
#
#   This module does *not* manage the software repositories needed to automatically install the
#   mod-pagespeed-stable package. The module does however require that the package be installed,
#   or be installable using the system's default package provider.  You should ensure that this
#   pre-requisite is met or declaring `apache::mod::pagespeed` will cause the puppet run to fail.
# 
# @param inherit_vhost_config
#   Whether or not to inherit the vhost config
#
# @param filter_xhtml
#   Whether to filter by xhtml
#
# @param cache_path
#   Where to cache any files
#
# @param log_dir
#   The log directory
#
# @param memcache_servers
#
# @param rewrite_level
#   The inbuilt filter level to be used.
#   Can be `PassThrough`, `CoreFilters` or `OptimizeForBandwidth`.
#
# @param disable_filters
#   An array of filters that you wish to disable
#
# @param enable_filters
#   An array of filters that you wish to enable
#
# @param forbid_filters
#   An array of filters that you wish to forbid
#
# @param rewrite_deadline_per_flush_ms
#   How long to wait after attempting to rewrite an uncache/expired resource.
#
# @param additional_domains
#   Any additional domains that PageSpeed should optimize resources from.
#
# @param file_cache_size_kb
#   The maximum size of the cache
#
# @param file_cache_clean_interval_ms
#   The interval between which the cache is cleaned
#
# @param lru_cache_per_process
#   The amount of memory dedcated to each process
#
# @param lru_cache_byte_limit
#   How large a cache entry the cache will accept
#
# @param css_flatten_max_bytes
#   The maximum size in bytes of the flattened CSS
#
# @param css_inline_max_bytes
#   The maximum size in bytes of any image that will be inlined into CSS
#
# @param css_image_inline_max_bytes
#   The maximum size in bytes of any image that will be inlined into an HTML file
#   
# @param image_inline_max_bytes
#   The maximum size in bytes of any inlined CSS file
#
# @param js_inline_max_bytes
#   The maximum size in bytes of any inlined JavaScript file
#
# @param css_outline_min_bytes
#   The minimum size in bytes for a CSS file to qualify as an outline
#
# @param js_outline_min_bytes
#   The minimum size in bytes for a JavaScript file to qualify as an outline
#
# @param inode_limit
#   The file cache inode limit
#
# @param image_max_rewrites_at_once
#   The maximum number of images to optimize concurrently
#
# @param num_rewrite_threads
#   The amount of threads to use for rewrite at one time
#   These threads are used for short, latency-sensitive work.
#
# @param num_expensive_rewrite_threads
#   The amount of threads to use for rewrite at one time
#   These threads are used for full optimization.
#
# @param collect_statistics
#   Whether to collect cross-process statistics
#
# @param statistics_logging
#   Whether graphs should be drawn from collected statistics
#
# @param allow_view_stats
#   What sources should be allowed to view the resultant graph
#
# @param allow_pagespeed_console
#   What sources to draw the graphs from
#
# @param allow_pagespeed_message
#
# @param message_buffer_size
#   The amount of bytes to allocate as a buffer to hold recent log messages
#
# @param additional_configuration
#   Any additional configuration no included as it's own option
#
# @param package_ensure
#
# @example
#   class { 'apache::mod::pagespeed':
#     inherit_vhost_config          => 'on',
#     filter_xhtml                  => false,
#     cache_path                    => '/var/cache/mod_pagespeed/',
#     log_dir                       => '/var/log/pagespeed',
#     memache_servers               => [],
#     rewrite_level                 => 'CoreFilters',
#     disable_filters               => [],
#     enable_filters                => [],
#     forbid_filters                => [],
#     rewrite_deadline_per_flush_ms => 10,
#     additional_domains            => undef,
#     file_cache_size_kb            => 102400,
#     file_cache_clean_interval_ms  => 3600000,
#     lru_cache_per_process         => 1024,
#     lru_cache_byte_limit          => 16384,
#     css_flatten_max_bytes         => 2048,
#     css_inline_max_bytes          => 2048,
#     css_image_inline_max_bytes    => 2048,
#     image_inline_max_bytes        => 2048,
#     js_inline_max_bytes           => 2048,
#     css_outline_min_bytes         => 3000,
#     js_outline_min_bytes          => 3000,
#     inode_limit                   => 500000,
#     image_max_rewrites_at_once    => 8,
#     num_rewrite_threads           => 4,
#     num_expensive_rewrite_threads => 4,
#     collect_statistics            => 'on',
#     statistics_logging            => 'on',
#     allow_view_stats              => [],
#     allow_pagespeed_console       => [],
#     allow_pagespeed_message       => [],
#     message_buffer_size           => 100000,
#     additional_configuration      => { }
#   }
#
# @note
#   Verify that your system is compatible with the latest Google Pagespeed requirements.
#
#   Although this apache module requires the mod-pagespeed-stable package, Puppet does not manage the software repositories required to
#   automatically install the package. If you declare this class when the package is either not installed or not available to your 
#   package manager, your Puppet run will fail.
# 
# @see https://developers.google.com/speed/pagespeed/module/ for additional documentation.
#
class apache::mod::pagespeed (
  String $inherit_vhost_config                   = 'on',
  Boolean $filter_xhtml                          = false,
  Stdlib::Absolutepath $cache_path               = '/var/cache/mod_pagespeed/',
  Stdlib::Absolutepath $log_dir                  = '/var/log/pagespeed',
  Array $memcache_servers                        = [],
  String $rewrite_level                          = 'CoreFilters',
  Array $disable_filters                         = [],
  Array $enable_filters                          = [],
  Array $forbid_filters                          = [],
  Integer $rewrite_deadline_per_flush_ms         = 10,
  Optional[String] $additional_domains           = undef,
  Integer $file_cache_size_kb                    = 102400,
  Integer $file_cache_clean_interval_ms          = 3600000,
  Integer $lru_cache_per_process                 = 1024,
  Integer $lru_cache_byte_limit                  = 16384,
  Integer $css_flatten_max_bytes                 = 2048,
  Integer $css_inline_max_bytes                  = 2048,
  Integer $css_image_inline_max_bytes            = 2048,
  Integer $image_inline_max_bytes                = 2048,
  Integer $js_inline_max_bytes                   = 2048,
  Integer $css_outline_min_bytes                 = 3000,
  Integer $js_outline_min_bytes                  = 3000,
  Integer $inode_limit                           = 500000,
  Integer $image_max_rewrites_at_once            = 8,
  Integer $num_rewrite_threads                   = 4,
  Integer $num_expensive_rewrite_threads         = 4,
  String $collect_statistics                     = 'on',
  String $statistics_logging                     = 'on',
  Array $allow_view_stats                        = [],
  Array $allow_pagespeed_console                 = [],
  Array $allow_pagespeed_message                 = [],
  Integer $message_buffer_size                   = 100000,
  Variant[Array, Hash] $additional_configuration = {},
  Optional[String] $package_ensure               = undef,
) {
  include apache

  apache::mod { 'pagespeed':
    lib            => 'mod_pagespeed_ap24.so',
    package_ensure => $package_ensure,
  }

  $parameters = {
    'inherit_vhost_config'          => $inherit_vhost_config,
    'filter_xhtml'                  => $filter_xhtml,
    'cache_path'                    => $cache_path,
    'log_dir'                       => $log_dir,
    'memcache_servers'              => $memcache_servers,
    'rewrite_level'                 => $rewrite_level,
    'disable_filters'               => $disable_filters,
    'enable_filters'                => $enable_filters,
    'forbid_filters'                => $forbid_filters,
    'rewrite_deadline_per_flush_ms' => $rewrite_deadline_per_flush_ms,
    'additional_domains'            => $additional_domains,
    'file_cache_size_kb'            => $file_cache_size_kb,
    'file_cache_clean_interval_ms'  => $file_cache_clean_interval_ms,
    'lru_cache_per_process'         => $lru_cache_per_process,
    'lru_cache_byte_limit'          => $lru_cache_byte_limit,
    'css_flatten_max_bytes'         => $css_flatten_max_bytes,
    'css_inline_max_bytes'          => $css_inline_max_bytes,
    'css_image_inline_max_bytes'    => $css_image_inline_max_bytes,
    'image_inline_max_bytes'        => $image_inline_max_bytes,
    'js_inline_max_bytes'           => $js_inline_max_bytes,
    'css_outline_min_bytes'         => $css_outline_min_bytes,
    'js_outline_min_bytes'          => $js_outline_min_bytes,
    'inode_limit'                   => $inode_limit,
    'image_max_rewrites_at_once'    => $image_max_rewrites_at_once,
    'num_rewrite_threads'           => $num_rewrite_threads,
    'num_expensive_rewrite_threads' => $num_expensive_rewrite_threads,
    'collect_statistics'            => $collect_statistics,
    'allow_view_stats'              => $allow_view_stats,
    'statistics_logging'            => $statistics_logging,
    'allow_pagespeed_console'       => $allow_pagespeed_console,
    'message_buffer_size'           => $message_buffer_size,
    'allow_pagespeed_message'       => $allow_pagespeed_message,
    'additional_configuration'      => $additional_configuration,
  }

  file { 'pagespeed.conf':
    ensure  => file,
    path    => "${apache::mod_dir}/pagespeed.conf",
    mode    => $apache::file_mode,
    content => epp('apache/mod/pagespeed.conf.epp', $parameters),
    require => Exec["mkdir ${apache::mod_dir}"],
    before  => File[$apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
