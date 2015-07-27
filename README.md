# apache

[//]: # (START COVERAGE)

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

[Reference]: #reference
[Public classes]: #public-classes
[Private classes]: #private-classes
[Public defines]: #public-defines
[Private defines]: #private-defines
[Templates]: #templates

[Limitations]: #limitations

[Development]: #development
[Contributing]: #contributing
[Running tests]: #running-tests

[`AddDefaultCharset`]: http://httpd.apache.org/docs/current/mod/core.html#adddefaultcharset
[`add_listen`]: #add_listen
[aliased servers]: https://httpd.apache.org/docs/current/urlmapping.html
[`AllowEncodedSlashes`]: http://httpd.apache.org/docs/current/mod/core.html#allowencodedslashes
[`apache`]: #class-apache
[`apache_version`]: #apache_version
[`apache::balancer`]: #define-apachebalancer
[`apache::balancermember`]: #define-apachebalancermember
[`apache::fastcgi::server`]: #define-apachefastcgiserver
[`apache::mod`]: #define-apachemod
[`apache::mod::<MODULE NAME>`]: #classes-apachemodmodule-name
[`apache::mod::event`]: #apachemodevent
[`apache::mod::itk`]: #apachemoditk
[`apache::mod::passenger`]: #apachemodpassenger
[`apache::mod::peruser`]: #apachemodperuser
[`apache::mod::prefork`]: #apachemodprefork
[`apache::mod::proxy_html`]: #apachemodproxy_html
[`apache::mod::security`]: #apachemodsecurity
[`apache::mod::ssl`]: #apachemodssl
[`apache::mod::worker`]: #apachemodworker
[`apache::params`]: #class-apacheparams
[`apache::version`]: #class-apacheversion
[`apache::vhost`]: #define-apachevhost
[`apache::vhost::WSGIImportScript`]: #wsgiimportscript
[Apache HTTP Server]: http://httpd.apache.org
[Apache modules]: http://httpd.apache.org/docs/current/mod/
[array]: 

[certificate revocation list]: http://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcarevocationfile
[certificate revocation list path]: http://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcarevocationpath
[common gateway interface]: http://httpd.apache.org/docs/current/howto/cgi.html
[`confd_dir`]: #confd_dir
[custom error documents]: http://httpd.apache.org/docs/current/custom-error.html
[`custom_fragment`]: #custom_fragment

[`default_ssl_crl`]: #default_ssl_crl
[`default_ssl_crl_path`]: #default_ssl_crl_path
[`directory`]: #directory
[`docroot_owner`]: #docroot_owner
[`docroot_group`]: #docroot_group
[`Documentroot`]: https://httpd.apache.org/docs/current/mod/core.html#documentroot

[enforcing mode]: http://selinuxproject.org/page/Guide/Mode
[`ensure`]: https://docs.puppetlabs.com/references/latest/type.html#package-attribute-ensure
[exported resources]: http://docs.puppetlabs.com/latest/reference/lang_exported.md

[Facter]: http://docs.puppetlabs.com/facter/
[FastCGI]: http://www.fastcgi.com/
[FallbackResource]: https://httpd.apache.org/docs/current/mod/mod_dir.html#fallbackresource
[`fallbackresource`]: #fallbackresource
[filter rules]: http://httpd.apache.org/docs/current/filter.html
[`filters`]: #filters

[`gentoo/puppet-portage`]: https://github.com/gentoo/puppet-portage

[Hash]: https://docs.puppetlabs.com/puppet/latest/reference/lang_data_hash.html

[`ip`]: #ip
[`ip_based`]: #ip_based
[IP-based virtual hosts]: http://httpd.apache.org/docs/current/vhosts/ip-based.html

[`KeepAlive`]: http://httpd.apache.org/docs/current/mod/core.html#keepalive
[`KeepAliveTimeout`]: http://httpd.apache.org/docs/current/mod/core.html#keepalivetimeout
[`keepalive` parameter]: #keepalive
[`keepalive_timeout`]: #keepalive_timeout

[`lib_path`]: #lib_path
[`LoadFile`]: https://httpd.apache.org/docs/current/mod/mod_so.html#loadfile
[`LogFormat`]: https://httpd.apache.org/docs/current/mod/mod_log_config.html#logformat
[`logroot`]: #logroot
[Log security]: http://httpd.apache.org/docs/current/logs.html#security

[`manage_group`]: #manage_group
[`max_keepalive_requests`]: #max_keepalive_requests
[`mod_authnz_external`]: https://code.google.com/p/mod-auth-external/
[`mod_proxy`]: https://httpd.apache.org/docs/current/mod/mod_proxy.html
[module contribution guide]: http://docs.puppetlabs.com/forge/contributing.html
[`mpm_module`]: #mpm_module
[multi-processing module]: http://httpd.apache.org/docs/current/mpm.html

[name-based virtual hosts]: https://httpd.apache.org/docs/current/vhosts/name-based.html

[open source Puppet]: http://docs.puppetlabs.com/puppet/

[`path`]: #path
[`Peruser`]: http://www.freebsd.org/cgi/url.cgi?ports/www/apache22-peruser-mpm/pkg-descr
[`port`]: #port
[`priority`]: #defines-apachevhost
[`ProxySet`]: http://httpd.apache.org/docs/current/mod/mod_proxy.html#proxyset
[Puppet Enterprise]: http://docs.puppetlabs.com/pe/
[Puppet Forge]: http://forge.puppetlabs.com
[Puppet Labs]: http://puppetlabs.com
[Puppet module]: http://docs.puppetlabs.com/puppet/latest/reference/modules_fundamentals.html
[Puppet module's code]: https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/default_mods.pp
[`purge_configs`]: #purge_configs
[Python]: https://www.python.org/

[Rack]: http://rack.github.io/
[`rack_base_uris`]: #rack_base_uris
[rspec-puppet]: http://rspec-puppet.com/
[beaker-rspec]: https://github.com/puppetlabs/beaker-rspec

[`scriptalias`]: #scriptalias
[SELinux]: http://selinuxproject.org/
[`serveraliases`]: #serveraliases
[SSLCARevocationCheck]: http://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcarevocationcheck
[SSL certificate key file]: http://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcertificatekeyfile
[SSL chain]: https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcertificatechainfile
[SSL encryption]: https://httpd.apache.org/docs/current/ssl/index.html
[`ssl`]: #ssl
[`ssl_cert`]: #ssl_cert
[`ssl_compression`]: #ssl_compression
[`ssl_key`]: #ssl_key
[suPHP]: http://www.suphp.org/Home.html
[`suphp_addhandler`]: #suphp_addhandler
[`suphp_configpath`]: #suphp_configpath
[`suphp_engine`]: #suphp_engine
[supported operating system]: https://forge.puppetlabs.com/supported#puppet-supported-modules-compatibility-matrix

[template]: http://docs.puppetlabs.com/puppet/latest/reference/lang_template.html

[`vhost`]: #define-apachevhost
[`virtual_docroot`]: #virtual_docroot

[Web Server Gateway Interface]: https://www.python.org/dev/peps/pep-3333/#abstract

#### Table of Contents

1. [Module description - What is the apache module, and what does it do?][Module description]
2. [Setup - The basics of getting started with apache][Setup]
    - [Beginning with Apache - Installation][Beginning with Apache]
3. [Usage - The classes and defined types available for configuration][Usage]
    - [Configuring virtual hosts - Examples to help get started][Configuring virtual hosts]
    - [Configuring FastCGI servers to handle PHP files][Configuring FastCGI servers]
    - [Load balancing with exported and non-exported resources][Load balancing examples]
4. [Reference - An under-the-hood peek at what the module is doing and how][Reference]
    - [Public classes][]
    - [Private classes][]
    - [Public defines][]
    - [Private defines][]
    - [Templates][]
5. [Limitations - OS compatibility, etc.][Limitations]
6. [Development - Guide for contributing to the module][Development]
    - [Contributing to the apache module][Contributing]
    - [Running tests - A quick guide][Running tests]

## Module description

[Apache HTTP Server][] (also called Apache HTTPD, or simply Apache) is a widely used web server. This [Puppet module][] simplifies the task of creating configurations to manage Apache servers in your infrastructure. It can configure and manage a range of virtual host setups and provides a streamlined way to install and configure [Apache modules][].

## Setup

**What the apache Puppet module affects:**

- Configuration files and directories (created and written to)
  - **WARNING**: Configurations *not* managed by Puppet will be purged.
- Package/service/configuration files for Apache
- Apache modules
- Virtual hosts
- Listened-to ports
- `/etc/make.conf` on FreeBSD and Gentoo

On Gentoo, this module depends on the [`gentoo/puppet-portage`][] Puppet module. Note that while several options apply or enable certain features and settings for Gentoo, it is not a [supported operating system][] for this module.

**Note**: This module modifies Apache configuration files and directories and purges any configuration not managed by Puppet. Apache configuration should be managed by Puppet, as unmanaged configuration files can cause unexpected failures.

To temporarily disable full Puppet management, set the [`purge_configs`][] parameter in the [`apache`][] class declaration to 'false'. We recommend using this only as a temporary means of saving and relocating customized configurations.

### Beginning with Apache

To have Puppet install Apache with the default parameters, declare the [`apache`][] class:

~~~ puppet
class { 'apache': }
~~~

The Puppet module applies a default configuration based on your operating system; Debian, Red Hat, FreeBSD, and Gentoo systems each have unique default configurations. These defaults work in testing environments but are not suggested for production, and Puppet recommends customizing the class's parameters to suit your site. Use the [Reference](#reference) section to find information about the class's parameters and their default values.

You can customize parameters when declaring the `apache` class. For instance, this declaration installs Apache without the apache module's [default virtual host configuration][Configuring virtual hosts], allowing you to customize all Apache virtual hosts:

~~~ puppet
class { 'apache':
  default_vhosts => false,
}
~~~

## Usage

### Configuring a virtual host

The default [`apache`][] class sets up a virtual host on port 80, listening on all interfaces and serving the [`docroot`][] parameter's default directory of `/var/www`.

**Note**: See the [`apache::vhost`][] define's reference for a list of all virtual host parameters.

To configure basic [name-based virtual hosts][], specify the [`port`][] and [`docroot`][] parameters in the [`apache::vhost`][] define:

~~~ puppet
apache::vhost { 'vhost.example.com':
  port    => '80',
  docroot => '/var/www/vhost',
}
~~~

**Note**: Apache processes virtual hosts in alphabetical order, and server administrators can prioritize Apache's virtual host processing by prefixing a virtual host's configuration file name with a number. The [`apache::vhost`][] define applies a default [`priority`][] of 15, which Puppet interprets by prefixing the virtual host's file name with `15-`. This all means that if multiple sites have the same priority, or if you disable priority numbers by setting the `priority` parameter's value to 'false', Apache still processes virtual hosts in alphabetical order.

To configure user and group ownership for `docroot`, use the [`docroot_owner`][] and [`docroot_group`][] parameters:

~~~ puppet
apache::vhost { 'user.example.com':
  port          => '80',
  docroot       => '/var/www/user',
  docroot_owner => 'www-data',
  docroot_group => 'www-data',
}
~~~

#### Configuring virtual hosts with SSL

To configure a virtual host to use [SSL encryption][] and default SSL certificates, set the [`ssl`][] parameter. You must also specify the [`port`][] parameter, typically with a value of '443', to accomodate HTTPS requests:

~~~ puppet
apache::vhost { 'ssl.example.com':
  port    => '443',
  docroot => '/var/www/ssl',
  ssl     => true,
}
~~~

To configure a virtual host to use SSL and specific SSL certificates, use the paths to the certificate and key in the [`ssl_cert`][] and [`ssl_key`][] parameters, respectively:

~~~ puppet
apache::vhost { 'cert.example.com':
  port     => '443',
  docroot  => '/var/www/cert',
  ssl      => true,
  ssl_cert => '/etc/ssl/fourth.example.com.cert',
  ssl_key  => '/etc/ssl/fourth.example.com.key',
}
~~~

To configure a mix of SSL and unencrypted virtual hosts at the same domain, declare them with separate [`apache::vhost`] defines:

~~~ puppet
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
~~~

To configure a virtual host to redirect unencrypted connections to SSL, declare them with separate [`apache::vhost`] defines and redirect unencrypted requests to the virtual host with SSL enabled:

~~~ puppet
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
~~~

#### Configuring virtual host port and address bindings

Virtual hosts listen on all IP addresses ('*') by default. To configure the virtual host to listen on a specific IP address, use the [`ip`][] parameter:

~~~ puppet
apache::vhost { 'ip.example.com':
  ip      => '127.0.0.1',
  port    => '80',
  docroot => '/var/www/ip',
}
~~~

To configure a virtual host with [aliased servers][], refer to the aliases using the [`serveraliases`][] parameter:

~~~ puppet
apache::vhost { 'aliases.example.com':
  serveraliases => [
    'aliases.example.org',
    'aliases.example.net',
  ],
  port          => '80',
  docroot       => '/var/www/aliases',
}
~~~

To set up a virtual host with a wildcard alias for the subdomain mapped to a same-named directory, such as 'http://example.com.loc' mapped to `/var/www/example.com`, define the wildcard alias using the [`serveraliases`][] parameter and the document root with the [`virtual_docroot`][] parameter:

~~~ puppet
apache::vhost { 'subdomain.loc':
  vhost_name      => '*',
  port            => '80',
  virtual_docroot => '/var/www/%-2+',
  docroot         => '/var/www',
  serveraliases   => ['*.loc',],
}
~~~

To configure a virtual host with [filter rules][], pass the filter directives as an array using the [`filters`][] parameter:

~~~ puppet
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
~~~

#### Configuring virtual hosts for apps and processors

To set up a virtual host with [suPHP][], use the [`suphp_engine`][] parameter to enable the suPHP engine, [`suphp_addhandler`][] parameter to define a MIME type, [`suphp_configpath`][] to set which path suPHP passes to the PHP interpreter, and the [`directory`][] parameter to configure Directory, File, and Location directive blocks:

~~~ puppet
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
~~~

You can use a set of parameters to configure a virtual host to use the [Web Server Gateway Interface][] (WSGI) for [Python][] applications:

~~~ puppet
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
~~~

Starting in Apache 2.2.16, Apache supports [FallbackResource][], a simple replacement for common RewriteRules. You can set a FallbackResource using the [`fallbackresource`][] parameter:

~~~ puppet
apache::vhost { 'wordpress.example.com':
  port             => '80',
  docroot          => '/var/www/wordpress',
  fallbackresource => '/index.php',
}
~~~

**Note**: The `fallbackresource` parameter only supports the 'disabled' value since Apache 2.2.24.

To configure a virtual host with a designated directory for [Common Gateway Interface][] (CGI) files, use the [`scriptalias`][] parameter to define the `cgi-bin` path:

~~~ puppet
apache::vhost { 'cgi.example.com':
  port        => '80',
  docroot     => '/var/www/cgi',
  scriptalias => '/usr/lib/cgi-bin',
}
~~~

To configure a virtual host for [Rack][], use the [`rack_base_uris`][] parameter:

~~~ puppet
apache::vhost { 'rack.example.com':
  port           => '80',
  docroot        => '/var/www/rack',
  rack_base_uris => ['/rackapp1', '/rackapp2'],
}
~~~

#### Configuring IP-based virtual hosts

You can configure [IP-based virtual hosts][] to listen on any port and have them respond to requests on specific IP addresses. In this example, we set the server to listen on ports 80 and 81 because the example virtual hosts are _not_ declared with a [`port`][] parameter:

~~~ puppet
apache::listen { '80': }

apache::listen { '81': }
~~~

Then we configure the IP-based virtual hosts with the [`ip_based`][] parameter:

~~~ puppet
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
~~~

You can also configure a mix of IP- and [name-based virtual hosts][], and in any combination of [SSL][SSL encryption] and unencrypted configurations. First, we add two IP-based virtual hosts on an IP address (in this example, 10.0.0.10). One uses SSL and the other is unencrypted:

~~~ puppet
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
~~~

Next, we add two name-based virtual hosts listening on a second IP address (10.0.0.20):

~~~ puppet
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
~~~

To add name-based virtual hosts that answer on either 10.0.0.10 or 10.0.0.20, you **must** set the [`add_listen`][] parameter to 'false' to disable the default Apache setting of `Listen 80`, as it conflicts with the preceding IP-based virtual hosts.

~~~ puppet
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
~~~

### Installing Apache modules

There's two ways to install [Apache modules][] using the Puppet apache module:

- Use the [`apache::mod::<MODULE NAME>`][] classes to [install specific Apache modules with parameters][Installing specific modules].
- Use the [`apache::mod`][] define to [install arbitrary Apache modules][Installing arbitrary modules].

#### Installing specific modules

The Puppet apache module supports installing many common [Apache modules][], often with parameterized configuration options. For a list of supported Apache modules, see the [`apache::mod::<MODULE NAME>`][] class references.

For example, you can install the `mod_ssl` Apache module with default settings by declaring the [`apache::mod::ssl`][] class:

~~~ puppet
class { 'apache::mod::ssl': }
~~~

[`apache::mod::ssl`][] has several parameterized options that you can set when declaring it. For instance, to enable `mod_ssl` with compression enabled, set the [`ssl_compression`][] parameter to 'true':

~~~ puppet
class { 'apache::mod::ssl':
  ssl_compression => true,
}
~~~

Note that some modules have prerequisites, which are documented in their references under [`apache::mod::<MODULE NAME>`][].

#### Installing arbitrary modules

You can pass the name of any module that your operating system's package manager can install to the [`apache::mod`][] define to install it. Unlike the specific-module classes, the [`apache::mod`][] define doesn't tailor the installation based on other installed modules or with specific parameters---Puppet only grabs and installs the module's package, leaving detailed configuration up to you. 

For example, to install the [`mod_authnz_external`][] Apache module, declare the define with the 'mod_authnz_external' name:

~~~ puppet
apache::mod { 'mod_authnz_external': }
~~~

There's several optional parameters you can specify when defining Apache modules this way. See the [define's reference][`apache::mod`] for details.

### Configuring FastCGI servers to handle PHP files

Add the [`apache::fastcgi::server`][] define to allow [FastCGI][] servers to handle requests for specific files. For example, the following defines a FastCGI server at 127.0.0.1 (localhost) on port 9000 to handle PHP requests:

~~~ puppet
apache::fastcgi::server { 'php':
  host       => '127.0.0.1:9000',
  timeout    => 15,
  flush      => false,
  faux_path  => '/var/www/php.fcgi',
  fcgi_alias => '/php.fcgi',
  file_type  => 'application/x-httpd-php'
}
~~~

You can then use the [`custom_fragment`] parameter to configure the virtual host to have the FastCGI server handle the specified file type:

~~~ puppet
apache::vhost { 'www':
  ...
  custom_fragment => 'AddType application/x-httpd-php .php'
  ...
}
~~~

### Load balancing examples

Apache supports load balancing across groups of servers through the [`mod_proxy`][] Apache module. Puppet supports configuring Apache load balancing groups (also known as balancer clusters) through the [`apache::balancer`][] and [`apache::balancermember`][] defines.

To enable load balancing with [exported resources][], export the [`apache::balancermember`][] define from the load balancer member server:

~~~ puppet
@@apache::balancermember { "${::fqdn}-puppet00":
  balancer_cluster => 'puppet00',
  url              => "ajp://${::fqdn}:8009",
  options          => ['ping=5', 'disablereuse=on', 'retry=5', 'ttl=120'],
}
~~~

Then, on the proxy server, create the load balancing group:

~~~ puppet
apache::balancer { 'puppet00': }
~~~

To enable load balancing without exporting resources, declare the following on the proxy server:

~~~ puppet
apache::balancer { 'puppet00': }

apache::balancermember { "${::fqdn}-puppet00":
    balancer_cluster => 'puppet00',
    url              => "ajp://${::fqdn}:8009",
    options          => ['ping=5', 'disablereuse=on', 'retry=5', 'ttl=120'],
  }
~~~

Then declare the `apache::balancer` and `apache::balancermember` defines on the proxy server.

[//]: # (NEEDS CLARIFICATION)

If you need to use the [ProxySet](http://httpd.apache.org/docs/current/mod/mod_proxy.html#proxyset) directive on the balancer, use the [`proxy_set`](#proxy_set) parameter of `apache::balancer`:

~~~ puppet
apache::balancer { 'puppet01':
  proxy_set => {
    'stickysession' => 'JSESSIONID',
  },
}
~~~

## Reference

- [**Public Classes**](#public-classes)
    - [Class: apache](#class-apache)
    - [Class: apache::dev](#class-apachedev)
    - [Classes: apache::mod::*](#classes-apachemodname)
- [**Private Classes**](#private-classes)
    - [Class: apache::confd::no_accf](#class-apacheconfdno_accf)
    - [Class: apache::default_confd_files](#class-apachedefault_confd_files)
    - [Class: apache::default_mods](#class-apachedefault_mods)
    - [Class: apache::package](#class-apachepackage)
    - [Class: apache::params](#class-apacheparams)
    - [Class: apache::service](#class-apacheservice)
    - [Class: apache::version](#class-apacheversion)
- [**Public Defines**](#public-defines)
    - [Define: apache::balancer](#define-apachebalancer)
    - [Define: apache::balancermember](#define-apachebalancermember)
    - [Define: apache::custom_config](#define-apachecustom_config)
    - [Define: apache::fastcgi::server](#define-fastcgi-server)
    - [Define: apache::listen](#define-apachelisten)
    - [Define: apache::mod](#define-apachemod)
    - [Define: apache::namevirtualhost](#define-apachenamevirtualhost)
    - [Define: apache::vhost](#define-apachevhost)
- [**Private Defines**](#private-defines)
    - [Define: apache::default_mods::load](#define-default_mods-load)
    - [Define: apache::peruser::multiplexer](#define-apacheperusermultiplexer)
    - [Define: apache::peruser::processor](#define-apacheperuserprocessor)
    - [Define: apache::security::file_link](#define-apachesecurityfile_link)
- [**Templates**](#templates)

### Public Classes

[//]: # (TO DO:)
[//]: # (  - Define public classes here.)
[//]: # (  - Alphabetize and/or reorder classes.)
[//]: # (  - Confirm all classes listed are in the section TOC.)

#### Class: `apache`

Guides the basic setup and installation of Apache on your system.

When this class is declared with the default options, Puppet:

- Installs the appropriate Apache software package and [required Apache modules](#default_mods) for your operating system.
- Places the required configuration files in a directory, with the [default location](#conf_dir) determined by your operating system.
- Configures the server with a default virtual host and standard port ('80') and address ('*') bindings.
- Creates a document root directory determined by your operating system, typically `/var/www`.
- Starts the Apache service.

You can simply declare the default `apache` class:

~~~ puppet
class { 'apache': }
~~~

You can establish a default virtual host in this class, by using the [`apache::vhost`][] define, or both. You can also configure additional specific virtual hosts with the [`apache::vhost`][] define. Puppet recommends customizing the `apache` class's declaration with the following parameters, as its default settings are not optimized for production.

**Parameters within `apache`:**

##### `allow_encoded_slashes`

Sets the server default for the [`AllowEncodedSlashes`][] declaration, which modifies the responses to URLs containing '\' and '/' characters. Valid options: 'on', 'off', 'nodecode'. Default: 'undef', which omits the declaration from the server's configuration and uses Apache's default setting of 'off'.

##### `apache_version`

Configures module template behavior, package names, and default Apache modules by defining the version of Apache to use. Default: Determined by your operating system family and release via the [`apache::version`][] class. Puppet recommends against manually configuring this parameter without reason.

##### `conf_dir`

Sets the directory where the Apache server's main configuration file is located. Default: Depends on your operating system.

- **Debian**: `/etc/apache2`
- **FreeBSD**: `/usr/local/etc/apache22`
- **Gentoo**: `/etc/apache2`
- **Red Hat**: `/etc/httpd/conf`

##### `conf_template`

Defines the [template][] used for the main Apache configuration file. Default: `apache/httpd.conf.erb`. Modifying this parameter is potentially risky, as the apache Puppet module is designed to use a minimal configuration file customized by `conf.d` entries.

##### `confd_dir`

Sets the location of the Apache server's custom configuration directory. Default: Depends on your operating system.

- **Debian**: `/etc/apache2/conf.d`
- **FreeBSD**: `/usr/local/etc/apache22`
- **Gentoo**: `/etc/apache2/conf.d`
- **Red Hat**: `/etc/httpd/conf`

##### `default_charset`

Used as the [`AddDefaultCharset`][] directive in the main configuration file. Default: 'undef'.

##### `default_confd_files`

Determines whether Puppet generates a default set of includable Apache configuration files in the directory defined by the [`confd_dir`][] parameter. These configuration files correspond to what is typically installed with the Apache package on the server's operating system. Valid options: Boolean. Default: 'true'.

##### `default_mods`

Determines whether to configure and enable a set of default [Apache modules][] depending on your operating system. Valid options: 'true', 'false', or an array of Apache module names. Default: 'true'.

If this parameter's value is 'false', Puppet only includes the Apache modules required to make the HTTP daemon work on your operating system, and you can declare any other modules separately using the [`apache::mod::<MODULE NAME>`][] class or [`apache::mod`][] define. 

If 'true', Puppet installs additional modules, the list of which depends on the operating system as well as the [`apache_version`][] and [`mpm_module`][] parameters' values. As these lists of modules can change frequently, consult the [Puppet module's code][] for up-to-date lists.

If this parameter contains an array, Puppet instead enables all passed Apache modules.

##### `default_ssl_ca`

Sets the default certificate authority for the Apache server. Default: 'undef'. 

While this default value results in a functioning Apache server, you **must** update this parameter with your certificate authority information before deploying this server in a production environment.

##### `default_ssl_cert`

Sets the [SSL encryption][] certificate location. Default: Determined by your operating system.

- **Debian**: `/etc/ssl/certs/ssl-cert-snakeoil.pem`
- **FreeBSD**: `/usr/local/etc/apache22/server.crt`
- **Gentoo**: `/etc/ssl/apache2/server.crt`
- **Red Hat**: `/etc/pki/tls/certs/localhost.crt`

While the default value results in a functioning Apache server, you **must** update this parameter with your certificate location before deploying this server in a production environment.

##### `default_ssl_chain`

Sets the default [SSL chain][] location. Default: 'undef'. 

While this default value results in a functioning Apache server, you **must** update this parameter with your SSL chain before deploying this server in a production environment.

##### `default_ssl_crl`

Sets the path of the default [certificate revocation list][] (CRL) file to use. Default: 'undef'.

While this default value results in a functioning Apache server, you **must** update this parameter with your CRL file's path before deploying this server in a production environment. You can use this parameter with or in place of the [`default_ssl_crl_path`][].

##### `default_ssl_crl_path`

Sets the server's [certificate revocation list path][], which contains your CRLs. Default: 'undef'. 

While this default value results in a functioning Apache server, you **must** update this parameter with the CRL path before deploying this server in a production environment.

##### `default_ssl_crl_check`

Sets the default certificate revocation check level via the [`SSLCARevocationCheck`] directive. Default: 'undef'.

While this default value results in a functioning Apache server, you **must** specify this parameter when using certificate revocation lists in a production environment.

This parameter only applies to Apache 2.4 or higher and is ignored on older versions.

##### `default_ssl_key`

Sets the [SSL certificate key file][] location. Default: Determined by your operating system.

- **Debian**: `/etc/ssl/private/ssl-cert-snakeoil.key`
- **FreeBSD**: `/usr/local/etc/apache22/server.key`
- **Gentoo**: `/etc/ssl/apache2/server.key`
- **Red Hat**: `/etc/pki/tls/private/localhost.key`

While these default values result in a functioning Apache server, you **must** update this parameter with your SSL key's location before deploying this server in a production environment.

##### `default_ssl_vhost`

Configures a default [SSL][SSL encryption] virtual host. Valid options: Boolean. Default: 'false'. 

If 'true', Puppet automatically configures the following virtual host using the [`apache::vhost`][] define:

~~~ puppet
apache::vhost { 'default-ssl':
  port            => 443,
  ssl             => true,
  docroot         => $docroot,
  scriptalias     => $scriptalias,
  serveradmin     => $serveradmin,
  access_log_file => "ssl_${access_log_file}",
  }
~~~

**Note**: SSL virtual hosts only respond to HTTPS queries.

##### `default_type`

_Apache 2.2 only_. Sets the [MIME `content-type`](https://www.iana.org/assignments/media-types/media-types.xhtml) sent if the server cannot otherwise determine an appropriate `content-type`. This directive is deprecated in Apache 2.4 and newer and only exists for backwards compatibility in configuration files. Default: 'undef'.

##### `default_vhost`

Configures a default virtual host when the class is declared. Valid options: Boolean. Default: 'true'. 

To configure [customized virtual hosts][Configuring virtual hosts], set this parameter's value to 'false'.

##### `docroot`

Sets the default [`Documentroot`][] location. Default: Determined by your operating system.

- **Debian**: `/var/www`
- **FreeBSD**: `/usr/local/www/apache22/data`
- **Gentoo**: `/var/www/localhost/htdocs`
- **Red Hat**: `/var/www/html`

##### `error_documents`

Determines whether to enable [custom error documents][] on the Apache server. Valid options: Boolean. Default: 'false'.

##### `group`

Sets the group ID that owns any Apache processes spawned to answer requests. 

By default, Puppet attempts to manage this group as a resource under the `apache` class, determining the group based on the operating system as detected by the [`apache::params`][] class. To to prevent the group resource from being created and use a group created by another Puppet module, set the [`manage_group`][] parameter's value to 'false'.

**Note**: Modifying this parameter only changes the group ID that Apache uses to spawn child processes to access resources. It does not change the user that owns the parent server process.

##### `httpd_dir`

Sets the Apache server's base configuration directory. This is useful for specially repackaged Apache server builds but might have unintended consequences when combined with the default distribution packages. Default: Determined by your operating system.

- **Debian**: `/etc/apache2`
- **FreeBSD**: `/usr/local/etc/apache22`
- **Gentoo**: `/etc/apache2`
- **Red Hat**: `/etc/httpd`

##### `keepalive`

Determines whether to enable persistent HTTP connections with the [`KeepAlive`][] directive. Valid options: 'Off', 'On'. Default: 'Off'.

If 'On', use the [`keepalive_timeout`][] and [`max_keepalive_requests`][] parameters to set relevant options.

##### `keepalive_timeout`

Sets the [`KeepAliveTimeout`] directive, which determines the amount of time the Apache server waits for subsequent requests on a persistent HTTP connection. Default: '15'. 

This parameter is only relevant if the [`keepalive` parameter][] is enabled.

##### `max_keepalive_requests`

Limits the number of requests allowed per connection when the [`keepalive` parameter][] is enabled. Default: '100'.

##### `lib_path`

Specifies the location where [Apache module][] files are stored. Default: Depends on the operating system.

- **Debian** and **Gentoo**: `/usr/lib/apache2/modules`
- **FreeBSD**: `/usr/local/libexec/apache24`
- **Red Hat**: `modules`

[//]: # (Can't tell the absolute path for Red Hat from the code.)

**Note**: Do not configure this parameter manually without special reason.

##### `loadfile_name`

Sets the [`LoadFile`] directive's filename. Valid options: Filenames in the format `\*.load`. 

This can be used to set the module load order.

##### `log_level`

Changes the error log's verbosity. Valid options: 'alert', 'crit', 'debug', 'emerg', 'error', 'info', 'notice', 'warn'. Default: 'warn'.

##### `log_formats`

Define additional [`LogFormat`][] directives. Valid options: A [Hash][], such as:

~~~ puppet
$log_formats = { vhost_common => '%v %h %l %u %t \"%r\" %>s %b' }
~~~

There are a number of predefined `LogFormats` in the `httpd.conf` that Puppet creates:

~~~ httpd
LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%h %l %u %t \"%r\" %>s %b" common
LogFormat "%{Referer}i -> %U" referer
LogFormat "%{User-agent}i" agent
~~~

If your `log_formats` parameter contains one of those, it will be overwritten with **your** definition.

##### `logroot`

Changes the directory of Apache log files for the virtual host. Default: Determined by your operating system.

- **Debian**: `/var/log/apache2`
- **FreeBSD**: `/var/log/apache22`
- **Gentoo**: `/var/log/apache2`
- **Red Hat**: `/var/log/httpd`

##### `logroot_mode`

Overrides the default [`logroot`][] directory's mode. Default: 'undef'. 

**Note**: Do _not_ grant write access to the directory where the logs are stored without being aware of the consequences. See the [Apache documentation][Log security] for details.

##### `manage_group`

When 'false', stops Puppet from creating the group resource. Valid options: Boolean. Default: 'true'. 

If you have a group created from another Puppet module that you want to use to run Apache, set this to 'false'. Without this parameter, attempting to use a previously established group results in a duplicate resource error.

##### `manage_user`

When 'false', stops Puppet from creating the user resource. Valid options: Boolean. Default: 'true'.

This is for instances when you have a user, created from another Puppet module, you want to use to run Apache. Without this parameter, attempting to use a previously established user would result in a duplicate resource error.

##### `mod_dir`

Sets where Puppet places configuration files for your [Apache modules][]. Default: Determined by your operating system.

- **Debian**: `/etc/apache2/mods-available`
- **FreeBSD**: `/usr/local/etc/apache22/Modules`
- **Gentoo**: `/etc/apache2/modules.d`
- **Red Hat**: `/etc/httpd/conf.d`

##### `mpm_module`

Determines which [multi-processing module][] (MPM) is loaded and configured for the HTTPD process. Valid options: 'event', 'itk', 'peruser', 'prefork', 'worker', or 'false'. Default: Determined by your operating system.

- **Debian**: `worker`
- **FreeBSD, Gentoo, and Red Hat**: `prefork`

You must set this to 'false' to explicitly declare the following classes with custom parameters:

- [`apache::mod::event`][]
- [`apache::mod::itk`][]
- [`apache::mod::peruser`][]
- [`apache::mod::prefork`][]
- [`apache::mod::worker`][]

**Note**: Switching between different MPMs on FreeBSD is possible but quite difficult. Before changing `mpm_module`, you must uninstall all packages that depend on your installed Apache server.

##### `package_ensure`

Controls the `package` resource's [`ensure`][] attribute. Valid options: 'absent', 'installed' (or the equivalent 'present'), or a version string. Default: 'installed'.

[//]: # (END COVERAGE)

[//]: # (Cont.)
    
[//]: # (DONE:)
[//]: # (  - Reorganized the Reference section and headers.)
[//]: # (  - Removed old Usage section to separate doc to reflow into reorganized.)
[//]: # (  - Update the link in the Contributing section to point here: https://docs.puppetlabs.com/forge/contributing.html)
[//]: # (    - Was already done!)
[//]: # (  - Standardized all existing lists referring to OS-dependent parameter values.)
[//]: # (  - Updated all Apache docs links from docs/(version number) to docs/current.)
[//]: # (  - Move reference materials in the Usage section to the Reference section.)
[//]: # (  - Consolidate usage materials in the Setup section with the usage materials in the Usage section.)
[//]: # (  - Consistently style all parameter values with minutes instead of backticks.)
[//]: # (IN PROGRESS:)
[//]: # (  - Clean up reorganized Reference section material.)
[//]: # (  - Make a style and proofreading pass on the updated copy.)
[//]: # (  - Check documentation against code and actual use to confirm existing functionality and find undocumented features.)
[//]: # (TO DO:)
[//]: # (  - Clear the Public Classes TO DO.)
[//]: # (  - Fold README.passenger.md into README.me per Morgan.)
[//]: # (  - Proof changes and ensure nothing has been unintentionally removed.)
[//]: # (  - Make sure that for each parameter, where applicable, there is a default value.)
[//]: # (  - Make sure that for each parameter, where applicable, there is a note if the parameter is optional.)
[//]: # (  - Make sure the links in the README work and are accurate.)

##### `ports_file`

Changes the name of the file containing Apache ports configuration. The default value is '`{conf_dir}`/ports.conf'.

##### `purge_configs`

Removes all other Apache configs and virtual hosts. Valid options: Boolean. Default: 'true'. 

Setting this to 'false' is a stopgap measure to allow the apache module to coexist with existing or otherwise-managed configuration. It is recommended that you move your configuration entirely to resources within this module.

##### `purge_vhost_configs`

If the `vhost_dir` parameter's value differs from the `confd_dir` parameter's, the Boolean parameter `purge_vhost_configs` determines whether to remove any configurations inside `vhost_dir` that are _not_ managed by Puppet. The default value is the same as the value of the `purge_configs` parameter. Setting `purge_vhost_configs` to 'false' is a stopgap measure to allow the apache Puppet module to coexist with existing or otherwise unmanaged configurations within `vhost_dir`.

##### `sendfile`

Forces Apache to use the Linux kernel's sendfile to serve static files. The default value is 'On'.

##### `serveradmin`

Sets the Apache server administrator's contact information. The default value is 'root@localhost'.

##### `servername`

Sets the Apache server name. The default value is the value of 'fqdn' provided by [Facter](/facter/latest/).

##### `server_root`

Sets the Apache server software's root directory. The default value is determined by your operating system:

- **Debian**: `/etc/apache2`
- **FreeBSD**: `/usr/local`
- **Gentoo**: `/var/www`
- **Red Hat**: `/etc/httpd`

[//]: # (END COVERAGE)

##### `server_signature`

Configures a trailing footer line under server-generated documents. More information about [ServerSignature](http://httpd.apache.org/docs/current/mod/core.html#serversignature). Defaults to 'On'.

##### `server_tokens`

Controls how much information Apache sends to the browser about itself and the operating system. More information about [ServerTokens](http://httpd.apache.org/docs/current/mod/core.html#servertokens). Defaults to 'OS'.

##### `service_enable`

Determines whether the HTTPD service is enabled when the machine is booted. Defaults to 'true'.

##### `service_ensure`

Determines whether the service should be running. Valid values are 'true', 'false', 'running', or 'stopped' when Puppet should manage the service. Any other value sets ensure to 'false' for the Apache service, which is useful when you want to let the service be managed by some other application like Pacemaker. Defaults to 'running'.

##### `service_name`

Sets the name of the Apache service. The default value is determined by your operating system:

- **Debian and Gentoo**: `apache2`
- **FreeBSD**: `apache22`
- **Red Hat**: `httpd`

##### `service_manage`

Determines whether the HTTPD service state is managed by Puppet. The default value is 'true'.

##### `service_restart`

Determines whether the HTTPD service restart command should be anything other than the default managed by Puppet.  Defaults to undef.

##### `timeout`

Sets the amount of seconds the server will wait for certain events before failing a request. Defaults to 120.

##### `trace_enable`

Controls how TRACE requests per RFC 2616 are handled. More information about [TraceEnable](http://httpd.apache.org/docs/current/mod/core.html#traceenable). Defaults to 'On'.

##### `vhost_dir`

Changes the location of the configuration directory your virtual host configuration files are placed in. The default value is determined by your operating system:

- **Debian**: `/etc/apache2/sites-available`
- **FreeBSD**: `/usr/local/etc/apache22/Vhosts`
- **Gentoo**: `/etc/apache2/vhosts.d`
- **Red Hat**: `etc/httpd/conf.d`

##### `user`

Changes the user that Apache will answer requests as. The parent process will continue to be run as root, but resource accesses by child processes will be done under this user. By default, puppet will attept to manage this user as a resource under `::apache`. If this is not what you want, set [`manage_user`](#manage_user) to 'false'. Defaults to the OS-specific default user for apache, as detected in `::apache::params`.

##### `apache_name`

The name of the Apache package to install. This is automatically detected in `::apache::params`. You might need to override this if you are using a non-standard Apache package, such as those from Red Hat's software collections.

#### Class: `apache::dev`

Installs Apache development libraries.

**Note**: On FreeBSD, you must declare `apache::package` or `apache` before `apache::dev`.

#### Classes: `apache::mod::<MODULE NAME>`

Enables specific Apache HTTP Server modules. The following Apache modules have supported classes that allow for parameterized configuration; other Apache modules can be installed using the [`apache::mod`][] define.

##### Class: `apache::mod::alias`
##### Class: `apache::mod::deflate`
##### Class: `apache::mod::event`
##### Class: `apache::mod::expires`
##### Class: `apache::mod::fcgid`
##### Class: `apache::mod::geoip`
##### Class: `apache::mod::info`
##### Class: `apache::mod::negotiation`
##### Class: `apache::mod::pagespeed`
##### Class: `apache::mod::php`
##### Class: `apache::mod::reqtimeout`
##### Class: `apache::mod::security`
##### Class: `apache::mod::ssl`
##### Class: `apache::mod::status`
##### Class: `apache::mod::version`
##### Class: `apache::mod::wsgi`

### Private Classes

#### Class: `apache::confd::no_accf`

Creates the `no-accf.conf` configuration file in `conf.d`, required by FreeBSD's Apache 2.4.

#### Class: `apache::default_confd_files`

Includes `conf.d` files for FreeBSD.

#### Class: `apache::default_mods`

Installs the Apache modules required to run the default configuration.

#### Class: `apache::package`

Installs and configures basic Apache packages.

#### Class: `apache::params`

Manages Apache parameters.

#### Class: `apache::service`

Manages the Apache daemon.

#### Class: `apache::version`

This class attempts to automatically detect the Apache version based on the operating system.

### Public Defines

[//]: # (START COVERAGE)

#### Define: `apache::balancer`

This define creates an Apache load balancing group, also known as a balancer cluster. Each load balancing group needs one or more balancer members, which are declared in Puppet by the  [`apache::balancermember`][] define.

One `apache::balancer` define should be declared for each Apache load balancing group. The `apache::balancermember` defines for all balancer members can be exported and collected on a single Apache load balancer server using [exported resources](/latest/reference/lang_exported.md).

**Parameters within `apache::balancer`:**

##### `name`

Sets the title of the balancer cluster and name of the `conf.d` file containing its configuration.

##### `proxy_set`

Configures key-value pairs as [ProxySet](http://httpd.apache.org/docs/current/mod/mod_proxy.html#proxyset) lines. It accepts a [hash](/latest/reference/lang_data_hash.html) and defaults to `{}`.

##### `collect_exported`

Determines whether or not to use [exported resources](/latest/reference/lang_exported.md). Valid values are `true` and `false`, and the default value is `true`.

If you statically declare all of your backend servers, set this parameter to `false` to rely on existing, declared balancer member resources. Also, make sure to use `apache::balancermember` with array arguments.

To dynamically declare backend servers via exported resources collected on a central node, set this parameter to `true` to collect the balancer member resources exported by the balancer member nodes.

If you do not use exported resources, a single Puppet run configures all balancer members. If you use exported resources, Puppet has to run on the balanced nodes first, then run on the balancer.

#### Define: `apache::balancermember`

This defines members of [`mod_proxy_balancer`](http://httpd.apache.org/docs/current/mod/mod_proxy_balancer.html), which sets up a balancer member inside a listening service configuration block in `/etc/apache/apache.cfg` on the load balancer.

[//]: # (Do we need to generalize the directory reference here? It might be at /etc/httpd, /etc/apache2...)

**Parameters within `apache::balancermember`:**

##### `balancer_cluster`

This required parameter sets the Apache service's instance name and must match the name of a declared `apache::balancer` resource.

##### `url`

Specifies the URL used to contact the balancer member server. The default value is 'http://${::fqdn}/'.

##### `options`

This array of [options](http://httpd.apache.org/docs/current/mod/mod_proxy.html#balancermember) is specified after the URL and accepts any key-value pairs available to [ProxyPass](http://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass).

[//]: # (NEEDS DEFAULTS)

#### Define: `apache::custom_config`

This define allows you to add a custom configuration file to the Apache server. The file is only added to the Apache `conf.d` directory if it is valid; a Puppet run raises an error if the file is invalid and the define's `$verify_config` parameter is `true`.

**Parameters within `apache::custom_config`:**

##### `ensure`

Specifies whether the configuration file should be present. The default value is `present`, and valid values are `present` and `absent`.

##### `confdir`

Sets the directory in which Puppet places the configuration files. The default value is `$::apache::confd_dir`.

##### `content`

Sets the content of the configuration file. The `$content` and [`$source`]($source) parameters are exclusive of each other.

##### `priority`

Sets the priority of the configuration file by prefixing its filename with this number. Apache uses this prefix to determine the order in which it applies configuration files. The default value is `25`.

To omit the priority prefix in the configuration file's name, pass the `false` value to this parameter.

##### `source`

Points to the configuration file's source. The [`$content`](#content) and `$source` parameters are exclusive of each other.

##### `verify_command`

Specifies the command to use to verify the configuration file. It should use a fully qualified command. The default command is `/usr/sbin/apachectl -t`. 

The `$verify_command` parameter is only used if `$verify_config` is `true`. If the `$verify_command` fails, the configuration file is deleted, the Apache service is not notified, and the Puppet run raises an error.

##### `verify_config`

This Boolean parameter specifies whether the configuration file should be validated before the Apache service is notified. The default value is `true`.

#### Define: `apache::fastcgi::server`

Designed for use with `mod_fastcgi`, `apache::fastcgi::server` defines one or more external FastCGI servers to handle specific file types.

**Parameters within `apache::fastcgi::server`:**

##### `host`

Determines the hostname or IP address and TCP port number (1-65535) of the FastCGI server.

##### `timeout`

Sets the number of seconds of FastCGI application inactivity allowed before aborting the request and logging the event at the error LogLevel. The inactivity timer applies only as long as a connection is pending with the FastCGI application. If a request is queued to an application, but the application doesn't respond by writing and flushing within this period, the request is aborted. If communication is complete with the application but incomplete with the client (the response is buffered), the timeout does not apply.

##### `flush`

Forces `mod_fastcgi` to write to the client as data is received from the application. By default, `mod_fastcgi` buffers data in order to free the application as quickly as possible.

##### `faux_path`

URIs that Apache resolves to this filename are handled by this external FastCGI application. The path set in this parameter does not have to exist in the local filesystem. 

##### `alias`

This unique alias is used internally to link actions with the FastCGI server.

##### `file_type`

Sets the MIME type of the file to be processed by the FastCGI server.

#### Define: `apache::listen`

Adds [Listen](http://httpd.apache.org/docs/current/bind.html) directives to `ports.conf` in the Apache configuration directory that define the Apache server's or a virtual host's listening address and port. The [`apache::vhost`](#class-apache-vhost) class uses this define, and titles take the form '<port>', '<ipv4>:<port>', or '<ipv6>:<port>'.

#### Define: `apache::mod`

Attempts to install packages for Apache modules that do not have a corresponding [`apache::mod::<MODULE NAME>`][] class. If it can, `apache::mod` also checks for or places default configuration files for those modules in the Apache server's `module` and `enable` directories; the precise locations are specific to your operating system.

##### `package`

**Required**. The package Puppet will use to install the module.

##### `package_ensure`

_Optional_. You can have Puppet ensure whether a module should be installed by changing this parameter. Its default value is 'present', and its valid values are 'absent' and 'present'.

##### `lib`

_Optional_. Defines the module's shared object name. Its default value is `mod_$name.so`, and it should not be configured manually without special reason.

##### `lib_path`

_Optional_. Specifies a path to the module's libraries. Its default value is the [`apache`][] class's `lib_path` parameter, shouldn't be configured manually without special reason, and can be overridden by [`path`][].

##### `loadfile_name`

_Optional_. Sets the filename for the module's [`LoadFile`][] directive. Its default value is `$name.load`, and and custom value should use the format `\*.load`. This can be used to set the module load order.

##### `loadfiles`

_Optional_. Specifies an [array][] of [`LoadFile`][] directives.

##### `path`

_Optional_. Specifies a path to the module. Its default value is `$[lib_path][`lib_path`]/$[lib][`lib`]` and shouldn't be configured manually without special reason.

[//]: # (END COVERAGE)

#### Define: `apache::namevirtualhost`

Enables name-based hosting of a virtual host. Adds all [NameVirtualHost](http://httpd.apache.org/docs/current/vhosts/name-based.html) directives to the `ports.conf` file in the Apache HTTPD configuration directory. Titles take the form '\*', '*:<port>', '\_default_:<port>, '<ip>', or '<ip>:<port>'.

#### Define: `apache::vhost`

Allows specialized configurations for virtual hosts that have requirements outside the defaults.

##### Parameters: `directories`

##### Parameters: `ssl`

### Private Defines

#### Define: `apache::peruser::multiplexer`

This define checks if an Apache module has a class. If it does, it includes that class. If it does not, it passes the module name to the [`apache::mod`][] define.

#### Define: `apache::peruser::multiplexer`

Enables the [`Peruser`][] module for FreeBSD only.

#### Define: `apache::peruser::processor`

Enables the [`Peruser`][] module for FreeBSD only.

#### Define: `apache::security::file_link`

Links the `activated_rules` from [`apache::mod::security`][] to the respective CRS rules on disk.

### Templates

The Apache module relies heavily on templates to enable the [`apache::vhost`][] and [`apache::mod`][] defines. These templates are built based on [Facter][] facts specific to your operating system. Unless explicitly called out, most templates are not meant for configuration.

## Limitations

### Ubuntu 10.04

The [`apache::vhost::WSGIImportScript`][] parameter creates a statement inside the virtual host that is unsupported on older versions of Apache, causing it to fail. This will be remedied in a future refactoring.

[//]: # (Has this been resolved? Is there a bug or issue to track?)

### RHEL/CentOS 5

The [`apache::mod::passenger`][] and [`apache::mod::proxy_html`][] classes are untested since repositories are missing compatible packages.

### RHEL/CentOS 7

The [`apache::mod::passenger`][] class is untested as the EL7 repository is missing compatible packages, which also blocks us from testing the [`apache::vhost`][] define's [`rack_base_uri`][] parameter.

### General

This module is CI tested against both [open source Puppet][] and [Puppet Enterprise][] on:

- CentOS 5 and 6
- Ubuntu 12.04 and 14.04
- Debian 7
- RHEL 5, 6, and 7

This module also provides functions for other distributions and operating systems, such as FreeBSD, Gentoo, and Amazon Linux, but is not formally tested on them and are subject to regressions.

### SELinux and custom paths

If [SELinux][] is in [enforcing mode][] and you want to use custom paths for `logroot`, `mod_dir`, `vhost_dir`, and `docroot`, you need to manage the files' context yourself.

You can do this with Puppet:

~~~ puppet
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
~~~

You need to set the contexts using `semanage fcontext` instead of `chcon` because Puppet's `file` resources reset the values' context in the database if the resource doesn't specify it.

### FreeBSD

In order to use this module on FreeBSD, you _must_ use apache24-2.4.12 (www/apache24) or newer.

## Development

### Contributing

[Puppet Labs][] modules on the [Puppet Forge][] are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve.

We want to make it as easy as possible to contribute changes so our modules work in your environment, but we also need contributors to follow a few guidelines to help us maintain and improve the modules' quality.

For more information, please read the complete [module contribution guide][].

### Running tests

This project contains tests for both [rspec-puppet][] and [beaker-rspec][] to verify functionality. For detailed information on using these tools, please see their respective documentation.

#### Testing quickstart: Ruby > 1.8.7

~~~
gem install bundler
bundle install
bundle exec rake spec
bundle exec rspec spec/acceptance
RS_DEBUG=yes bundle exec rspec spec/acceptance
~~~

#### Testing quickstart: Ruby = 1.8.7

~~~
gem install bundler
bundle install --without system_tests
bundle exec rake spec
~~~
