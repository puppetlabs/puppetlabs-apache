# apache

[Module description]: #module-description

[Setup]: #setup
[Beginning with Apache]: #beginning-with-apache

[Usage]: #usage
[Configuring virtual hosts]: #configuring-virtual-hosts
[Configuring virtual hosts with SSL]: #configuring-virtual-hosts-with-ssl
[Configuring virtual host port and address bindings]: #configuring-virtual-host-port-and-address-bindings
[Configuring virtual hosts for apps and processors]: #configuring-virtual-hosts-for-apps-and-processors
[Configuring IP-based virtual hosts]: #configuring-ip-based-virtual-hosts
[Installing Apache modules]: #installing-apache-modules
[Installing arbitrary modules]: #installing-arbitrary-modules
[Installing specific modules]: #installing-specific-modules
[Configuring FastCGI servers]: #configuring-fastcgi-servers-to-handle-php-files
[Load balancing examples]: #load-balancing-examples
[apache affects]: #what-the-apache-module-affects

[Reference]: #reference

[Limitations]: #limitations

[Development]: #development
[Contributing]: #contributing

[`AddDefaultCharset`]: https://httpd.apache.org/docs/current/mod/core.html#adddefaultcharset
[`add_listen`]: #add_listen
[`Alias`]: https://httpd.apache.org/docs/current/mod/mod_alias.html#alias
[`AliasMatch`]: https://httpd.apache.org/docs/current/mod/mod_alias.html#aliasmatch
[aliased servers]: https://httpd.apache.org/docs/current/urlmapping.html
[`AllowEncodedSlashes`]: https://httpd.apache.org/docs/current/mod/core.html#allowencodedslashes
[`apache`]: #class-apache
[`apache_version`]: #apache_version
[`apache::balancer`]: #defined-type-apachebalancer
[`apache::balancermember`]: #defined-type-apachebalancermember
[`apache::fastcgi::server`]: #defined-type-apachefastcgiserver
[`apache::mod`]: #defined-type-apachemod
[`apache::mod::<MODULE NAME>`]: #classes-apachemodmodule-name
[`apache::mod::alias`]: #class-apachemodalias
[`apache::mod::auth_cas`]: #class-apachemodauth_cas
[`apache::mod::auth_mellon`]: #class-apachemodauth_mellon
[`apache::mod::authn_dbd`]: #class-apachemodauthn_dbd
[`apache::mod::authnz_ldap`]: #class-apachemodauthnz_ldap
[`apache::mod::cluster`]: #class-apachemodcluster
[`apache::mod::data]: #class-apachemoddata
[`apache::mod::disk_cache`]: #class-apachemoddisk_cache
[`apache::mod::dumpio`]: #class-apachemoddumpio
[`apache::mod::event`]: #class-apachemodevent
[`apache::mod::ext_filter`]: #class-apachemodext_filter
[`apache::mod::geoip`]: #class-apachemodgeoip
[`apache::mod::http2`]: #class-apachemodhttp2
[`apache::mod::itk`]: #class-apachemoditk
[`apache::mod::jk`]: #class-apachemodjk
[`apache::mod::ldap`]: #class-apachemodldap
[`apache::mod::passenger`]: #class-apachemodpassenger
[`apache::mod::peruser`]: #class-apachemodperuser
[`apache::mod::prefork`]: #class-apachemodprefork
[`apache::mod::proxy`]: #class-apachemodproxy
[`apache::mod::proxy_balancer`]: #class-apachemodproxybalancer
[`apache::mod::proxy_fcgi`]: #class-apachemodproxy_fcgi
[`apache::mod::proxy_html`]: #class-apachemodproxy_html
[`apache::mod::python`]: #class-apachemodpython
[`apache::mod::security`]: #class-apachemodsecurity
[`apache::mod::shib`]: #class-apachemodshib
[`apache::mod::ssl`]: #class-apachemodssl
[`apache::mod::status`]: #class-apachemodstatus
[`apache::mod::userdir`]: #class-apachemoduserdir
[`apache::mod::worker`]: #class-apachemodworker
[`apache::mod::wsgi`]: #class-apachemodwsgi
[`apache::params`]: #class-apacheparams
[`apache::version`]: #class-apacheversion
[`apache::vhost`]: #defined-type-apachevhost
[`apache::vhost::custom`]: #defined-type-apachevhostcustom
[`apache::vhost::WSGIImportScript`]: #wsgiimportscript
[Apache HTTP Server]: https://httpd.apache.org
[Apache modules]: https://httpd.apache.org/docs/current/mod/
[array]: https://docs.puppet.com/puppet/latest/reference/lang_data_array.html

[audit log]: https://github.com/SpiderLabs/ModSecurity/wiki/ModSecurity-2-Data-Formats#audit-log

[beaker-rspec]: https://github.com/puppetlabs/beaker-rspec

[certificate revocation list]: https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcarevocationfile
[certificate revocation list path]: https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcarevocationpath
[common gateway interface]: https://httpd.apache.org/docs/current/howto/cgi.html
[`confd_dir`]: #confd_dir
[`content`]: #content
[CONTRIBUTING.md]: CONTRIBUTING.md
[custom error documents]: https://httpd.apache.org/docs/current/custom-error.html
[`custom_fragment`]: #custom_fragment

[`default_mods`]: #default_mods
[`default_ssl_crl`]: #default_ssl_crl
[`default_ssl_crl_path`]: #default_ssl_crl_path
[`default_ssl_vhost`]: #default_ssl_vhost
[`dev_packages`]: #dev_packages
[`directory`]: #directory
[`directories`]: #parameter-directories-for-apachevhost
[`DirectoryIndex`]: https://httpd.apache.org/docs/current/mod/mod_dir.html#directoryindex
[`docroot`]: #docroot
[`docroot_owner`]: #docroot_owner
[`docroot_group`]: #docroot_group
[`DocumentRoot`]: https://httpd.apache.org/docs/current/mod/core.html#documentroot

[`EnableSendfile`]: https://httpd.apache.org/docs/current/mod/core.html#enablesendfile
[enforcing mode]: http://selinuxproject.org/page/Guide/Mode
[`ensure`]: https://docs.puppet.com/latest/type.html#package-attribute-ensure
[`error_log_file`]: #error_log_file
[`error_log_syslog`]: #error_log_syslog
[`error_log_pipe`]: #error_log_pipe
[`ExpiresByType`]: https://httpd.apache.org/docs/current/mod/mod_expires.html#expiresbytype
[exported resources]: http://docs.puppet.com/latest/reference/lang_exported.md
[`ExtendedStatus`]: https://httpd.apache.org/docs/current/mod/core.html#extendedstatus

[Facter]: http://docs.puppet.com/facter/
[FastCGI]: http://www.fastcgi.com/
[FallbackResource]: https://httpd.apache.org/docs/current/mod/mod_dir.html#fallbackresource
[`fallbackresource`]: #fallbackresource
[`FileETag`]: https://httpd.apache.org/docs/current/mod/core.html#fileetag
[filter rules]: https://httpd.apache.org/docs/current/filter.html
[`filters`]: #filters
[`ForceType`]: https://httpd.apache.org/docs/current/mod/core.html#forcetype

[GeoIPScanProxyHeaders]: http://dev.maxmind.com/geoip/legacy/mod_geoip2/#Proxy-Related_Directives
[`gentoo/puppet-portage`]: https://github.com/gentoo/puppet-portage

[Hash]: https://docs.puppet.com/puppet/latest/reference/lang_data_hash.html
[`HttpProtocolOptions`]: http://httpd.apache.org/docs/current/mod/core.html#httpprotocoloptions

[`IncludeOptional`]: https://httpd.apache.org/docs/current/mod/core.html#includeoptional
[`Include`]: https://httpd.apache.org/docs/current/mod/core.html#include
[interval syntax]: https://httpd.apache.org/docs/current/mod/mod_expires.html#AltSyn
[`ip`]: #ip
[`ip_based`]: #ip_based
[IP-based virtual hosts]: https://httpd.apache.org/docs/current/vhosts/ip-based.html

[`KeepAlive`]: https://httpd.apache.org/docs/current/mod/core.html#keepalive
[`KeepAliveTimeout`]: https://httpd.apache.org/docs/current/mod/core.html#keepalivetimeout
[`keepalive` parameter]: #keepalive
[`keepalive_timeout`]: #keepalive_timeout
[`limitreqfieldsize`]: https://httpd.apache.org/docs/current/mod/core.html#limitrequestfieldsize
[`limitreqfields`]: http://httpd.apache.org/docs/current/mod/core.html#limitrequestfields

[`lib`]: #lib
[`lib_path`]: #lib_path
[`Listen`]: https://httpd.apache.org/docs/current/bind.html
[`ListenBackLog`]: https://httpd.apache.org/docs/current/mod/mpm_common.html#listenbacklog
[`LoadFile`]: https://httpd.apache.org/docs/current/mod/mod_so.html#loadfile
[`LogFormat`]: https://httpd.apache.org/docs/current/mod/mod_log_config.html#logformat
[`logroot`]: #logroot
[Log security]: https://httpd.apache.org/docs/current/logs.html#security

[`manage_docroot`]: #manage_docroot
[`manage_user`]: #manage_user
[`manage_group`]: #manage_group
[`supplementary_groups`]: #supplementary_groups
[`MaxConnectionsPerChild`]: https://httpd.apache.org/docs/current/mod/mpm_common.html#maxconnectionsperchild
[`max_keepalive_requests`]: #max_keepalive_requests
[`MaxRequestWorkers`]: https://httpd.apache.org/docs/current/mod/mpm_common.html#maxrequestworkers
[`MaxSpareThreads`]: https://httpd.apache.org/docs/current/mod/mpm_common.html#maxsparethreads
[MIME `content-type`]: https://www.iana.org/assignments/media-types/media-types.xhtml
[`MinSpareThreads`]: https://httpd.apache.org/docs/current/mod/mpm_common.html#minsparethreads
[`mod_alias`]: https://httpd.apache.org/docs/current/mod/mod_alias.html
[`mod_auth_cas`]: https://github.com/Jasig/mod_auth_cas
[`mod_auth_kerb`]: http://modauthkerb.sourceforge.net/configure.html
[`mod_auth_gssapi`]: https://github.com/modauthgssapi/mod_auth_gssapi
[`mod_authnz_external`]: https://github.com/phokz/mod-auth-external
[`mod_auth_dbd`]: http://httpd.apache.org/docs/current/mod/mod_authn_dbd.html
[`mod_auth_mellon`]: https://github.com/UNINETT/mod_auth_mellon
[`mod_dbd`]: http://httpd.apache.org/docs/current/mod/mod_dbd.html
[`mod_disk_cache`]: https://httpd.apache.org/docs/2.2/mod/mod_disk_cache.html
[`mod_dumpio`]: https://httpd.apache.org/docs/2.4/mod/mod_dumpio.html
[`mod_env`]: http://httpd.apache.org/docs/current/mod/mod_env.html
[`mod_expires`]: https://httpd.apache.org/docs/current/mod/mod_expires.html
[`mod_ext_filter`]: https://httpd.apache.org/docs/current/mod/mod_ext_filter.html
[`mod_fcgid`]: https://httpd.apache.org/mod_fcgid/mod/mod_fcgid.html
[`mod_geoip`]: http://dev.maxmind.com/geoip/legacy/mod_geoip2/
[`mod_http2`]: https://httpd.apache.org/docs/current/mod/mod_http2.html
[`mod_info`]: https://httpd.apache.org/docs/current/mod/mod_info.html
[`mod_ldap`]: https://httpd.apache.org/docs/2.2/mod/mod_ldap.html
[`mod_mpm_event`]: https://httpd.apache.org/docs/current/mod/event.html
[`mod_negotiation`]: https://httpd.apache.org/docs/current/mod/mod_negotiation.html
[`mod_pagespeed`]: https://developers.google.com/speed/pagespeed/module/?hl=en
[`mod_passenger`]: https://www.phusionpassenger.com/library/config/apache/reference/
[`mod_php`]: http://php.net/manual/en/book.apache.php
[`mod_proxy`]: https://httpd.apache.org/docs/current/mod/mod_proxy.html
[`mod_proxy_balancer`]: https://httpd.apache.org/docs/current/mod/mod_proxy_balancer.html
[`mod_reqtimeout`]: https://httpd.apache.org/docs/current/mod/mod_reqtimeout.html
[`mod_python`]: http://modpython.org/
[`mod_rewrite`]: https://httpd.apache.org/docs/current/mod/mod_rewrite.html
[`mod_security`]: https://www.modsecurity.org/
[`mod_ssl`]: https://httpd.apache.org/docs/current/mod/mod_ssl.html
[`mod_status`]: https://httpd.apache.org/docs/current/mod/mod_status.html
[`mod_version`]: https://httpd.apache.org/docs/current/mod/mod_version.html
[`mod_wsgi`]: https://modwsgi.readthedocs.org/en/latest/
[module contribution guide]: https://docs.puppet.com/forge/contributing.html
[`mpm_module`]: #mpm_module
[multi-processing module]: https://httpd.apache.org/docs/current/mpm.html

[name-based virtual hosts]: https://httpd.apache.org/docs/current/vhosts/name-based.html
[`no_proxy_uris`]: #no_proxy_uris

[open source Puppet]: https://docs.puppet.com/puppet/
[`Options`]: https://httpd.apache.org/docs/current/mod/core.html#options

[`path`]: #path
[`Peruser`]: https://www.freebsd.org/cgi/url.cgi?ports/www/apache22-peruser-mpm/pkg-descr
[`port`]: #port
[`priority`]: #defined-types-apachevhost
[`proxy_dest`]: #proxy_dest
[`proxy_dest_match`]: #proxy_dest_match
[`proxy_pass`]: #proxy_pass
[`ProxyPass`]: https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass
[`ProxySet`]: https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxyset
[Puppet Enterprise]: https://docs.puppet.com/pe/
[Puppet Forge]: https://forge.puppet.com
[Puppet]: https://puppet.com
[Puppet module]: https://docs.puppet.com/puppet/latest/reference/modules_fundamentals.html
[Puppet module's code]: https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/default_mods.pp
[`purge_configs`]: #purge_configs
[`purge_vhost_dir`]: #purge_vhost_dir
[Python]: https://www.python.org/

[Rack]: http://rack.github.io/
[`rack_base_uris`]: #rack_base_uris
[RFC 2616]: https://www.ietf.org/rfc/rfc2616.txt
[`RequestReadTimeout`]: https://httpd.apache.org/docs/current/mod/mod_reqtimeout.html#requestreadtimeout
[rspec-puppet]: http://rspec-puppet.com/

[`ScriptAlias`]: https://httpd.apache.org/docs/current/mod/mod_alias.html#scriptalias
[`ScriptAliasMatch`]: https://httpd.apache.org/docs/current/mod/mod_alias.html#scriptaliasmatch
[`scriptalias`]: #scriptalias
[SELinux]: http://selinuxproject.org/
[`ServerAdmin`]: https://httpd.apache.org/docs/current/mod/core.html#serveradmin
[`serveraliases`]: #serveraliases
[`ServerLimit`]: https://httpd.apache.org/docs/current/mod/mpm_common.html#serverlimit
[`ServerName`]: https://httpd.apache.org/docs/current/mod/core.html#servername
[`ServerRoot`]: https://httpd.apache.org/docs/current/mod/core.html#serverroot
[`ServerTokens`]: https://httpd.apache.org/docs/current/mod/core.html#servertokens
[`ServerSignature`]: https://httpd.apache.org/docs/current/mod/core.html#serversignature
[Service attribute restart]: http://docs.puppet.com/latest/type.html#service-attribute-restart
[`source`]: #source
[`SSLCARevocationCheck`]: https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcarevocationcheck
[SSL certificate key file]: https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcertificatekeyfile
[SSL chain]: https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcertificatechainfile
[SSL encryption]: https://httpd.apache.org/docs/current/ssl/index.html
[`ssl`]: #ssl
[`ssl_cert`]: #ssl_cert
[`ssl_compression`]: #ssl_compression
[`ssl_key`]: #ssl_key
[`StartServers`]: https://httpd.apache.org/docs/current/mod/mpm_common.html#startservers
[suPHP]: http://www.suphp.org/Home.html
[`suphp_addhandler`]: #suphp_addhandler
[`suphp_configpath`]: #suphp_configpath
[`suphp_engine`]: #suphp_engine
[supported operating system]: https://forge.puppet.com/supported#puppet-supported-modules-compatibility-matrix

[`ThreadLimit`]: https://httpd.apache.org/docs/current/mod/mpm_common.html#threadlimit
[`ThreadsPerChild`]: https://httpd.apache.org/docs/current/mod/mpm_common.html#threadsperchild
[`TimeOut`]: https://httpd.apache.org/docs/current/mod/core.html#timeout
[template]: http://docs.puppet.com/puppet/latest/reference/lang_template.html
[`TraceEnable`]: https://httpd.apache.org/docs/current/mod/core.html#traceenable

[`UseCanonicalName`]: https://httpd.apache.org/docs/current/mod/core.html#usecanonicalname

[`verify_config`]: #verify_config
[`vhost`]: #defined-type-apachevhost
[`vhost_dir`]: #vhost_dir
[`virtual_docroot`]: #virtual_docroot

[Web Server Gateway Interface]: https://www.python.org/dev/peps/pep-3333/#abstract
[`WSGIRestrictEmbedded`]: http://modwsgi.readthedocs.io/en/develop/configuration-directives/WSGIRestrictEmbedded.html
[`WSGIPythonPath`]: http://modwsgi.readthedocs.org/en/develop/configuration-directives/WSGIPythonPath.html
[`WSGIPythonHome`]: http://modwsgi.readthedocs.org/en/develop/configuration-directives/WSGIPythonHome.html
[`WSGIApplicationGroup`]: https://modwsgi.readthedocs.io/en/develop/configuration-directives/WSGIApplicationGroup.html
[`WSGIPythonOptimize`]: https://modwsgi.readthedocs.io/en/develop/configuration-directives/WSGIPythonOptimize.html

#### Table of Contents

1. [Module description - What is the apache module, and what does it do?][Module description]
2. [Setup - The basics of getting started with apache][Setup]
    - [What the apache module affects][apache affects]
    - [Beginning with Apache - Installation][Beginning with Apache]
3. [Usage - The classes and defined types available for configuration][Usage]
    - [Configuring virtual hosts - Examples to help get started][Configuring virtual hosts]
    - [Configuring FastCGI servers to handle PHP files][Configuring FastCGI servers]
    - [Load balancing with exported and non-exported resources][Load balancing examples]
4. [Reference - An under-the-hood peek at what the module is doing and how][Reference]
5. [Limitations - OS compatibility, etc.][Limitations]
6. [Development - Guide for contributing to the module][Development]
    - [Contributing to the apache module][Contributing]
    
<a id="module-description"></a>
## Module description

[Apache HTTP Server][] (also called Apache HTTPD, or simply Apache) is a widely used web server. This [Puppet module][] simplifies the task of creating configurations to manage Apache servers in your infrastructure. It can configure and manage a range of virtual host setups and provides a streamlined way to install and configure [Apache modules][].

<a id="setup"></a>
## Setup

<a id="apache-affects"></a>
### What the apache module affects:

- Configuration files and directories (created and written to)
  - **WARNING**: Configurations *not* managed by Puppet will be purged.
- Package/service/configuration files for Apache
- Apache modules
- Virtual hosts
- Listened-to ports
- `/etc/make.conf` on FreeBSD and Gentoo

On Gentoo, this module depends on the [`gentoo/puppet-portage`][] Puppet module. Note that while several options apply or enable certain features and settings for Gentoo, it is not a [supported operating system][] for this module.

> **Warning**: This module modifies Apache configuration files and directories and purges any configuration not managed by Puppet. Apache configuration should be managed by Puppet, as unmanaged configuration files can cause unexpected failures.
>
>To temporarily disable full Puppet management, set the [`purge_configs`][] parameter in the [`apache`][] class declaration to false. We recommend this only as a temporary means of saving and relocating customized configurations.

<a id="beginning-with-apache"></a>
### Beginning with Apache

To have Puppet install Apache with the default parameters, declare the [`apache`][] class:

``` puppet
class { 'apache': }
```

When you declare this class with the default options, the module:

- Installs the appropriate Apache software package and [required Apache modules](#default_mods) for your operating system.
- Places the required configuration files in a directory, with the [default location](#conf_dir) Depends on operating system.
- Configures the server with a default virtual host and standard port ('80') and address ('\*') bindings.
- Creates a document root directory Depends on operating system, typically `/var/www`.
- Starts the Apache service.

Apache defaults depend on your operating system. These defaults work in testing environments but are not suggested for production. We recommend customizing the class's parameters to suit your site.

For instance, this declaration installs Apache without the apache module's [default virtual host configuration][Configuring virtual hosts], allowing you to customize all Apache virtual hosts:

``` puppet
class { 'apache':
  default_vhost => false,
}
```

> **Note**: When `default_vhost` is set to `false`, you have to add at least one `apache::vhost` resource or Apache will not start. To establish a default virtual host, either set the `default_vhost` in the `apache` class or use the [`apache::vhost`][] defined type. You can also configure additional specific virtual hosts with the [`apache::vhost`][] defined type.

<a id="usage"></a>
## Usage

<a id="configuring-virtual-hosts"></a>
### Configuring virtual hosts

The default [`apache`][] class sets up a virtual host on port 80, listening on all interfaces and serving the [`docroot`][] parameter's default directory of `/var/www`.


To configure basic [name-based virtual hosts][], specify the [`port`][] and [`docroot`][] parameters in the [`apache::vhost`][] defined type:

``` puppet
apache::vhost { 'vhost.example.com':
  port    => '80',
  docroot => '/var/www/vhost',
}
```

See the [`apache::vhost`][] defined type's reference for a list of all virtual host parameters.

> **Note**: Apache processes virtual hosts in alphabetical order, and server administrators can prioritize Apache's virtual host processing by prefixing a virtual host's configuration file name with a number. The [`apache::vhost`][] defined type applies a default [`priority`][] of 25, which Puppet interprets by prefixing the virtual host's file name with `25-`. This means that if multiple sites have the same priority, or if you disable priority numbers by setting the `priority` parameter's value to false, Apache still processes virtual hosts in alphabetical order.

To configure user and group ownership for `docroot`, use the [`docroot_owner`][] and [`docroot_group`][] parameters:

``` puppet
apache::vhost { 'user.example.com':
  port          => '80',
  docroot       => '/var/www/user',
  docroot_owner => 'www-data',
  docroot_group => 'www-data',
}
```

#### Configuring virtual hosts with SSL

To configure a virtual host to use [SSL encryption][] and default SSL certificates, set the [`ssl`][] parameter. You must also specify the [`port`][] parameter, typically with a value of '443', to accommodate HTTPS requests:

``` puppet
apache::vhost { 'ssl.example.com':
  port    => '443',
  docroot => '/var/www/ssl',
  ssl     => true,
}
```

To configure a virtual host to use SSL and specific SSL certificates, use the paths to the certificate and key in the [`ssl_cert`][] and [`ssl_key`][] parameters, respectively:

``` puppet
apache::vhost { 'cert.example.com':
  port     => '443',
  docroot  => '/var/www/cert',
  ssl      => true,
  ssl_cert => '/etc/ssl/fourth.example.com.cert',
  ssl_key  => '/etc/ssl/fourth.example.com.key',
}
```

To configure a mix of SSL and unencrypted virtual hosts at the same domain, declare them with separate [`apache::vhost`][] defined types:

``` puppet
# The non-ssl virtual host
apache::vhost { 'mix.example.com non-ssl':
  servername => 'mix.example.com',
  port       => '80',
  docroot    => '/var/www/mix',
}

# The SSL virtual host at the same domain
apache::vhost { 'mix.example.com ssl':
  servername => 'mix.example.com',
  port       => '443',
  docroot    => '/var/www/mix',
  ssl        => true,
}
```

To configure a virtual host to redirect unencrypted connections to SSL, declare them with separate [`apache::vhost`][] defined types and redirect unencrypted requests to the virtual host with SSL enabled:

``` puppet
apache::vhost { 'redirect.example.com non-ssl':
  servername      => 'redirect.example.com',
  port            => '80',
  docroot         => '/var/www/redirect',
  redirect_status => 'permanent',
  redirect_dest   => 'https://redirect.example.com/'
}

apache::vhost { 'redirect.example.com ssl':
  servername => 'redirect.example.com',
  port       => '443',
  docroot    => '/var/www/redirect',
  ssl        => true,
}
```

#### Configuring virtual host port and address bindings

Virtual hosts listen on all IP addresses ('\*') by default. To configure the virtual host to listen on a specific IP address, use the [`ip`][] parameter:

``` puppet
apache::vhost { 'ip.example.com':
  ip      => '127.0.0.1',
  port    => '80',
  docroot => '/var/www/ip',
}
```

You can also configure more than one IP address per virtual host by using an array of IP addresses for the [`ip`][] parameter:

``` puppet
apache::vhost { 'ip.example.com':
  ip      => ['127.0.0.1','169.254.1.1'],
  port    => '80',
  docroot => '/var/www/ip',
}
```

You can configure multiple ports per virtual host by using an array of ports for the [`port`][] parameter:

``` puppet
apache::vhost { 'ip.example.com':
  ip      => ['127.0.0.1'],
  port    => ['80','8080']
  docroot => '/var/www/ip',
}
```

To configure a virtual host with [aliased servers][], refer to the aliases using the [`serveraliases`][] parameter:

``` puppet
apache::vhost { 'aliases.example.com':
  serveraliases => [
    'aliases.example.org',
    'aliases.example.net',
  ],
  port          => '80',
  docroot       => '/var/www/aliases',
}
```

To set up a virtual host with a wildcard alias for the subdomain mapped to a directory of the same name, such as 'http://example.com.loc' mapped to `/var/www/example.com`, define the wildcard alias using the [`serveraliases`][] parameter and the document root with the [`virtual_docroot`][] parameter:

``` puppet
apache::vhost { 'subdomain.loc':
  vhost_name      => '*',
  port            => '80',
  virtual_docroot => '/var/www/%-2+',
  docroot         => '/var/www',
  serveraliases   => ['*.loc',],
}
```

To configure a virtual host with [filter rules][], pass the filter directives as an [array][] using the [`filters`][] parameter:

``` puppet
apache::vhost { 'subdomain.loc':
  port    => '80',
  filters => [
    'FilterDeclare  COMPRESS',
    'FilterProvider COMPRESS DEFLATE resp=Content-Type $text/html',
    'FilterChain    COMPRESS',
    'FilterProtocol COMPRESS DEFLATE change=yes;byteranges=no',
  ],
  docroot => '/var/www/html',
}
```

#### Configuring virtual hosts for apps and processors

To set up a virtual host with [suPHP][], use the following parameters:

* [`suphp_engine`][], to enable the suPHP engine.
* [`suphp_addhandler`][], to define a MIME type.
* [`suphp_configpath`][], to set which path suPHP passes to the PHP interpreter.
* [`directory`][], to configure Directory, File, and Location directive blocks.

For example:

``` puppet
apache::vhost { 'suphp.example.com':
  port             => '80',
  docroot          => '/home/appuser/myphpapp',
  suphp_addhandler => 'x-httpd-php',
  suphp_engine     => 'on',
  suphp_configpath => '/etc/php5/apache2',
  directories      => [
    { 'path'  => '/home/appuser/myphpapp',
      'suphp' => {
        user  => 'myappuser',
        group => 'myappgroup',
      },
    },
  ],
}
```

To configure a virtual host to use the [Web Server Gateway Interface][] (WSGI) for [Python][] applications, use the `wsgi` set of parameters:

``` puppet
apache::vhost { 'wsgi.example.com':
  port                        => '80',
  docroot                     => '/var/www/pythonapp',
  wsgi_application_group      => '%{GLOBAL}',
  wsgi_daemon_process         => 'wsgi',
  wsgi_daemon_process_options => {
    processes    => '2',
    threads      => '15',
    display-name => '%{GROUP}',
  },
  wsgi_import_script          => '/var/www/demo.wsgi',
  wsgi_import_script_options  => {
    process-group     => 'wsgi',
    application-group => '%{GLOBAL}',
  },
  wsgi_process_group          => 'wsgi',
  wsgi_script_aliases         => { '/' => '/var/www/demo.wsgi' },
}
```

As of Apache 2.2.16, Apache supports [FallbackResource][], a simple replacement for common RewriteRules. You can set a FallbackResource using the [`fallbackresource`][] parameter:

``` puppet
apache::vhost { 'wordpress.example.com':
  port             => '80',
  docroot          => '/var/www/wordpress',
  fallbackresource => '/index.php',
}
```

> **Note**: The `fallbackresource` parameter only supports the 'disabled' value since Apache 2.2.24.

To configure a virtual host with a designated directory for [Common Gateway Interface][] (CGI) files, use the [`scriptalias`][] parameter to define the `cgi-bin` path:

``` puppet
apache::vhost { 'cgi.example.com':
  port        => '80',
  docroot     => '/var/www/cgi',
  scriptalias => '/usr/lib/cgi-bin',
}
```

To configure a virtual host for [Rack][], use the [`rack_base_uris`][] parameter:

``` puppet
apache::vhost { 'rack.example.com':
  port           => '80',
  docroot        => '/var/www/rack',
  rack_base_uris => ['/rackapp1', '/rackapp2'],
}
```

#### Configuring IP-based virtual hosts

You can configure [IP-based virtual hosts][] to listen on any port and have them respond to requests on specific IP addresses. In this example, the server listens on ports 80 and 81, because the example virtual hosts are _not_ declared with a [`port`][] parameter:

``` puppet
apache::listen { '80': }

apache::listen { '81': }
```

Configure the IP-based virtual hosts with the [`ip_based`][] parameter:

``` puppet
apache::vhost { 'first.example.com':
  ip       => '10.0.0.10',
  docroot  => '/var/www/first',
  ip_based => true,
}

apache::vhost { 'second.example.com':
  ip       => '10.0.0.11',
  docroot  => '/var/www/second',
  ip_based => true,
}
```

You can also configure a mix of IP- and [name-based virtual hosts][] in any combination of [SSL][SSL encryption] and unencrypted configurations.

In this example, we add two IP-based virtual hosts on an IP address (in this example, 10.0.0.10). One uses SSL and the other is unencrypted:

``` puppet
apache::vhost { 'The first IP-based virtual host, non-ssl':
  servername => 'first.example.com',
  ip         => '10.0.0.10',
  port       => '80',
  ip_based   => true,
  docroot    => '/var/www/first',
}

apache::vhost { 'The first IP-based vhost, ssl':
  servername => 'first.example.com',
  ip         => '10.0.0.10',
  port       => '443',
  ip_based   => true,
  docroot    => '/var/www/first-ssl',
  ssl        => true,
}
```

Next, we add two name-based virtual hosts listening on a second IP address (10.0.0.20):

``` puppet
apache::vhost { 'second.example.com':
  ip      => '10.0.0.20',
  port    => '80',
  docroot => '/var/www/second',
}

apache::vhost { 'third.example.com':
  ip      => '10.0.0.20',
  port    => '80',
  docroot => '/var/www/third',
}
```

To add name-based virtual hosts that answer on either 10.0.0.10 or 10.0.0.20, you **must** disable the Apache default `Listen 80`, as it conflicts with the preceding IP-based virtual hosts. To do this, set the [`add_listen`][] parameter to `false`:

``` puppet
apache::vhost { 'fourth.example.com':
  port       => '80',
  docroot    => '/var/www/fourth',
  add_listen => false,
}

apache::vhost { 'fifth.example.com':
  port       => '80',
  docroot    => '/var/www/fifth',
  add_listen => false,
}
```

### Installing Apache modules

There are two ways to install [Apache modules][] using the Puppet apache module:

- Use the [`apache::mod::<MODULE NAME>`][] classes to [install specific Apache modules with parameters][Installing specific modules].
- Use the [`apache::mod`][] defined type to [install arbitrary Apache modules][Installing arbitrary modules].

#### Installing specific modules

The Puppet apache module supports installing many common [Apache modules][], often with parameterized configuration options. For a list of supported Apache modules, see the [`apache::mod::<MODULE NAME>`][] class references.

For example, you can install the `mod_ssl` Apache module with default settings by declaring the [`apache::mod::ssl`][] class:

``` puppet
class { 'apache::mod::ssl': }
```

[`apache::mod::ssl`][] has several parameterized options that you can set when declaring it. For instance, to enable `mod_ssl` with compression enabled, set the [`ssl_compression`][] parameter to true:

``` puppet
class { 'apache::mod::ssl':
  ssl_compression => true,
}
```

Note that some modules have prerequisites, which are documented in their references under [`apache::mod::<MODULE NAME>`][].

#### Installing arbitrary modules

You can pass the name of any module that your operating system's package manager can install to the [`apache::mod`][] defined type to install it. Unlike the specific-module classes, the [`apache::mod`][] defined type doesn't tailor the installation based on other installed modules or with specific parameters---Puppet only grabs and installs the module's package, leaving detailed configuration up to you.

For example, to install the [`mod_authnz_external`][] Apache module, declare the defined type with the 'mod_authnz_external' name:

``` puppet
apache::mod { 'mod_authnz_external': }
```

There are several optional parameters you can specify when defining Apache modules this way. See the [defined type's reference][`apache::mod`] for details.

<a id="configuring-fastcgi-servers-to-handle-php-files"></a>
### Configuring FastCGI servers to handle PHP files

#### FastCGI on Ubuntu 18.04

On Ubuntu 18.04, `mod_fastcgi` is no longer supported. So considering:

* an Apache Vhost with docroot set to `/var/www/html`
* a FastCGI server listening on `127.0.0.1:9000`

you can then use the [`custom_fragment`][] parameter to configure the virtual host to have the FastCGI server handle the specified file type:

``` puppet
apache::vhost { 'www':
  ...
  docroot         => '/var/www/html/',
  custom_fragment => 'ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/var/www/html/$1',
  ...
}
```

Please note you have to adjust the second ProxyPassMatch parameter to you docroot value (here `/var/www/html/`).

#### Other OSes

Add the [`apache::fastcgi::server`][] defined type to allow [FastCGI][] servers to handle requests for specific files. For example, the following defines a FastCGI server at 127.0.0.1 (localhost) on port 9000 to handle PHP requests:

``` puppet
apache::fastcgi::server { 'php':
  host       => '127.0.0.1:9000',
  timeout    => 15,
  flush      => false,
  faux_path  => '/var/www/php.fcgi',
  fcgi_alias => '/php.fcgi',
  file_type  => 'application/x-httpd-php'
}
```

You can then use the [`custom_fragment`][] parameter to configure the virtual host to have the FastCGI server handle the specified file type:

``` puppet
apache::vhost { 'www':
  ...
  custom_fragment => 'AddType application/x-httpd-php .php'
  ...
}
```

<a id="load-balancing-examples"></a> 
### Load balancing examples

Apache supports load balancing across groups of servers through the [`mod_proxy`][] Apache module. Puppet supports configuring Apache load balancing groups (also known as balancer clusters) through the [`apache::balancer`][] and [`apache::balancermember`][] defined types.

To enable load balancing with [exported resources][], export the [`apache::balancermember`][] defined type from the load balancer member server:

``` puppet
@@apache::balancermember { "${::fqdn}-puppet00":
  balancer_cluster => 'puppet00',
  url              => "ajp://${::fqdn}:8009",
  options          => ['ping=5', 'disablereuse=on', 'retry=5', 'ttl=120'],
}
```

Then, on the proxy server, create the load balancing group:

``` puppet
apache::balancer { 'puppet00': }
```

To enable load balancing without exporting resources, declare the following on the proxy server:

``` puppet
apache::balancer { 'puppet00': }

apache::balancermember { "${::fqdn}-puppet00":
  balancer_cluster => 'puppet00',
  url              => "ajp://${::fqdn}:8009",
  options          => ['ping=5', 'disablereuse=on', 'retry=5', 'ttl=120'],
}
```

Then declare the `apache::balancer` and `apache::balancermember` defined types on the proxy server.

To use the [ProxySet](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxyset) directive on the balancer, use the [`proxy_set`](#proxy_set) parameter of `apache::balancer`:

``` puppet
apache::balancer { 'puppet01':
  proxy_set => {
    'stickysession' => 'JSESSIONID',
    'lbmethod'      => 'bytraffic',
  },
}
```

Load balancing scheduler algorithms (`lbmethod`) are listed [in mod_proxy_balancer documentation](https://httpd.apache.org/docs/current/mod/mod_proxy_balancer.html).

<a id="reference"></a> 
## Reference

For information on classes, types and functions see the [REFERENCE.md](https://github.com/puppetlabs/puppetlabs-apache/blob/master/REFERENCE.md)

### Templates

The Apache module relies heavily on templates to enable the [`apache::vhost`][] and [`apache::mod`][] defined types. These templates are built based on [Facter][] facts that are specific to your operating system. Unless explicitly called out, most templates are not meant for configuration.

### Tasks

The Apache module has a task that allows a user to reload the Apache config without restarting the service. Please refer to to the [PE documentation](https://puppet.com/docs/pe/2017.3/orchestrator/running_tasks.html) or [Bolt documentation](https://puppet.com/docs/bolt/latest/bolt.html) on how to execute a task.

<a id="limitations"></a>
## Limitations

For an extensive list of supported operating systems, see [metadata.json](https://github.com/puppetlabs/puppetlabs-apache/blob/master/metadata.json)

### FreeBSD

In order to use this module on FreeBSD, you _must_ use apache24-2.4.12 (www/apache24) or newer.

### Gentoo

On Gentoo, this module depends on the [`gentoo/puppet-portage`][] Puppet module. Although several options apply or enable certain features and settings for Gentoo, it is not a [supported operating system][] for this module.

### RHEL/CentOS
The [`apache::mod::auth_cas`][], [`apache::mod::passenger`][], [`apache::mod::proxy_html`][] and [`apache::mod::shib`][] classes are not functional on RH/CentOS without providing dependency packages from extra repositories.

See their respective documentation below for related repositories and packages.

#### RHEL/CentOS 5

The [`apache::mod::passenger`][] and [`apache::mod::proxy_html`][] classes are untested because repositories are missing compatible packages.

#### RHEL/CentOS 6

The [`apache::mod::passenger`][] class is not installing, because the the EL6 repository is missing compatible packages.

#### RHEL/CentOS 7

The [`apache::mod::passenger`][] and [`apache::mod::proxy_html`][] classes are untested because the EL7 repository is missing compatible packages, which also blocks us from testing the [`apache::vhost`][] defined type's [`rack_base_uris`][] parameter.

### SELinux and custom paths

If [SELinux][] is in [enforcing mode][] and you want to use custom paths for `logroot`, `mod_dir`, `vhost_dir`, and `docroot`, you need to manage the files' context yourself.

You can do this with Puppet:

``` puppet
exec { 'set_apache_defaults':
  command => 'semanage fcontext -a -t httpd_sys_content_t "/custom/path(/.*)?"',
  path    => '/bin:/usr/bin/:/sbin:/usr/sbin',
  require => Package['policycoreutils-python'],
}

package { 'policycoreutils-python':
  ensure => installed,
}

exec { 'restorecon_apache':
  command => 'restorecon -Rv /apache_spec',
  path    => '/bin:/usr/bin/:/sbin:/usr/sbin',
  before  => Class['Apache::Service'],
  require => Class['apache'],
}

class { 'apache': }

host { 'test.server':
  ip => '127.0.0.1',
}

file { '/custom/path':
  ensure => directory,
}

file { '/custom/path/include':
  ensure  => present,
  content => '#additional_includes',
}

apache::vhost { 'test.server':
  docroot             => '/custom/path',
  additional_includes => '/custom/path/include',
}
```

You must set the contexts using `semanage fcontext` instead of `chcon` because Puppet's `file` resources reset the values' context in the database if the resource doesn't specify it.

### Ubuntu 10.04

The [`apache::vhost::WSGIImportScript`][] parameter creates a statement inside the virtual host that is unsupported on older versions of Apache, causing it to fail. This will be remedied in a future refactoring.

### Ubuntu 16.04
The [`apache::mod::suphp`][] class is untested since repositories are missing compatible packages.

<a id="development"></a> 
## Development

### Testing

To run the unit tests, install the necessary gems:

```
bundle install
```

And then execute the command:

```
bundle exec rake parallel_spec
```

To check the code coverage, run:

```
COVERAGE=yes bundle exec rake parallel_spec
```

## Development

Acceptance tests for this module leverage [puppet_litmus](https://github.com/puppetlabs/puppet_litmus).
To run the acceptance tests follow the instructions [here](https://github.com/puppetlabs/puppet_litmus/wiki/Tutorial:-use-Litmus-to-execute-acceptance-tests-with-a-sample-module-(MoTD)#install-the-necessary-gems-for-the-module).
You can also find a tutorial and walkthrough of using Litmus and the PDK on [YouTube](https://www.youtube.com/watch?v=FYfR7ZEGHoE).

If you run into an issue with this module, or if you would like to request a feature, please [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).
Every Monday the Puppet IA Content Team has [office hours](https://puppet.com/community/office-hours) in the [Puppet Community Slack](http://slack.puppet.com/), alternating between an EMEA friendly time (1300 UTC) and an Americas friendly time (0900 Pacific, 1700 UTC).

If you have problems getting this module up and running, please [contact Support](http://puppetlabs.com/services/customer-support).

If you submit a change to this module, be sure to regenerate the reference documentation as follows:

```bash
puppet strings generate --format markdown --out REFERENCE.md
```
