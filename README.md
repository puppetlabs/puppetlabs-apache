# apache

#### Table of Contents

1. [Overview - What is the apache module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with apache](#setup)
    * [Beginning with Apache - Installation](#beginning-with-apache)
4. [Usage - The classes and defined types available for configuration](#usage)
    * [Configure a virtual host - Basic options for getting started](#configure-a-virtual-host)
        * [Virtual Host Examples - Demonstrations of some configuration options](#virtual-host-examples)
    * [Load balancing with exported and non-exported resources](#load-balancing-examples)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Public Classes](#public-classes)
    * [Private Classes](#private-classes)
    * [Public Defines](#public-defines)
    * [Private Defines](#private-defines)
    * [Templates](#templates)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
    * [Contributing to the apache module](#contributing)
    * [Running tests - A quick guide](#running-tests)

## Module Description

Apache HTTP Server (also simply called "Apache") is a widely used web server. This Puppet module simplifies the task of creating configurations to manage Apache servers in your infrastructure. It includes the ability to configure and manage a range of virtual host setups, as well as a streamlined way to install and configure Apache modules.

## Setup

**What the apache Puppet module affects:**

* Configuration files and directories (created and written to)
    * **WARNING**: Configurations *not* managed by Puppet will be purged.
* Package/service/configuration files for Apache
* Apache modules
* Virtual hosts
* Listened-to ports
* `/etc/make.conf` on FreeBSD and Gentoo

On Gentoo, this module depends on the 'gentoo/puppet-portage' Puppet module. <!-- Should we link to the [GitHub repo](https://github.com/gentoo/puppet-portage) for this module? -->

*Note:* This module modifies Apache configuration files and directories and purges any configuration not managed by Puppet. Configuration of Apache should be managed by Puppet, as non-Puppet configuration files can cause unexpected failures.

To temporarily disable full Puppet management, set the [`purge_configs`](#purge_configs) parameter in the base `apache` class to 'false'. We recommend using this only as a temporary means of saving and relocating customized configurations. See the [`purge_configs`](#purge_configs) parameter for more information.

### Beginning with Apache

To install Apache with the default parameters, use this Puppet code:

~~~ puppet
    class { 'apache':  }
~~~

The Puppet module applies a default configuration based on your operating system. For example, Debian, Red Hat, FreeBSD, and Gentoo systems each have unique default configurations. These defaults work in testing environments but are not suggested for production; Puppet recommends customizing parameters to suit your site. Use the [Reference](#reference) section to find default parameter values.

You can customize parameters when declaring the `apache` class:

~~~ puppet
    class { 'apache':
      default_mods        => false,
      default_confd_files => false,
    }
~~~

## Usage

### Configuring a virtual host

The default `apache` class sets up a virtual host on port 80, listening on all interfaces and serving the default `$apache::docroot`.

*Note:* See the [`apache::vhost`](#define-apachevhost) define reference for a list of all virtual host parameters.

To configure a basic name-based virtual host, specify the `port` and `docroot` using the `apache::vhost` define:

~~~ puppet
    apache::vhost { 'first.example.com':
      port    => '80',
      docroot => '/var/www/first',
    }
~~~

*Note:* The `apache::vhost` define's default `[priority](#defines-apachevhost)` value is 15. If nothing matches this priority, or if you pass a higher priority value than the default and no names match anything else, Apache prioritizes them in alphabetical order. <!-- What is going on here? Should this be "if multiple vhosts have the same priority, Puppet (or Apache?) prioritizes them in alphabetical order"? -->

To configure user and group ownership for `docroot`, use the `[docroot_owner](#docroot_owner)` and `[docroot_group](#docroot_group)` parameters:

~~~ puppet
    apache::vhost { 'second.example.com':
      port          => '80',
      docroot       => '/var/www/second',
      docroot_owner => 'www-data',
      docroot_group => 'www-data',
    }
~~~

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
    apache::vhost { 'fourth.example.com':
      port     => '443',
      docroot  => '/var/www/fourth',
      ssl      => true,
      ssl_cert => '/etc/ssl/fourth.example.com.cert',
      ssl_key  => '/etc/ssl/fourth.example.com.key',
    }
~~~

Virtual hosts listen on all IP addresses ('*') by default. To listen on a specific IP address, use the `[ip](#ip)` parameter:

~~~ puppet
    apache::vhost { 'subdomain.example.com':
      ip      => '127.0.0.1',
      port    => '80',
      docroot => '/var/www/subdomain',
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

To set up a virtual host with [filter rules](http://httpd.apache.org/docs/2.2/filter.html), pass the filter directives as an array using the `[filters](#filters)` parameter:

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

Please note that the 'disabled' argument to `FallbackResource` is only supported since Apache 2.2.24.

## Reference

* **Public Classes**
    * [Class: apache](#class-apache)
    * [Class: apache::dev](#class-apachedev)
    * [Classes: apache::mod::*](#classes-apachemodname)
* **Private Classes**
    * [Class: apache::confd::no_accf](#class-apacheconfdno_accf)
    * [Class: apache::default_confd_files](#class-apachedefault_confd_files)
    * [Class: apache::default_mods](#class-apachedefault_mods)
    * [Class: apache::package](#class-apachepackage)
    * [Class: apache::params](#class-apacheparams)
    * [Class: apache::service](#class-apacheservice)
* **Public Defines**
    * [Define: apache::balancer](#define-apachebalancer)
    * [Define: apache::balancermember](#define-apachebalancermember)
    * [Define: apache::custom_config](#define-apachecustom_config)
    * [Define: apache::fastcgi::server](#define-fastcgi-server)
    * [Define: apache::listen](#define-apachelisten)
    * [Define: apache::mod](#define-apachemod)
    * [Define: apache::namevirtualhost](#define-apachenamevirtualhost)
    * [Define: apache:vhost](#define-apachevhost)
* **Private Defines**
    * [Define: apache::peruser::multiplexer](#define-apacheperusermultiplexer)
    * [Define: apache::peruser::processor](#define-apacheperuserprocessor)
    * [Define: apache::security::file_link](#define-apachesecurityfile_link)
* [**Templates**](#templates)

### Class: `apache`

This public class guides the basic setup of Apache on your system. <!-- What does it do? Should we detail that here? -->

Include the `apache` class for nodes that need to use the resources in this module:

~~~ puppet
    class { 'apache': }
~~~

You can establish a default virtual host in this class, the `vhost` class, or both. You can add additional configurations for specific virtual hosts by declaring the `vhost` type. <!-- Type? Define? Class? Parameter? -->

**Parameters within `apache`:**

#### `allow_encoded_slashes`

This parameter sets the server default for the [`AllowEncodedSlashes` declaration](http://httpd.apache.org/docs/current/mod/core.html#allowencodedslashes), which modifies the responses to URLs containing `\` and `/` characters. The default is undefined,<!-- Does this mean the default is `undef`? --> which omits the declaration from the server configuration and selects the Apache default setting of `Off`. The allowed values are `on`, `off`, or `nodecode`.

#### `apache_version`
<!--
    Cont.
    
    DID: 
      - Reorganized the Reference section and headers.
      - Removed old Usage section to separate doc to reflow into reorganized 
        Reference and Usage sections.
    IN PROGRESS:
      - Clean up reorganized Reference section material.
    TO DO: 
      - Move reference materials in the Usage section to the Reference section.
      - Consolidate usage materials in the Setup section with the usage 
        materials in the Usage section.
-->

This parameter configures module template behavior, package names, and default Apache modules by defining the Apache version. Default is determined by the class `apache::version` using the OS family and release. It should not be configured manually without special reason.

#### `conf_dir`

Changes the location of the configuration directory the main configuration file is placed in. Defaults to '/etc/httpd/conf' on RedHat, '/etc/apache2' on Debian, '/usr/local/etc/apache22' on FreeBSD, and '/etc/apache2' on Gentoo.

#### `confd_dir`

Changes the location of the configuration directory your custom configuration files are placed in. Defaults to '/etc/httpd/conf' on RedHat, '/etc/apache2/conf.d' on Debian, '/usr/local/etc/apache22' on FreeBSD, and '/etc/apache2/conf.d' on Gentoo.

#### `conf_template`

Overrides the template used for the main apache configuration file. Defaults to 'apache/httpd.conf.erb'.

*Note:* Using this parameter is potentially risky, as the module has been built for a minimal configuration file with the configuration primarily coming from conf.d/ entries.

#### `default_charset`

If defined, the value will be set as `AddDefaultCharset` in the main configuration file. It is undefined by default.

#### `default_confd_files`

Generates default set of include-able Apache configuration files under  `${apache::confd_dir}` directory. These configuration files correspond to what is usually installed with the Apache package on a given platform.

#### `default_mods`

Sets up Apache with default settings based on your OS. Valid values are 'true', 'false', or an array of mod names.

Defaults to 'true', which includes the default [HTTPD mods](https://github.com/puppetlabs/puppetlabs-apache/blob/master/manifests/default_mods.pp).

If false, it only includes the mods required to make HTTPD work, and any other mods can be declared on their own.

If an array, the apache module includes the array of mods listed.

#### `default_ssl_ca`

The default certificate authority, which is automatically set to 'undef'. This default works out of the box but must be updated with your specific certificate information before being used in production.

#### `default_ssl_cert`

The default SSL certification, which is automatically set based on your operating system  ('/etc/pki/tls/certs/localhost.crt' for RedHat, '/etc/ssl/certs/ssl-cert-snakeoil.pem' for Debian, '/usr/local/etc/apache22/server.crt' for FreeBSD, and '/etc/ssl/apache2/server.crt' for Gentoo). This default works out of the box but must be updated with your specific certificate information before being used in production.

#### `default_ssl_chain`

The default SSL chain, which is automatically set to 'undef'. This default works out of the box but must be updated with your specific certificate information before being used in production.

#### `default_ssl_crl`

The default certificate revocation list to use, which is automatically set to 'undef'. This default works out of the box but must be updated with your specific certificate information before being used in production.

#### `default_ssl_crl_path`

The default certificate revocation list path, which is automatically set to 'undef'. This default works out of the box but must be updated with your specific certificate information before being used in production.

#### `default_ssl_crl_check`

Sets the default certificate revocation check level via the [SSLCARevocationCheck directive](http://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcarevocationcheck), which is automatically set to 'undef'. This default works out of the box but must be specified when using CRLs in production. Only applicable to Apache 2.4 or higher, the value is ignored on older versions.

#### `default_ssl_key`

The default SSL key, which is automatically set based on your operating system ('/etc/pki/tls/private/localhost.key' for RedHat, '/etc/ssl/private/ssl-cert-snakeoil.key' for Debian, '/usr/local/etc/apache22/server.key' for FreeBSD, and '/etc/ssl/apache2/server.key' for Gentoo). This default works out of the box but must be updated with your specific certificate information before being used in production.

#### `default_ssl_vhost`

Sets up a default SSL virtual host. Defaults to 'false'. If set to 'true', sets up the following vhost:

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

SSL vhosts only respond to HTTPS queries.

#### `default_type`

(Apache httpd 2.2 only) MIME content-type that will be sent if the server cannot determine a type in any other way. This directive has been deprecated in Apache httpd 2.4, and only exists there for backwards compatibility of configuration files.

#### `default_vhost`

Sets up a default virtual host. Defaults to 'true', set to 'false' to set up [customized virtual hosts](#configure-a-virtual-host).

#### `docroot`

Changes the location of the default [Documentroot](https://httpd.apache.org/docs/current/mod/core.html#documentroot). Defaults to '/var/www/html' on RedHat, '/var/www' on Debian, '/usr/local/www/apache22/data' on FreeBSD, and '/var/www/localhost/htdocs' on Gentoo.

#### `error_documents`

Enables custom error documents. Defaults to 'false'.

#### `group`

Changes the group that Apache will answer requests as. The parent process will continue to be run as root, but resource accesses by child processes will be done under this group. By default, puppet will attempt to manage this group as a resource under `::apache`. If this is not what you want, set [`manage_group`](#manage_group) to 'false'. Defaults to the OS-specific default user for apache, as detected in `::apache::params`.

#### `httpd_dir`

Changes the base location of the configuration directories used for the apache service. This is useful for specially repackaged HTTPD builds, but might have unintended consequences when used in combination with the default distribution packages. Defaults to '/etc/httpd' on RedHat, '/etc/apache2' on Debian, '/usr/local/etc/apache22' on FreeBSD, and '/etc/apache2' on Gentoo.

#### `keepalive`

Enables persistent connections.

#### `keepalive_timeout`

Sets the amount of time the server waits for subsequent requests on a persistent connection. Defaults to '15'.

#### `max_keepalive_requests`

Sets the limit of the number of requests allowed per connection when KeepAlive is on. Defaults to '100'.

#### `lib_path`

Specifies the location where apache module files are stored. It should not be configured manually without special reason.

#### `loadfile_name`

Sets the file name for the module loadfile. Should be in the format \*.load.  This can be used to set the module load order.

#### `log_level`

Changes the verbosity level of the error log. Defaults to 'warn'. Valid values are 'emerg', 'alert', 'crit', 'error', 'warn', 'notice', 'info', or 'debug'.

#### `log_formats`

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

#### `logroot`

Changes the directory where Apache log files for the virtual host are placed. Defaults to '/var/log/httpd' on RedHat, '/var/log/apache2' on Debian, '/var/log/apache22' on FreeBSD, and '/var/log/apache2' on Gentoo.

#### `logroot_mode`

Overrides the mode the default logroot directory is set to ($::apache::logroot). Defaults to undef. Do NOT give people write access to the directory the logs are stored
in without being aware of the consequences; see http://httpd.apache.org/docs/2.4/logs.html#security for details.

#### `manage_group`

Setting this to 'false' stops the group resource from being created. This is for when you have a group, created from another Puppet module, you want to use to run Apache. Without this parameter, attempting to use a previously established group would result in a duplicate resource error.

#### `manage_user`

Setting this to 'false' stops the user resource from being created. This is for instances when you have a user, created from another Puppet module, you want to use to run Apache. Without this parameter, attempting to use a previously established user would result in a duplicate resource error.

#### `mod_dir`

Changes the location of the configuration directory your Apache modules configuration files are placed in. Defaults to '/etc/httpd/conf.d' for RedHat, '/etc/apache2/mods-available' for Debian, '/usr/local/etc/apache22/Modules' for FreeBSD, and '/etc/apache2/modules.d' on Gentoo.

#### `mpm_module`

Determines which MPM is loaded and configured for the HTTPD process. Valid values are 'event', 'itk', 'peruser', 'prefork', 'worker', or 'false'. Defaults to 'prefork' on RedHat, FreeBSD and Gentoo, and 'worker' on Debian. Must be set to 'false' to explicitly declare the following classes with custom parameters:

* `apache::mod::event`
* `apache::mod::itk`
* `apache::mod::peruser`
* `apache::mod::prefork`
* `apache::mod::worker`

*Note:* Switching between different MPMs on FreeBSD is possible but quite difficult. Before changing `$mpm_module` you must uninstall all packages that depend on your currently-installed Apache.

#### `package_ensure`

Allows control over the package ensure attribute. Can be 'present','absent', or a version string.

#### `ports_file`

Changes the name of the file containing Apache ports configuration. Default is `${conf_dir}/ports.conf`.

#### `purge_configs`

Removes all other Apache configs and vhosts, defaults to 'true'. Setting this to 'false' is a stopgap measure to allow the apache module to coexist with existing or otherwise-managed configuration. It is recommended that you move your configuration entirely to resources within this module.

#### `purge_vhost_configs`

If `vhost_dir` != `confd_dir`, this controls the removal of any configurations that are not managed by Puppet within `vhost_dir`. It defaults to the value of `purge_configs`. Setting this to false is a stopgap measure to allow the apache module to coexist with existing or otherwise unmanaged configurations within `vhost_dir`

#### `sendfile`

Makes Apache use the Linux kernel sendfile to serve static files. Defaults to 'On'.

#### `serveradmin`

Sets the server administrator. Defaults to 'root@localhost'.

#### `servername`

Sets the server name. Defaults to `fqdn` provided by Facter.

#### `server_root`

Sets the root directory in which the server resides. Defaults to '/etc/httpd' on RedHat, '/etc/apache2' on Debian, '/usr/local' on FreeBSD, and '/var/www' on Gentoo.

#### `server_signature`

Configures a trailing footer line under server-generated documents. More information about [ServerSignature](http://httpd.apache.org/docs/current/mod/core.html#serversignature). Defaults to 'On'.

#### `server_tokens`

Controls how much information Apache sends to the browser about itself and the operating system. More information about [ServerTokens](http://httpd.apache.org/docs/current/mod/core.html#servertokens). Defaults to 'OS'.

#### `service_enable`

Determines whether the HTTPD service is enabled when the machine is booted. Defaults to 'true'.

#### `service_ensure`

Determines whether the service should be running. Valid values are 'true', 'false', 'running', or 'stopped' when Puppet should manage the service. Any other value sets ensure to 'false' for the Apache service, which is useful when you want to let the service be managed by some other application like Pacemaker. Defaults to 'running'.

#### `service_name`

Name of the Apache service to run. Defaults to: 'httpd' on RedHat, 'apache2' on Debian and Gentoo, and 'apache22' on FreeBSD.

#### `service_manage`

Determines whether the HTTPD service state is managed by Puppet . Defaults to 'true'.

#### `service_restart`

Determines whether the HTTPD service restart command should be anything other than the default managed by Puppet.  Defaults to undef.

#### `timeout`

Sets the amount of seconds the server will wait for certain events before failing a request. Defaults to 120.

#### `trace_enable`

Controls how TRACE requests per RFC 2616 are handled. More information about [TraceEnable](http://httpd.apache.org/docs/current/mod/core.html#traceenable). Defaults to 'On'.

#### `vhost_dir`

Changes the location of the configuration directory your virtual host configuration files are placed in. Defaults to 'etc/httpd/conf.d' on RedHat, '/etc/apache2/sites-available' on Debian, '/usr/local/etc/apache22/Vhosts' on FreeBSD, and '/etc/apache2/vhosts.d' on Gentoo.

#### `user`

Changes the user that Apache will answer requests as. The parent process will continue to be run as root, but resource accesses by child processes will be done under this user. By default, puppet will attept to manage this user as a resource under `::apache`. If this is not what you want, set [`manage_user`](#manage_user) to 'false'. Defaults to the OS-specific default user for apache, as detected in `::apache::params`.

#### `apache_name`

The name of the Apache package to install. This is automatically detected in `::apache::params`. You might need to override this if you are using a non-standard Apache package, such as those from Red Hat's software collections.

### Class: apache::dev

Installs Apache development libraries.

*Note:* On FreeBSD, you must declare `apache::package` or `apache` before `apache::dev`.

### Classes: apache::mod::*

Enables specific Apache HTTP Server modules.

#### Class: apache::mod::alias
#### Class: apache::mod::deflate
#### Class: apache::mod::event
#### Class: apache::mod::expires
#### Class: apache::mod::fcgid
#### Class: apache::mod::geoip
#### Class: apache::mod::info
#### Class: apache::mod::negotiation
#### Class: apache::mod::pagespeed
#### Class: apache::mod::php
#### Class: apache::mod::reqtimeout
#### Class: apache::mod::security
#### Class: apache::mod::ssl
#### Class: apache::mod::status
#### Class: apache::mod::version
#### Class: apache::mod::wsgi

### Private Classes

### Class: apache::confd::no_accf

Creates the `no-accf.conf` configuration file in `conf.d`, required by FreeBSD's Apache 2.4.

### Class: apache::default_confd_files

Includes `conf.d` files for FreeBSD.

### Class: apache::default_mods

Installs the Apache modules required to run the default configuration.

### Class: apache::package

Installs and configures basic Apache packages.

### Class: apache::params

Manages Apache parameters.

### Class: apache::service

Manages the Apache daemon.

### Public Defines

### Define: apache::balancer

Creates an Apache balancer cluster.

### Define: apache::balancermember

Defines members of [mod_proxy_balancer](http://httpd.apache.org/docs/current/mod/mod_proxy_balancer.html).

### Define: apache::custom_config

Based on the title, controls which ports Apache binds to for listening. Adds [Listen](http://httpd.apache.org/docs/current/bind.html) directives to ports.conf in the Apache HTTPD configuration directory. Titles take the form '<port>', '<ipv4>:<port>', or '<ipv6>:<port>'.

### Define: apache::fastcgi::server

Used to enable arbitrary Apache HTTPD modules for which there is no specific `apache::mod::[name]` class.

### Define: apache::listen

### Define: apache::mod

### Define: apache::namevirtualhost

Enables name-based hosting of a virtual host. Adds all [NameVirtualHost](http://httpd.apache.org/docs/current/vhosts/name-based.html) directives to the `ports.conf` file in the Apache HTTPD configuration directory. Titles take the form '\*', '*:<port>', '\_default_:<port>, '<ip>', or '<ip>:<port>'.

### Define: apache:vhost

Allows specialized configurations for virtual hosts that have requirements outside the defaults.

##### Parameters: `directories`

##### Parameters: `ssl`

### Private Defines

### Define: apache::peruser::multiplexer

Enables the [Peruser](http://www.freebsd.org/cgi/url.cgi?ports/www/apache22-peruser-mpm/pkg-descr) module for FreeBSD only.

### Define: apache::peruser::processor

Enables the [Peruser](http://www.freebsd.org/cgi/url.cgi?ports/www/apache22-peruser-mpm/pkg-descr) module for FreeBSD only.

### Class: apache::security::file_link

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
