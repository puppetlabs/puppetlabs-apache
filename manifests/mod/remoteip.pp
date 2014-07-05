class apache::mod::remoteip (
    $remoteIPProxiesHeader = undef,
    $remoteIPInternalProxy = ['127.0.0.1'],
    $header                = 'X-Forwarded-For',
    $remoteIPTrustedProxy  = undef,) {
    ::apache::mod { 'remoteip': }

    # Template uses:
    # - remoteIPInternalProxy
    # - remoteIPProxiesHeader
    # - header
    # - remoteIPTrustedProxy
    file { 'remoteip.conf':
        ensure  => file,
        path    => "${::apache::mod_dir}/remoteip.conf",
        content => template('apache/mod/remoteip.conf.erb'),
        require => Exec["mkdir ${::apache::mod_dir}"],
        before  => File[$::apache::mod_dir],
        notify  => Service['httpd'],
    }
}
