# apache
[//]: # (START COVERAGE)
#### Table of Contents

1. [Module description - What is the apache module, and what does it do?](#module-description)
2. [Setup - The basics of getting started with apache](#setup)
    * [Beginning with Apache - Installation](#beginning-with-apache)
3. [Usage - The classes and defined types available for configuration](#usage)
    * [Configuring virtual hosts - Examples to help get started](#configuring-virtual-hosts)
    * [Configuring FastCGI servers to handle PHP files](#configuring-fastcgi-servers-to-handle-php-files)
    * [Load balancing with exported and non-exported resources](#load-balancing-examples)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Public Classes](#public-classes)
    * [Private Classes](#private-classes)
    * [Public Defines](#public-defines)
    * [Private Defines](#private-defines)
    * [Templates](#templates)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Contributing to the apache module](#contributing)
    * [Running tests - A quick guide](#running-tests)

## Module description

Apache HTTP Server (also called Apache HTTPD, or simply Apache) is a widely used web server. This Puppet module simplifies the task of creating configurations to manage Apache servers in your infrastructure. It includes the ability to configure and manage a range of virtual host setups, as well as a streamlined way to install and configure Apache modules.

## Setup

**What the apache Puppet module affects:**

* Configuration files and directories (created and written to)
    * **WARNING**: Configurations *not* managed by Puppet will be purged.
* Package/service/configuration files for Apache
* Apache modules
* Virtual hosts
* Listened-to ports
* `/etc/make.conf` on FreeBSD and Gentoo

On Gentoo, this module depends on the [`gentoo/puppet-portage`](https://github.com/gentoo/puppet-portage) Puppet module. Note that while several options apply or enable certain features and settings for Gentoo, it is not a [supported operating system](https://forge.puppetlabs.com/supported#puppet-supported-modules-compatibility-matrix) for this module.

*Note:* This module modifies Apache configuration files and directories and purges any configuration not managed by Puppet. Configuration of Apache should be managed by Puppet, as non-Puppet configuration files can cause unexpected failures.

To temporarily disable full Puppet management, set the `purge_configs` parameter in the `apache` class declaration to `false`. We recommend using this only as a temporary means of saving and relocating customized configurations. See the [`purge_configs`](#purge_configs) parameter for more information.

### Beginning with Apache

To install Apache with the default parameters, use this Puppet code:

~~~ puppet
    class { 'apache':  }
~~~

The Puppet module applies a default configuration based on your operating system. For example, Debian, Red Hat, FreeBSD, and Gentoo systems each have unique default configurations. These defaults work in testing environments but are not suggested for production; Puppet recommends customizing parameters to suit your site. Use the [Reference](#reference) section to find default parameter values.

You can customize parameters when declaring the `apache` class. For instance, this declaration installs Apache without the apache module's [default virtual host configuration](#configuring-a-virtual-host), allowing you to customize all Apache virtual hosts:

~~~ puppet
    class { 'apache':
      default_vhosts => false,
    }
~~~

## Usage

### Configuring a virtual host

The default `apache` class sets up a virtual host on port 80, listening on all interfaces and serving the default `$apache::docroot`.

*Note:* See the [`apache::vhost`](#define-apachevhost) define reference for a list of all virtual host parameters.

To configure a basic name-based virtual host, specify the `port` and `docroot` using the `apache::vhost` define:

~~~ puppet
    apache::vhost { 'vhost.example.com':
      port    => '80',
      docroot => '/var/www/vhost',
    }
~~~

*Note:* Apache processes virtual hosts in alphabetical order, and server administrators can prioritize Apache's virtual host processing by prefixing the virtual host's file name with a numeric priority. The `apache::vhost` define applies a default `[priority](#defines-apachevhost)` of 15. In Apache's terms, Puppet prefixes the virtual host's file name with `15-`. If multiple sites have the same priority, or if you disable priority numbers by setting the `priority` parameter to `false`, Apache processes those virtual hosts in alphabetical order.

To configure user and group ownership for `docroot`, use the `[docroot_owner](#docroot_owner)` and `[docroot_group](#docroot_group)` parameters:

~~~ puppet
    apache::vhost { 'user.example.com':
      port          => '80',
      docroot       => '/var/www/user',
      docroot_owner => 'www-data',
      docroot_group => 'www-data',
    }
~~~

#### Configuring virtual hosts with SSL

To configure a virtual host to use SSL and default SSL certificates, use the `[ssl](#ssl)` parameter and set the `[port](#port)` parameter appropriately:

~~~ puppet
    apache::vhost { 'ssl.example.com':
      port    => '443',
      docroot => '/var/www/ssl',
      ssl     => true,
    }
~~~

To configure a virtual host with SSL and specific SSL certificates, use the paths to the certificate and key in the `[ssl_cert](#ssl_cert)` and `[ssl_key](#ssl_key)` parameters, respectively:

~~~ puppet
    apache::vhost { 'cert.example.com':
      port     => '443',
      docroot  => '/var/www/cert',
      ssl      => true,
      ssl_cert => '/etc/ssl/fourth.example.com.cert',
      ssl_key  => '/etc/ssl/fourth.example.com.key',
    }
~~~

To configure a mix of SSL and non-SSL virtual hosts at the same domain:

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

To configure a virtual host to redirect non-SSL connections to SSL:

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

Virtual hosts listen on all IP addresses ('*') by default. To configure the virtual host to listen on a specific IP address, use the `[ip](#ip)` parameter:

~~~ puppet
    apache::vhost { 'ip.example.com':
      ip      => '127.0.0.1',
      port    => '80',
      docroot => '/var/www/ip',
    }
~~~

To configure a virtual host with aliased servers:

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

To set up a virtual host with a wildcard alias for the subdomain mapped to a same-named directory, such as `http://example.com.loc` mapped to `/var/www/example.com`, define the wildcard alias using the `[serveraliases](#serveraliases)` parameter and the docroot with the `[virtual_docroot](#virtual_docroot)` parameter:

~~~ puppet
    apache::vhost { 'subdomain.loc':
      vhost_name      => '*',
      port            => '80',
      virtual_docroot => '/var/www/%-2+',
      docroot         => '/var/www',
      serveraliases   => ['*.loc',],
    }
~~~

To configure a virtual host with [filter rules](http://httpd.apache.org/docs/2.2/filter.html), pass the filter directives as an array using the `[filters](#filters)` parameter:

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

To set up a virtual host with [suPHP](http://www.suphp.org/Home.html), use the `[suphp_engine](#suphp_engine)` parameter to enable the suPHP engine, `[suphp_addhandler](#suphp_addhandler)` parameter to define a MIME type, `[suphp_configpath](#suphp_configpath)` to set which path suPHP passes to the PHP interpreter, and the `[directory](#directory)` parameter to configure Directory, File, and Location directive blocks:

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

You can use a set of parameters to configure a virtual host to use the [Web Server Gateway Interface (WSGI)](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface) for Python applications:

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

Starting in Apache 2.2.16, HTTPD supports [FallbackResource](https://httpd.apache.org/docs/current/mod/mod_dir.html#fallbackresource), a simple replacement for common RewriteRules. You can set a FallbackResource using the `[fallbackresource](#fallbackresource)` parameter:

~~~ puppet
    apache::vhost { 'wordpress.example.com':
      port             => '80',
      docroot          => '/var/www/wordpress',
      fallbackresource => '/index.php',
    }
~~~

**Note:** The `disabled` argument to `FallbackResource` is only supported since Apache 2.2.24.

To configure a virtual host with a designated directory for [common gateway interface](http://httpd.apache.org/docs/2.4/howto/cgi.html) (CGI) files:

~~~ puppet
    apache::vhost { 'twelfth.example.com':
      port        => '80',
      docroot     => '/var/www/twelfth',
      scriptalias => '/usr/lib/cgi-bin',
    }
~~~

To configure a virtual host for [Rack](http://rack.github.io/):

~~~ puppet
    apache::vhost { 'rack.example.com':
      port           => '80',
      docroot        => '/var/www/rack',
      rack_base_uris => ['/rackapp1', '/rackapp2'],
    }
~~~

#### Configuring IP-based virtual hosts

You can configure [IP-based virtual hosts](http://httpd.apache.org/docs/2.2/vhosts/ip-based.html) to listen on any port and have them respond to requests on specific IP addresses. In this example, we set the server to listen on ports 80 and 81 because the example virtual hosts are not declared with a [`port`](#port) parameter:

~~~ puppet
    apache::listen { '80': }
    apache::listen { '81': }
~~~

Then we configure the IP-based virtual hosts:

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

You can also configure a mix of IP- and name-based virtual hosts, in a mix of SSL and non-SSL configurations. First, we add two IP-based vhosts on 10.0.0.10, one SSL and one non-SSL:

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

Then, we add two name-based virtual hosts listening on 10.0.0.20:

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

To add name-based virtual hosts that answer on either 10.0.0.10 or 10.0.0.20, you **must** set the `add_listen` parameter to `false` to disable the default Apache setting of `Listen 80`, as it conflicts with the preceding IP-based virtual hosts.

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

### Configuring FastCGI servers to handle PHP files

Add the [`apache::fastcgi::server`](#define-apache-fastcgi-server) define to allow FastCGI servers to handle requests for specific files. For example, the following defines a FastCGI server at `127.0.0.1` (localhost) on port 9000 to handle PHP requests:

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

Within your virtual host, you can then configure the specified file type to be handled by the fastcgi server specified above.

~~~ puppet
apache::vhost { 'www':
  ...
  custom_fragment => 'AddType application/x-httpd-php .php'
  ...
}
~~~

### Load balancing examples

To load balance with [exported resources](/guides/exported_resources.md), export the `balancermember` from the balancer member.

~~~ puppet
      @@apache::balancermember { "${::fqdn}-puppet00":
        balancer_cluster => 'puppet00',
        url              => "ajp://${::fqdn}:8009"
        options          => ['ping=5', 'disablereuse=on', 'retry=5', 'ttl=120'],
      }
~~~

Then, on the proxy server, create the balancer cluster

~~~ puppet
      apache::balancer { 'puppet00': }
~~~

To load balance without exported resources, declare the following on the proxy

~~~ puppet
    apache::balancer { 'puppet00': }
    apache::balancermember { "${::fqdn}-puppet00":
        balancer_cluster => 'puppet00',
        url              => "ajp://${::fqdn}:8009"
        options          => ['ping=5', 'disablereuse=on', 'retry=5', 'ttl=120'],
      }
~~~

Then declare `apache::balancer` and `apache::balancermember` on the proxy server.

If you need to use ProxySet in the balancer config

~~~ puppet
      apache::balancer { 'puppet01':
        proxy_set => {'stickysession' => 'JSESSIONID'},
      }
~~~

## Reference

* [**Public Classes**](#public-classes)
    * [Class: apache](#class-apache)
    * [Class: apache::dev](#class-apachedev)
    * [Classes: apache::mod::*](#classes-apachemodname)
* [**Private Classes**](#private-classes)
    * [Class: apache::confd::no_accf](#class-apacheconfdno_accf)
    * [Class: apache::default_confd_files](#class-apachedefault_confd_files)
    * [Class: apache::default_mods](#class-apachedefault_mods)
    * [Class: apache::package](#class-apachepackage)
    * [Class: apache::params](#class-apacheparams)
    * [Class: apache::service](#class-apacheservice)
* [**Public Defines**](#public-defines)
    * [Define: apache::balancer](#define-apachebalancer)
    * [Define: apache::balancermember](#define-apachebalancermember)
    * [Define: apache::custom_config](#define-apachecustom_config)
    * [Define: apache::fastcgi::server](#define-fastcgi-server)
    * [Define: apache::listen](#define-apachelisten)
    * [Define: apache::mod](#define-apachemod)
    * [Define: apache::namevirtualhost](#define-apachenamevirtualhost)
    * [Define: apache:vhost](#define-apachevhost)
* [**Private Defines**](#private-defines)
    * [Define: apache::default_mods::load](#define-default_mods-load)
    * [Define: apache::peruser::multiplexer](#define-apacheperusermultiplexer)
    * [Define: apache::peruser::processor](#define-apacheperuserprocessor)
    * [Define: apache::security::file_link](#define-apachesecurityfile_link)
* [**Templates**](#templates)

### Public Classes

[//]: # (TODO:)
[//]: # (  - Define public classes here.)
[//]: # (  - Alphabetize and/or reorder classes.)
[//]: # (  - Confirm all classes listed are in the section TOC.)

#### Class: `apache`

This public class guides the basic setup and installation of Apache on your system. 
[//]: # (What does it do? Should we detail that here?)

When this class is declared with the default options, Puppet:

* Installs the appropriate Apache software package and [required Apache modules](#default_mods) for your operating system.
* Places the required configuration files in a directory, with the [default location](#conf_dir) determined by your operating system.
* Configures the server with a default virtual host and standard port (80) and address (`*`) bindings.
* Creates a document root directory determined by your operating system, typically `/var/www`.
* Starts the Apache service.

To declare the default apache class:

~~~ puppet
    class { 'apache': }
~~~

You can establish a default virtual host in this class, by using the `vhost` define, or both. You can also add additional configurations for specific virtual hosts with the `vhost` define.

We recommend customizing this class's declaration with the following parameters, as its default settings are not optimized for production.

**Parameters within `apache`:**

##### `allow_encoded_slashes`

This parameter sets the server default for the [`AllowEncodedSlashes` declaration](http://httpd.apache.org/docs/current/mod/core.html#allowencodedslashes), which modifies the responses to URLs containing `\` and `/` characters. The default is `undef`, which omits the declaration from the server's configuration and uses Apache's default setting of `off`. The allowed values are `on`, `off`, or `nodecode`.

##### `apache_version`

This parameter configures module template behavior, package names, and default Apache modules by defining the version of Apache to use. The default version is determined by the OS family and release via the `apache::version` class, and Puppet recommends against manually configuring this parameter without reason.

##### `conf_dir`

This parameter sets the directory where the Apache server's main configuration file is located. The default locations include:

* **Debian**: `/etc/apache2`
* **FreeBSD**: `/usr/local/etc/apache22`
* **Gentoo**: `/etc/apache2`
* **Red Hat**: `/etc/httpd/conf`

##### `confd_dir`

This parameter sets the location of the Apache server's custom configuration directory. The default locations include:

* `/etc/apache2/conf.d` on Debian
* `/usr/local/etc/apache22` on FreeBSD
* `/etc/apache2/conf.d` on Gentoo
* `/etc/httpd/conf` on Red Hat

##### `conf_template`

You can use this parameter to define the [template](/guides/templating.md) used for the main Apache configuration file. The default value is `apache/httpd.conf.erb`. 

[//]: # (Is this correct? It's at `template/httpd.conf.erb` in the module; are there weird path modifications happening?)

*Note:* Modifying this parameter is potentially risky, as the apache Puppet module is designed to use a minimal configuration file customized by `conf.d/` entries.

##### `default_charset`

If defined, this parameter's value will be used as the `AddDefaultCharset` in the main configuration file. Its value is undefined by default.

##### `default_confd_files`

This Boolean parameter determines whether Puppet generates a default set of includable Apache configuration files in the `${apache::confd_dir}` directory. These configuration files correspond to what is usually installed with the Apache package on the operating system. This parameter's default value is `true`.

##### `default_mods`

This parameter determines whether to configure and enable a set of default Apache modules depending on your operating system. Valid values are `true`, `false`, or an array of Apache module names. The default value is `true`, which includes the default [HTTPD mods](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/default_mods.pp).

If this parameter is `false`, Puppet only includes the Apache modules required to make the HTTP daemon work, and any other mods can be declared on their own. 

If `false`, the minimum default Apache modules installed for the following operating systems are:

* **Red Hat**: `log_config`; if [`apache_version`](#apache_version) is greater than 2.4, `unixd` and, except on RHEL/CentOS 6 SCL, `systemd`
* **FreeBSD**: `log_config`, `unixd`
* **Suse**: `log_config`
* **Gentoo**: No default modules 
* **All other operating systems**: `authz_host`

[//]: # (Gentoo really doesn't apply any default modules?)

If `true`, these additional modules are installed accordingly:

* **Debian**: `authn_core`, `reqtimeout`
* **Red Hat**: `actions`, `authn_core`, `cache`, `mime`, `mime_magic`, `rewrite`, `speling`, `suexec`, `version`, `vhost_alias`, `auth_digest`, `authn_anon`, `authn_dbm`, `authz_dbm`, `authz_owner`, `expires`, `ext_filter`, `include`, `logio`, `substitute`, and `usertrack`; if the Apache version is less than 2.4, it also installs `authn_alias` and `authn_default`.
* **FreeBSD**: `actions`, `asis`, `auth_digest`, `auth_form`, `authn_anon`, `authn_core`, `authn_dbm`, `authn_socache`, `authz_dbd`, `authz_dbm`, `authz_owner`, `cache`, `disk_cache`, `dumpio`, `expires`, `file_cache`, `filter`, `headers`, `imagemap`, `include`, `info`, `logio`, `mime_magic`, `reqtimeout`, `request`, `rewrite`, `session`, `speling`, `unique_id`, `userdir`, `version`, and `vhost_alias`
* **All operating systems**: `alias`, `authn_file`, `autoindex`, `dav`, `dav_fs`, `deflate`, `dir`, `mime`, `negotiation`, `setenvif`, and `auth_basic`.
  * If the Apache version is at least 2.4, it also installs ``filter`, `authz_core`, and `access_compat`
  * If the Apache version is less than 2.4, it also installs `authz_default`.

If the `prefork` MPM module is installed and this parameter's value is `true`, it also includes `::apache::mod::cgi`. If the `worker` MPM module is installed, it includes `::apache::mod::cgid`.

If this parameter contains an array, the apache Puppet module enables all Apache modules in the array.

##### `default_ssl_ca`

This parameter sets the default certificate authority for the Apache server. The default value is `undef`; while this default value results in a functioning Apache server, you *must* update this parameter with your certificate authority before deploying this server in a production environment.

##### `default_ssl_cert`

This parameter sets the SSL certificate location. The default value is determined by your operating system:

* **Debian**: `/etc/ssl/certs/ssl-cert-snakeoil.pem`
* **FreeBSD**: `/usr/local/etc/apache22/server.crt`
* **Gentoo*: `/etc/ssl/apache2/server.crt`
* **Red Hat**: `/etc/pki/tls/certs/localhost.crt`

While the default value results in a functioning Apache server, you *must* update this parameter with your certificate location before deploying this server in a production environment.

##### `default_ssl_chain`

This parameter sets the SSL chain. The default value is `undef`; while this default value results in a functioning Apache server, you *must* update this parameter with your SSL chain before deploying this server in a production environment.

##### `default_ssl_crl`

This parameter sets the name of the server's SSL certificate revocation list (CRL). The default value is `undef`; while this default value results in a functioning Apache server, you *must* update this parameter with your CRL's name before deploying this server in a production environment.

##### `default_ssl_crl_path`

This parameter sets the path to the server's SSL certificate revocation list (CRL). The default value is `undef`; while this default value results in a functioning Apache server, you *must* update this parameter with your CRL's location before deploying this server in a production environment.

##### `default_ssl_crl_check`

This parameter sets the default certificate revocation check level via the [SSLCARevocationCheck directive](http://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcarevocationcheck). The default value is `undef`; while this default value results in a functioning Apache server, you *must* specify this parameter when using certificate revocation lists in a production environment.

This parameter only applies to Apache 2.4 or higher and is ignored on older versions.

##### `default_ssl_key`

This parameter sets the SSL key location. The default value is determined by your operating system:

* **Debian**: `/etc/ssl/private/ssl-cert-snakeoil.key`
* **FreeBSD**: `/usr/local/etc/apache22/server.key`
* **Gentoo**: `/etc/ssl/apache2/server.key`
* **Red Hat**: `/etc/pki/tls/private/localhost.key`

While these default values result in a functioning Apache server, you *must* update this parameter with your SSL key's location before deploying this server in a production environment.

##### `default_ssl_vhost`

This Boolean parameter configures a default SSL virtual host. The default value is `false`. 

If set to `true`, Puppet configures the following virtual host using the [`apache::vhost`](#define-apache-vhost) define:

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

**Note:** SSL virtual hosts only respond to HTTPS queries.

##### `default_type`

On Apache 2.2 only, this parameter sets the MIME `content-type` sent if the server cannot otherwise determine an appropriate `content-type`. This directive is deprecated in Apache 2.4 and newer and only exists for backwards compatibility in configuration files. The default value is `undef`.

##### `default_vhost`

This Boolean parameter configures a default virtual host when the class is declared. The default value is `true`. To configure [customized virtual hosts](#configuring-a-virtual-host), set this parameter to `false`.

[//]: # (END COVERAGE)

[//]: # (Cont.)
    
[//]: # (DID:)
[//]: # (  - Reorganized the Reference section and headers.)
[//]: # (  - Removed old Usage section to separate doc to reflow into reorganized.)
[//]: # (  - Reference and Usage sections.)
[//]: # (IN PROGRESS:)
[//]: # (  - Clean up reorganized Reference section material.)
[//]: # (TO DO:)
[//]: # (  - Move reference materials in the Usage section to the Reference section.)
[//]: # (  - Consolidate usage materials in the Setup section with the usage materials in the Usage section.)

##### `docroot`

Changes the location of the default [Documentroot](https://httpd.apache.org/docs/current/mod/core.html#documentroot). Defaults to '/var/www/html' on RedHat, '/var/www' on Debian, '/usr/local/www/apache22/data' on FreeBSD, and '/var/www/localhost/htdocs' on Gentoo.

##### `error_documents`

Enables custom error documents. Defaults to 'false'.

##### `group`

Changes the group that Apache will answer requests as. The parent process will continue to be run as root, but resource accesses by child processes will be done under this group. By default, puppet will attempt to manage this group as a resource under `::apache`. If this is not what you want, set [`manage_group`](#manage_group) to 'false'. Defaults to the OS-specific default user for apache, as detected in `::apache::params`.

##### `httpd_dir`

Changes the base location of the configuration directories used for the apache service. This is useful for specially repackaged HTTPD builds, but might have unintended consequences when used in combination with the default distribution packages. Defaults to '/etc/httpd' on RedHat, '/etc/apache2' on Debian, '/usr/local/etc/apache22' on FreeBSD, and '/etc/apache2' on Gentoo.

##### `keepalive`

Enables persistent connections.

##### `keepalive_timeout`

Sets the amount of time the server waits for subsequent requests on a persistent connection. Defaults to '15'.

##### `max_keepalive_requests`

Sets the limit of the number of requests allowed per connection when KeepAlive is on. Defaults to '100'.

##### `lib_path`

Specifies the location where apache module files are stored. It should not be configured manually without special reason.

##### `loadfile_name`

Sets the filename for the module loadfile. Should be in the format \*.load.  This can be used to set the module load order.

##### `log_level`

Changes the verbosity level of the error log. Defaults to 'warn'. Valid values are 'emerg', 'alert', 'crit', 'error', 'warn', 'notice', 'info', or 'debug'.

##### `log_formats`

Define additional [LogFormats](https://httpd.apache.org/docs/current/mod/mod_log_config.html#logformat). This is done in a Hash:

~~~ puppet
  $log_formats = { vhost_common => '%v %h %l %u %t \"%r\" %>s %b' }
~~~

There are a number of predefined LogFormats in the httpd.conf that Puppet writes out:

~~~ httpd
LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%h %l %u %t \"%r\" %>s %b" common
LogFormat "%{Referer}i -> %U" referer
LogFormat "%{User-agent}i" agent
~~~

If your `$log_formats` contains one of those, they will be overwritten with **your** definition.

##### `logroot`

Changes the directory where Apache log files for the virtual host are placed. Defaults to '/var/log/httpd' on RedHat, '/var/log/apache2' on Debian, '/var/log/apache22' on FreeBSD, and '/var/log/apache2' on Gentoo.

##### `logroot_mode`

Overrides the mode the default logroot directory is set to ($::apache::logroot). Defaults to undef. Do NOT give people write access to the directory the logs are stored
in without being aware of the consequences; see http://httpd.apache.org/docs/2.4/logs.html#security for details.

##### `manage_group`

Setting this to 'false' stops the group resource from being created. This is for when you have a group, created from another Puppet module, you want to use to run Apache. Without this parameter, attempting to use a previously established group would result in a duplicate resource error.

##### `manage_user`

Setting this to 'false' stops the user resource from being created. This is for instances when you have a user, created from another Puppet module, you want to use to run Apache. Without this parameter, attempting to use a previously established user would result in a duplicate resource error.

##### `mod_dir`

Changes the location of the configuration directory your Apache modules configuration files are placed in. Defaults to '/etc/httpd/conf.d' for RedHat, '/etc/apache2/mods-available' for Debian, '/usr/local/etc/apache22/Modules' for FreeBSD, and '/etc/apache2/modules.d' on Gentoo.

##### `mpm_module`

Determines which MPM is loaded and configured for the HTTPD process. Valid values are 'event', 'itk', 'peruser', 'prefork', 'worker', or 'false'. Defaults to 'prefork' on RedHat, FreeBSD and Gentoo, and 'worker' on Debian. Must be set to 'false' to explicitly declare the following classes with custom parameters:

* `apache::mod::event`
* `apache::mod::itk`
* `apache::mod::peruser`
* `apache::mod::prefork`
* `apache::mod::worker`

*Note:* Switching between different MPMs on FreeBSD is possible but quite difficult. Before changing `$mpm_module` you must uninstall all packages that depend on your currently-installed Apache.

##### `package_ensure`

Allows control over the package ensure attribute. Can be 'present','absent', or a version string.

##### `ports_file`

Changes the name of the file containing Apache ports configuration. Default is `${conf_dir}/ports.conf`.

##### `purge_configs`

Removes all other Apache configs and vhosts, defaults to 'true'. Setting this to 'false' is a stopgap measure to allow the apache module to coexist with existing or otherwise-managed configuration. It is recommended that you move your configuration entirely to resources within this module.

##### `purge_vhost_configs`

If `vhost_dir` != `confd_dir`, this controls the removal of any configurations that are not managed by Puppet within `vhost_dir`. It defaults to the value of `purge_configs`. Setting this to false is a stopgap measure to allow the apache module to coexist with existing or otherwise unmanaged configurations within `vhost_dir`

##### `sendfile`

Makes Apache use the Linux kernel sendfile to serve static files. Defaults to 'On'.

##### `serveradmin`

Sets the server administrator. Defaults to 'root@localhost'.

##### `servername`

Sets the server name. Defaults to `fqdn` provided by Facter.

##### `server_root`

Sets the root directory in which the server resides. Defaults to '/etc/httpd' on RedHat, '/etc/apache2' on Debian, '/usr/local' on FreeBSD, and '/var/www' on Gentoo.

##### `server_signature`

Configures a trailing footer line under server-generated documents. More information about [ServerSignature](http://httpd.apache.org/docs/current/mod/core.html#serversignature). Defaults to 'On'.

##### `server_tokens`

Controls how much information Apache sends to the browser about itself and the operating system. More information about [ServerTokens](http://httpd.apache.org/docs/current/mod/core.html#servertokens). Defaults to 'OS'.

##### `service_enable`

Determines whether the HTTPD service is enabled when the machine is booted. Defaults to 'true'.

##### `service_ensure`

Determines whether the service should be running. Valid values are 'true', 'false', 'running', or 'stopped' when Puppet should manage the service. Any other value sets ensure to 'false' for the Apache service, which is useful when you want to let the service be managed by some other application like Pacemaker. Defaults to 'running'.

##### `service_name`

Name of the Apache service to run. Defaults to: 'httpd' on RedHat, 'apache2' on Debian and Gentoo, and 'apache22' on FreeBSD.

##### `service_manage`

Determines whether the HTTPD service state is managed by Puppet . Defaults to 'true'.

##### `service_restart`

Determines whether the HTTPD service restart command should be anything other than the default managed by Puppet.  Defaults to undef.

##### `timeout`

Sets the amount of seconds the server will wait for certain events before failing a request. Defaults to 120.

##### `trace_enable`

Controls how TRACE requests per RFC 2616 are handled. More information about [TraceEnable](http://httpd.apache.org/docs/current/mod/core.html#traceenable). Defaults to 'On'.

##### `vhost_dir`

Changes the location of the configuration directory your virtual host configuration files are placed in. Defaults to 'etc/httpd/conf.d' on RedHat, '/etc/apache2/sites-available' on Debian, '/usr/local/etc/apache22/Vhosts' on FreeBSD, and '/etc/apache2/vhosts.d' on Gentoo.

##### `user`

Changes the user that Apache will answer requests as. The parent process will continue to be run as root, but resource accesses by child processes will be done under this user. By default, puppet will attept to manage this user as a resource under `::apache`. If this is not what you want, set [`manage_user`](#manage_user) to 'false'. Defaults to the OS-specific default user for apache, as detected in `::apache::params`.

##### `apache_name`

The name of the Apache package to install. This is automatically detected in `::apache::params`. You might need to override this if you are using a non-standard Apache package, such as those from Red Hat's software collections.

#### Class: `apache::dev`

Installs Apache development libraries.

*Note:* On FreeBSD, you must declare `apache::package` or `apache` before `apache::dev`.

#### Classes: `apache::mod::*`

Enables specific Apache HTTP Server modules. The following Apache modules have supported classes that allow for parameterized configuration; other Apache modules can be installed using the `apache::mod` define.

#### Class: `apache::mod::alias`
#### Class: `apache::mod::deflate`
#### Class: `apache::mod::event`
#### Class: `apache::mod::expires`
#### Class: `apache::mod::fcgid`
#### Class: `apache::mod::geoip`
#### Class: `apache::mod::info`
#### Class: `apache::mod::negotiation`
#### Class: `apache::mod::pagespeed`
#### Class: `apache::mod::php`
#### Class: `apache::mod::reqtimeout`
#### Class: `apache::mod::security`
#### Class: `apache::mod::ssl`
#### Class: `apache::mod::status`
#### Class: `apache::mod::version`
#### Class: `apache::mod::wsgi`

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

### Public Defines

[//]: # (START COVERAGE)

#### Define: `apache::balancer`

This define creates an Apache balancer cluster. Each balancer cluster needs one or more balancer members, which are declared with [`apache::balancermember`](#define-apachebalancermember).

[//]: # (What is the preferred term for a balancer cluster? The Apache docs use "load balancing group", ie. http://httpd.apache.org/docs/2.2/mod/mod_proxy.html#balancermember. We need to use consistent terms for balancers and balancer members throughout.)

One `apache::balancer` should be defined for each Apache load-balanced set of servers. The `apache::balancermember` defines for all balancer members can be exported and collected on a single Apache load balancer server using [exported resources](/guides/exported_resources.md).

**Parameters within `apache::balancer`:**

#### `name`

This parameter sets the title of the balancer cluster and name of the `conf.d` file containing its configuration.

#### `proxy_set`

This parameter configures key-value pairs as [ProxySet](http://httpd.apache.org/docs/current/mod/mod_proxy.html#proxyset) lines. It accepts a [hash](/latest/reference/lang_data_hash.html) and defaults to `{}`.

#### `collect_exported`

This parameter determines whether or not to use [exported resources](/guides/exported_resources.md). Valid values are `true` and `false`, and the default value is `true`.

If you statically declare all of your backend servers, set this parameter to `false` to rely on existing, declared balancer member resources. Also, make sure to use `apache::balancermember` with array arguments.

To dynamically declare backend servers via exported resources collected on a central node, set this parameter to `true` to collect the balancer member resources exported by the balancer member nodes.

If you do not use exported resources, a single Puppet run configures all balancer members. If you use exported resources, Puppet has to run on the balanced nodes first, then run on the balancer.

#### Define: `apache::balancermember`

This defines members of [`mod_proxy_balancer`](http://httpd.apache.org/docs/current/mod/mod_proxy_balancer.html), which sets up a balancer member inside a listening service configuration block in `/etc/apache/apache.cfg` on the load balancer.

[//]: # (Do we need to generalize the directory reference here? It might be at /etc/httpd, /etc/apache2...)

**Parameters within `apache::balancermember`:**

#### `name`

This parameter sets the title of the resource and the name of the concat fragment.

[//]: # (NEEDS DEFAULTS)

#### `balancer_cluster`

This required parameter sets the Apache service's instance name and must match the name of a declared `apache::balancer` resource.

#### `url`

This parameter specifies the URL used to contact the balancer member server. The default value is 'http://${::fqdn}/'.

#### `options`

This array of [options](http://httpd.apache.org/docs/2.2/mod/mod_proxy.html#balancermember) is specified after the URL and accepts any key-value pairs available to [ProxyPass](http://httpd.apache.org/docs/2.2/mod/mod_proxy.html#proxypass).

[//]: # (NEEDS DEFAULTS)

#### Define: `apache::custom_config`

This define allows you to add a custom configuration file to the Apache server. The file is only added to the Apache `conf.d` directory if it is valid; a Puppet run raises an error if the file is invalid and the define's `$verify_config` parameter is `true`.

**Parameters within `apache::custom_config`:**

#### `ensure`

This parameter specifies whether the configuration file should be present. The default value is `present`, and valid values are `present` and `absent`.

#### `confdir`

This parameter sets the directory in which Puppet places the configuration files. The default value is `$::apache::confd_dir`.

#### `content`

This parameter sets the content of the configuration file. The `$content` and [`$source`]($source) parameters are exclusive of each other.

#### `priority`

This parameter sets the priority of the configuration file by prefixing its filename with this number. Apache uses this prefix to determine the order in which it applies configuration files. The default value is `25`.

To omit the priority prefix in the configuration file's name, pass the `false` value to this parameter.

#### `source`

This parameter points to the configuration file's source. The [`$content`](#content) and `$source` parameters are exclusive of each other.

#### `verify_command`

This parameter specifies the command to use to verify the configuration file. It should use a fully qualified command. The default command is `/usr/sbin/apachectl -t`. 

The `$verify_command` parameter is only used if `$verify_config` is `true`. If the `$verify_command` fails, the configuration file is deleted, the Apache service is not notified, and the Puppet run raises an error.

#### `verify_config`

This Boolean parameter specifies whether the configuration file should be validated before the Apache service is notified. The default value is `true`.

#### Define: `apache::fastcgi::server`

Designed for use with `mod_fastcgi`, `apache::fastcgi::server` defines one or more external FastCGI servers to handle specific file types.

**Parameters within `apache::fastcgi::server`:**

#### `host`

This parameter determines the hostname or IP address and TCP port number (1-65535) of the FastCGI server.

#### `timeout`

This parameter sets the number of seconds of FastCGI application inactivity allowed before aborting the request and logging the event at the error LogLevel. The inactivity timer applies only as long as a connection is pending with the FastCGI application. If a request is queued to an application, but the application doesn't respond by writing and flushing within this period, the request is aborted. If communication is complete with the application but incomplete with the client (the response is buffered), the timeout does not apply.

#### `flush`

This parameter forces `mod_fastcgi` to write to the client as data is received from the application. By default, `mod_fastcgi` buffers data in order to free the application as quickly as possible.

#### `faux_path`

URIs that Apache resolves to this filename are handled by this external FastCGI application. The path set in this parameter does not have to exist in the local filesystem. 

#### `alias`

This unique alias is used internally to link actions with the FastCGI server.

#### `file_type`

This parameter sets the MIME type of the file to be processed by the FastCGI server.

#### Define: `apache::listen`

This define adds [Listen](http://httpd.apache.org/docs/current/bind.html) directives to `ports.conf` in the Apache configuration directory that define the Apache server's or a virtual host's listening address and port. The [`apache::vhost`](#class-apache-vhost) class uses this define, and titles take the form '<port>', '<ipv4>:<port>', or '<ipv6>:<port>'.

#### Define: `apache::mod`

This define attempts to install packages for and enable arbitrary Apache modules that do not have a corresponding `apache::mod::(name)` class. If it can, the `apache::mod` define also places or checks for the existence of default configuration files for those modules in the Apache server's module and enable directories; the precise locations are determined based on the operating system.

[//]: # (END COVERAGE)

#### Define: `apache::namevirtualhost`

Enables name-based hosting of a virtual host. Adds all [NameVirtualHost](http://httpd.apache.org/docs/current/vhosts/name-based.html) directives to the `ports.conf` file in the Apache HTTPD configuration directory. Titles take the form '\*', '*:<port>', '\_default_:<port>, '<ip>', or '<ip>:<port>'.

#### Define: `apache::vhost`

Allows specialized configurations for virtual hosts that have requirements outside the defaults.

##### Parameters: `directories`

##### Parameters: `ssl`

### Private Defines

#### Define: `apache::peruser::multiplexer`

This define checks if an Apache module has a class. If it does, it includes that class. If it does not, it passes the module name to the [`apache::mod`](#define-apache-mod) define.

#### Define: `apache::peruser::multiplexer`

Enables the [Peruser](http://www.freebsd.org/cgi/url.cgi?ports/www/apache22-peruser-mpm/pkg-descr) module for FreeBSD only.

#### Define: `apache::peruser::processor`

Enables the [Peruser](http://www.freebsd.org/cgi/url.cgi?ports/www/apache22-peruser-mpm/pkg-descr) module for FreeBSD only.

#### Define: `apache::security::file_link`

Links the activated_rules from [apache::mod::security](#apache-modsecurity) to the respective CRS rules on disk.

### Templates

The Apache module relies heavily on templates to enable the `vhost` and `apache::mod` defines. These templates are built based on Facter facts around your operating system. Unless explicitly called out, most templates are not meant for configuration.

## Limitations

### Ubuntu 10.04

The `apache::vhost::WSGIImportScript` parameter creates a statement inside the VirtualHost which is unsupported on older versions of Apache, causing this to fail.  This will be remedied in a future refactoring.

### RHEL/CentOS 5

The `apache::mod::passenger` and `apache::mod::proxy_html` classes are untested since repositories are missing compatible packages.

### RHEL/CentOS 7

The `apache::mod::passenger` class is untested as the repository does not have packages for EL7 yet.  The fact that passenger packages aren't available also makes us unable to test the `rack_base_uri` parameter in `apache::vhost`.

### General

This module is CI tested on Centos 5 & 6, Ubuntu 12.04 & 14.04, Debian 7, and RHEL 5, 6, and 7 platforms against both the OSS and Enterprise version of Puppet.

The module contains support for other distributions and operating systems, such as FreeBSD, Gentoo and Amazon Linux, but is not formally tested on those and regressions can occur.

### SELinux and Custom Paths

If you are running with SELinux in enforcing mode and want to use custom paths for your `logroot`, `mod_dir`, `vhost_dir`, and `docroot`, you need to manage the context for the files yourself.

Something along the lines of:

~~~ puppet
        exec { 'set_apache_defaults':
          command => 'semanage fcontext -a -t httpd_sys_content_t "/custom/path(/.*)?"',
          path    => '/bin:/usr/bin/:/sbin:/usr/sbin',
          require => Package['policycoreutils-python'],
        }

        package { 'policycoreutils-python': ensure => installed }

        exec { 'restorecon_apache':
          command => 'restorecon -Rv /apache_spec',
          path    => '/bin:/usr/bin/:/sbin:/usr/sbin',
          before  => Class['Apache::Service'],
          require => Class['apache'],
        }

        class { 'apache': }

        host { 'test.server': ip => '127.0.0.1' }

        file { '/custom/path': ensure => directory, }

        file { '/custom/path/include': 
          ensure  => present, 
          content => '#additional_includes',
        }

        apache::vhost { 'test.server':
          docroot             => '/custom/path',
          additional_includes => '/custom/path/include',
        }
~~~

You need to set the contexts using `semanage fcontext` not `chcon` because `file {...}` resources reset the context to the values in the database if the resource isn't specifying the context.

### FreeBSD

In order to use this module on FreeBSD, you *must* use apache24-2.4.12 (www/apache24) or newer.

## Development

### Contributing

Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad of hardware, software, and deployment configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

Read the complete module [contribution guide](https://docs.puppetlabs.com/forge/contributing.html)

### Running tests

This project contains tests for both [rspec-puppet](http://rspec-puppet.com/) and [beaker-rspec](https://github.com/puppetlabs/beaker-rspec) to verify functionality. For in-depth information please see their respective documentation.

Quickstart:

#### Ruby > 1.8.7

~~~
    gem install bundler
    bundle install
    bundle exec rake spec
    bundle exec rspec spec/acceptance
    RS_DEBUG=yes bundle exec rspec spec/acceptance
~~~

#### Ruby = 1.8.7

~~~
    gem install bundler
    bundle install --without system_tests
    bundle exec rake spec
~~~
