apache
======

####Table of Contents

1. [Overview - What is the Apache module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with Apache](#setup)
    a. [Beginning with Apache - Installing](#beginning-with-apache)
    b. [Configuring a Virtual Host - Options and instructions](#configuring-a-virtual-host)
4. [Usage - The classes and parameters available for configuration](#usage)
5. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Release Notes - Notes on the most recent updates to the module](#release-notes)

Overview
---------

The Apache module allows you to set up virtual hosts and manage web services with minimal effort. 

Module Description
------------------
Apache is a widely-used web server, and this module provides a simplified way of creating configurations to manage your infrastructure.  **POSSIBLY MORE**

Setup
-----

**What Apache affects:**

* package/service/configuration files for Apache
* Apache modules 
* virtual hosts
* listened-to ports 

###Beginning with Apache 

To install Apache with the default parameters

    class { 'apache':  }
    
The defaults are determined by your operating system (e.g. Debian systems have one set of defaults, RedHat systems have another). If you want customized parameters

    class { 'apache':
      default_mods => false,
      …
    }

###Configure a virtual host

Declaring the `apache` class will create a default virtual host by setting up a vhost on port 80, an ssl vhost on port 443, listening on all interfaces and serving `$apache::docroot`.

    class { 'apache': }
    
To configure a very basic virtual host

    apache::vhost { 'first.example.com':
      port    => '80',
      docroot => '/var/www/first',
    }

A slightly more complicated example, which moves the docroot and owner/group

    apache::vhost { 'second.example.com':
      port          => '80',
      docroot       => '/var/www/second',
      docroot_owner => 'third',
      docroot_group => 'third',
    }

To set up a virtual host with ssl and default ssl certificates

    apache::vhost { 'ssl.example.com':
      port    => '443',
      docroot => '/var/www/ssl',
      ssl     => true,
    }

To set up a virtual host with ssl and specific ssl certificates

    apache::vhost { 'fourth.example.com':
      port     => '443',
      docroot  => '/var/www/fourth',
      ssl      => true,
      ssl_cert => '/etc/ssl/fourth.example.com.cert',
      ssl_key  => '/etc/ssl/fourth.example.com.key',
    }
    
To see a list of all virtual host parameters, [please go here](#vhost). To see an extensive list of virtual host examples [please look here](#vhost-examples). 

Usage
-----

###apache

The Apache module's primary class, `apache`, guides the basic setup of Apache on your system. 

**Parameters within `apache`:**

####`default_mods`

Defaults to 'true' and sets up Apache with default settings based on your OS. Set to 'false' for customized configuration.
 
####`default_vhost`

Defaults to 'true' and sets up a default virtual host. Set to 'false' to set up [customized virtual hosts](#configure-a-virtual-host)

####`default_ssl_vhost`

Defaults to 'true' and sets up a default ssl virtual host

    apache::vhost { 'default-ssl':
      port            => 443,
      ssl             => true,
      docroot         => $docroot,
      scriptalias     => $scriptalias,
      serveradmin     => $serveradmin,
      access_log_file => "ssl_${access_log_file}",
      }
 Set to 'false' to set up a customized ssl virtual host.

####`default_ssl_cert`

The default ssl certification, which is automatically set based on your operating system  (`/etc/pki/tls/certs/localhost.crt` for RedHat, `/etc/ssl/certs/ssl-cert-snakeoil.pem` for Debian).

####`default_ssl_key`

The default ssl key, which is automatically set based on your operating system (`/etc/pki/tls/private/localhost.key' for RedHat, `/etc/ssl/private/ssl-cert-snakeoil.key` for Debian).

####`default_ssl_chain`<-

Defaults to 'undef'.

####`default_ssl_ca`<-

Defaults to 'undef'.

####`default_ssl_crl_path`<-

Defaults to 'undef'.

####`default_ssl_crl`<-

Defaults to 'undef'.

####`service_enable`<-

Defaults to 'true' 

####`serveradmin`

Sets the server administrator. Defaults to 'root@localhost'.

####`sendfile`<-

Defaults to 'false'.

####`error_pages`<-

Defaults to 'false'.
          
###Additional Classes and Defined Types

The Apache module offers many classes and defined types, in addition to `apache`, that enable various functionality within Apache. 

####`apache::dev`

Installs Apache development libraries

	class { 'apache::dev': }
	
####`apache::listen`

Changes the address for the listen port

    class { 'apache::listen':  }
    
Declaring this class will create `listen.erb` file.  Listen should always be either: `<port>`, `<ipv4>:<port>`, or `[<ipv6]:<port>` 

Listen directories*?*  must be added for every port.   

####`apache::mod`

Enables installation of arbitrary Apache modules, when you know the module name and the package name for your package provider
    
    # Package from EPEL    
    apache::mod { 'passenger':
      package => 'mod_passenger',
    }

There are many `apache::mod::[name]` defined types within this module that can be declared using `include`: 

* `alias`
* `auth_basic`
* `auth_kerb`
* `autoindex`
* `cache`
* `cgi`
* `cgid`
* `dav`
* `dav_fs`
* `deflate`
* `dir`
* `disk_cache`
* `fcgid`
* `info`
* `ldap`
* `mime`
* `mime_magic`
* `mpm_event`
* `negotiation`
* `passenger`
* `perl`
* `php`
* `proxy`
* `proxy_html`
* `proxy_http`
* `python`
* `reqtimeout`
* `setenvif`
* `status`
* `userdir`
* `wsgi`

The `apache::mod::[name]` defined type does one of two things.

####`apache::mod::default`

Installs default Apache modules based on what OS you are running

    class { 'apache::mod::default': } 
	
####`apache::mod::ssl`

Installs Apache SSL capabilities

	class { 'apache::mod::ssl': }

####`apache::namevirtualhost`

Enables IP-based hosting of a virtual host

    class { 'apache::namevirtualhost`: }
    
Declaring this class will create a `namevirtualhost.erb` file. NameVirtualHost should always be either: `*`, `*:<port>`, `_default_:<port>`, `<ip>`, or `<ip>:<port>`.

###vhost

The Apache module allows a lot of flexibility in the set up and configuration of virtual hosts. This flexibility is due, in part, to `vhost`'s setup as a defined resource type, which allows it to be evaluated multiple times with different parameters. It is also due, in part, to the wide range of parameters available for configuration within the `vhost` type framework. 

**Parameters within `vhost`:**

The default values for each parameter will vary based on operating system and type of virtual host. 

####`access_log` 

Specifies if `*_access.log` directives should be configured. Valid values are 'true' and 'false'. 

####`configure_firewall`

Specifies whether a firewall should be configured. Valid values are 'true' or 'false'.

####`docroot` 

Provides the DocumentationRoot variable.

####`ensure`

Specifies if the vhost file is present or absent.

####`logroot`

Specifies the location of the virtual host's logfiles. Defaults to `/var/log/<apache log location>/`

####`options` 

Lists the options for the given virtual host

    apache::vhost { 'site.name.fdqn':
      …
      options => ['Indexes','FollowSymLinks','MultiViews'],
    }

####`override`

Sets the overrides for the given virtual host. Accepts an array of AllowOverride arguments. 

####`port`

Sets the port the host is configured on.

####`priority`

Sets the priority of the site.

####`serveradmin`

Specifies the email address Apache will display when it renders one of its error pages

####`serveraliases`

Sets the server aliases of the site

####`servername`

Sets the primary name of the virtual host

####`ssl`

Enables SSL for the virtual host. Valide Values are 'true' or 'false'.

####`template` **STILL VALID?**

Specifies whether to use the default template or override.

####`vhost_name`

This parameter is for use with name-based virtual hosting. Defaults to '*'.

        $ip                 = undef,
    $ip_based           = false,
    $add_listen         = true,
    $docroot_owner      = 'root',
    $docroot_group      = 'root',
    $ssl_cert           = $apache::default_ssl_cert,
    $ssl_key            = $apache::default_ssl_key,
    $ssl_chain          = $apache::default_ssl_chain,
    $ssl_ca             = $apache::default_ssl_ca,
    $ssl_crl_path       = $apache::default_ssl_crl_path,
    $ssl_crl            = $apache::default_ssl_crl,
    $ssl_certs_dir      = $apache::params::ssl_certs_dir,
    $access_log_file    = undef,
    $error_log          = true,
    $error_log_file     = undef,
    $scriptalias        = undef,
    $proxy_dest         = undef,
    $no_proxy_uris      = [],
    $redirect_source    = '/',
    $redirect_dest      = undef,
    $redirect_status    = undef,
    $rack_base_uris     = undef,
    $rewrite_rule       = undef,
    $rewrite_base       = undef,
    $rewrite_cond       = undef,
    $block              = [],
  ) {



Implementation
--------------

**Native Resource Types**

####`a2mod` 

A type that works within `apache::mod` to enable or disable Apache modules.



	

Limitations
-----------


Development
-----------

Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad of hardware, software, and deployment configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

You can read the complete module contribution guide [on the Puppet Labs wiki.](http://projects.puppetlabs.com/projects/module-site/wiki/Module_contributing)

Copyright and License
---------------------

Copyright (C) 2012 [Puppet Labs](https://www.puppetlabs.com/) Inc

Puppet Labs can be contacted at: info@puppetlabs.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Release Notes
-------------