class apache::mod::negotiation (
  $force_language_priority = 'Prefer Fallback',
  $language_priority = [ 'en', 'ca', 'cs', 'da', 'de', 'el', 'eo', 'es', 'et',
                        'fr', 'he', 'hr', 'it', 'ja', 'ko', 'ltz', 'nl', 'nn',
                        'no', 'pl', 'pt', 'pt-BR', 'ru', 'sv', 'zh-CN',
                        'zh-TW' ],
) {
  validate_string($force_language_priority)
  validate_array($language_priority)

  ::apache::mod { 'negotiation': }
  # Template uses no variables
  file { 'negotiation.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/negotiation.conf",
    content => template('apache/mod/negotiation.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Service['httpd'],
  }
}
