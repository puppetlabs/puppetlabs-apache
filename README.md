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
        ipaddr          => '192.0.2.1',
        port            => '80',
    }

A slightly more complicated example, which move the docroot and
logfile to alternate location, might be:

    apache::vhost { 'www.example.com':
        priority        => '10',
        ipaddr          => '192.0.2.1',
        port            => '80',
        docroot         => '/home/www.example.com/docroot/',
        logroot         => '/srv/www.example.com/logroot/',
        serveradmin     => 'webmaster@example.com',
        serveraliases   => ['example.com',],
    }

Configure an IPv4 and IPv6 host
-------------------------------

Typically you will want to serve the same content to IPv4 and IPv6
users. And you are likely to want to have the logfile contain entries
from both virtual hosts.


    apache::vhost { 'www.example.com':
        priority        => '10',
        vhost_name      => '192.0.2.1',
        port            => '80',
    }

    apache::vhost { 'www.example.com-IPv6':
        servername      => 'www.example.com',
        priority        => '10',
        vhost_name      => '2001:db8::2:1',
        port            => '80',
        ensure_dirs     => false,
    }


By default, the variable `servername` is used to construct the path to
logfiles. In the first case, with no explicit configuration, the
`servername` is set to the name of the resource (i.e. www.example.com).

In the second case, we specifiy it explicitly. We also disable ensuring
that the `docroot` and `logroot` exist, since they will be handled by
the first virtual host definition.


Notes
-----

Nothing of note.

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
