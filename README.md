Puppetlabs module for Apache
============================

Apache is widely-used web server and this module will allow to configure
various modules and setup virtual hosts with minimal effort

Basic usage
-----------

To install Apache

    class {'apache':  }

To install the Apache PHP module

    class {'apache::php': }

Configure a virtual host
------------------------

You can easily configure many parameters of a virtual host. A minimal
example is:

    apache::vhost { 'www.example.com':
        priority        => '10',
        port            => '80',
        docroot         => '/home/www.example.com/docroot/',
        serveradmin     => 'webmaster@example.com',
    }

A slightly more complicated example, which move the docroot and
logfile to alternate location, might be:

    apache::vhost { 'www.example.com':
        priority        => '10',
        port            => '80',
        docroot         => '/home/www.example.com/docroot/',
        logroot         => '/srv/www.example.com/logroot/',
        serveradmin     => 'webmaster@example.com',
        serveraliases   => ['example.com',],
    }

SSL can be enabled for the site. 

    apache::vhost { 'www.example.com-ssl':
      priority    => '10',
      port        => '443',
      docroot     => '/home/www.example.com/docroot',
      serveradmin => 'webmaster@example.com',
      ssl         => true,
      ssl_cert    => '/etc/ssl/certs/example.com.crt',
      ssl_key     => '/etc/ssl/private/example.com.key',
    }

Basic authentication can be configured for a site:

    apache::vhost { 'www.example.com':
      priority    => '10',
      docroot     => '/home/www.example.com/docroot',
      serveradmin => 'webmaster@example.com',
      auth        => '/home/www.example.com/.htaccess',
    }

You can either create the .htaccess file by hand or by using [James's httpauth module](https://github.com/jamtur01/puppet-httpauth)


Notes
-----

At the moment, if you have sites listening on non-standard ports, you will need
to ensure the apache config has the proper "Listen" statement.

Contributors
------------

 * A cast of hundreds, hopefully you too soon

Copyright and License
---------------------

Copyright (C) 2012 Puppet Labs Inc

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
