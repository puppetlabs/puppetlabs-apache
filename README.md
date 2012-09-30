Puppetlabs module for Apache
============================

Apache is widely-used web server and this module will allow to configure
various modules and setup virtual hosts with minimal effort.

Basic usage
-----------

To install Apache

    class {'apache':  }

To install the Apache PHP module

    class {'apache::mod::php': }

Configure a virtual host
------------------------

You can easily configure many parameters of a virtual host. A minimal
example is:

    apache::vhost { 'www.example.com':
        priority        => '10',
        vhost_name      => '192.0.2.1',
        port            => '80',
    }

A slightly more complicated example, which moves the docroot and
logfile to an alternate location, might be:

    apache::vhost { 'www.example.com':
        priority        => '10',
        vhost_name      => '192.0.2.1',
        port            => '80',
        docroot         => '/home/www.example.com/docroot/',
        logroot         => '/srv/www.example.com/logroot/',
        serveradmin     => 'webmaster@example.com',
        serveraliases   => ['example.com',],
    }

Dependencies
------------

Some functionality is dependent on other modules:

- [stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
- [firewall](https://github.com/puppetlabs/puppetlabs-firewall)

Notes
-----

Since Puppet cannot ensure that all parent directories exist you need to
manage these yourself. In the more advanced example above, you need to ensure 
that `/home/www.example.com` and `/srv/www.example.com` directories exist.

Contributors
------------

 * A cast of hundreds, hopefully you too soon

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
