apache
======

Overview
---------

The Apache module allows you to set up virtual hosts and manage web services with minimal effort. 

Module Description
------------------
Apache is a widely-used web server, and this module provides a simplified way of creating configurations to manage your infrastructure.  

Setup
-----

**What Apache affects:**

* package/service/configuration files for Apache
* Apache modules 
* virtual hosts
* listened-to ports
* Maybe something about docroot/logroot type files? I'm not 100% on what those are. 

###Beginning with Apache 

To install Apache

    class {'apache':  }

###Configure a virtual host

You can easily configure many parameters of a virtual host. A minimal
example is:

    apache::vhost { 'www.example.com':
      priority        => '10',
      vhost_name      => '192.0.2.1',
      port            => '80',
    }

A slightly more complicated example, which moves the docroot and logfile to an alternate location, might be:

    apache::vhost { 'www.example.com':
      priority        => '10',
      vhost_name      => '192.0.2.1',
      port            => '80',
      docroot         => '/home/www.example.com/docroot/',
      logroot         => '/srv/www.example.com/logroot/',
      serveradmin     => 'webmaster@example.com',
      serveraliases   => ['example.com',],
    }

Since Puppet cannot ensure that all parent directories exist you need to
manage these yourself. In the example above, you need to ensure that `/home/www.example.com` and `/srv/www.example.com` directories exist.

Usage
-----

The Apache module offers many classes, in addition to `apache`, that enable various functionality within Apache. 

**Classes within `puppetlabs-apache`**

#### `apache::mod::php`

Install the Apache PHP module

    class {'apache::mod::php': }
    
####`apache::mod::dev`

Install Apache development libraries

	class {'apache::mod::dev': }
	
####`apache::mod::proxy`

Enable the proxy module for Apache

	class {'apache::mod::proxy': }
	
####`apache::mod::python`

Install Python for Apache

	class {'apache::mod::python': }
	
####`apache::mod::ssl`

Install Apache SSL capabilities

	class {'apache::mod::ssl': }

**Defined Types within `puppetlabs-apache`**

####`apache::mod`

To enable installation of arbitrary Apache modules, when you know the module name and the package name for your package provider
    
    # Package from EPEL    
    apache::mod { 'passenger':
      package => 'mod_passenger',
    }

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