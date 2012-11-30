apache
=======

Module Description
-------------------

Apache is a widely-used web server that this module helps you configure. Using this 
module, you can set up virtual hosts and manage your web services with minimal effort.

Usage
------

## Classes

### apache::apache

To install Apache

    class {'apache':  }

### apache::mod::php

To install the Apache PHP module

    class {'apache::mod::php': }
    
### apache::mod::dev

This class installs Apache development libraries

	class {'apache::mod::dev': }
### apache::mod::proxy

Enable the proxy module for Apache

	class {'apache::mod::proxy': }
	
### apache::mod::python

To install Python for Apache

	class {'apache::mod::python': }
	
### apache::mod::ssl

Install Apache SSL capabilities

	class {'apache::mod::ssl': }
		
## Defined Types

### apache::vhost

To configure a virtual host

    apache::vhost { 'www.example.com':
        priority        => '10',
        vhost_name      => '192.0.2.1',
        port            => '80',
    }

A slightly more complicated example, which moves the docroot and
logfile to an alternate location

    apache::vhost { 'www.example.com':
        priority        => '10',
        vhost_name      => '192.0.2.1',
        port            => '80',
        docroot         => '/home/www.example.com/docroot/',
        logroot         => '/srv/www.example.com/logroot/',
        serveradmin     => 'webmaster@example.com',
        serveraliases   => ['example.com',],
    }

You must to ensure that all needed parent directories exist. In the more complicated 
example above, you need to ensure that the `/home/www.example.com` and `/srv/www.example.com`
directories exist.

### apache::mod

To enable installation of multiple apache modules

	define apache::mod (
  		$package = undef
	) {
  		$mod = $name
  		include apache::params
  		#include apache #This creates duplicate resources in rspec-puppet
	  	$mod_packages = $apache::params::mod_packages
  		$mod_package = $mod_packages[$mod] # 2.6 compatibility hack
  		if $package {
    		$package_REAL = $package
  		} elsif "$mod_package" {
    		$package_REAL = $mod_package
  		}
  		$mod_libs = $apache::params::mod_libs
  		$mod_lib = $mod_libs[$mod] # 2.6 compatibility hack
  		if "${mod_lib}" {
    		$lib = $mod_lib
  		}

Implementation
---------------

## Native Resource Types

	Puppet::Type.newtype(:a2mod) do
    	@doc = "Manage Apache 2 modules"

Limitations
------------

There are some known bugs and issues with this module. Please see [our issue tracker](https://github.com/puppetlabs/puppetlabs-apache/issues)
to keep up to date. 

Please log tickets and issues at our [Report issues page](https://projects.puppetlabs.com/projects/modules).

Development
------------



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
