apache
=======

Module Description
-------------------

Apache is a widely-used web server that this module helps you configure. Using this 
module, you can set up virtual hosts and manage your web services with minimal effort.

Usage
------

### Classes

**apache::apache**

Install Apache

    class {'apache':  }

**apache::mod::php**

Install the Apache PHP module

    class {'apache::mod::php': }
    
**apache::mod::dev**

Install Apache development libraries

	class {'apache::mod::dev': }
	
**apache::mod::proxy**

Enable the proxy module for Apache

	class {'apache::mod::proxy': }
	
**apache::mod::python**

Install Python for Apache

	class {'apache::mod::python': }
	
**apache::mod::ssl**

Install Apache SSL capabilities

	class {'apache::mod::ssl': }
		
### Defined Types

Each of these will require that you also declare the apache class.

**apache::vhost**

Configure a virtual host

    apache::vhost { 'www.example.com':
      priority   => '10',
      vhost_name => '192.0.2.1',
      port       => '80',
      docroot    => '/var/www/html',
    }

As a slightly more complicated example, this is what moving the docroot and logfile to an
alternate location might look like

    apache::vhost { 'www.example.com':
      priority      => '10',
      vhost_name    => '192.0.2.1',
      port          => '80',
      docroot       => '/home/www.example.com/docroot',
      logroot       => '/srv/www.example.com/logroot',
      serveradmin   => 'webmaster@example.com',
      serveraliases => ['example.com',],
    }

You must ensure that all needed parent directories exist. In the more complicated
example above, you need to ensure that the `/home/www.example.com` and `/srv/www.example.com` 
directories exist.

**apache::mod**

To enable installation of arbitary Apache modules, when you know the module name and the 
package name for your package provider

    # Package from EPEL
    apache::mod { 'passenger':
      package => 'mod_passenger',
    }

Implementation
---------------

### Native Resource Types

**a2mod** 

Type to enable or disable Apache modules. It is used by the `apache::mod`
defined resource type.

	a2mod { 'passenger':
      ensure => present,
      lib    => 'mod_passenger.so',
	}

Limitations
------------

There are some known bugs and issues with this module. Please see [our issue tracker](https://github.com/puppetlabs/puppetlabs-apache/issues)
to keep up to date.

Please log tickets and issues at our [Report issues page](https://projects.puppetlabs.com/projects/modules).

Development
------------

Puppet Labs modules on the Puppet Forge are open projects, and community contributions
are essential for keeping them great. We can’t access the huge number of platforms and
myriad of hardware, software, and deployment configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our modules work
in your environment. There are a few guidelines that we need contributors to follow so
that we can have a chance of keeping on top of things.

You can read the complete module contribution guide [on the Puppet Labs wiki.](http://projects.puppetlabs.com/projects/module-site/wiki/Module_contributing)


Disclaimer
-----------

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
