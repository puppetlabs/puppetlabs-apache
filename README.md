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

RequestHeader statements
------------------------

The `requestheader` parameter passes either a single `RequestHeader` statement as a string or an array of `RequestHeader` statment strings. See http://httpd.apache.org/docs/2.2/mod/mod_headers.html#requestheader for more details.

Configuring SSL
---------------

The following parameters can be passed to `apache::vhost` to set up SSL. It is recommended that `apache::mod::ssl` is installed before hand, and that any certificates are installed prior to setting up the virtual host.

This assumes that all public certificates (host and CA certs) are all stored in the one directory defined with the `ssl_public_cert_dir`. Once SSL is enabled, a path to a public certificate and a private key must be supplied.

For each declaration, the default value (as per http://httpd.apache.org/docs/2.2/mod/mod_ssl.html) has been used. If a default value is passed as a parameter it will be omitted.

Note: Only the SSL declarations required to make puppetmaster go have been addressed.

* *ssl* Setting this to `true` enables SSL. Default is `false`. This enables multiple Apache SSL directives.
* *ssl_dir* This sets the root directory under which all the SSL files are stored. The default is `/etc/apache2/ssl` for Ubuntu.
* *ssl_public_cert_dir* This sets the directory where the _public_ certificates are stored. The default is `/etc/apache2/ssl/public_certs`.
* *ssl_private_key_dir* This sets the directory where the _private_ keys are stored. The default is `/etc/apache2/ssl/private_keys`
* *ssl_public_cert* This is the file name for the public certificate. The default is `${::fqdn}.pem`
* *ssl_private_key* This is the file name for the private key. The default is `${::fqdn}.pem`
* *ssl_ca_chain_cert* This is the file name for the Certificate Authority (CA) chain certificate, which is assumed to be in `ssl_public_cert_dir`. The default is `ca.pem`
* *ssl_ca_cert* This is the file name fot the Certificate Authority (CA) public certificate, which is assumed to be in `ssl_public_cert_dir`. The default is `ca.pem` 
* *sslprotocol* This sets the SSL protocol directive (`SSLProtocol`) to the string passed as a parameter. Defaults to `all`. 
* *ssloptions* This sets the SSL Options deirective (`SSLOptions`) to the string passed as a parameter. Defaults to `false` which omits the `SSLOptions` declaration from the virtual host configuration file.
* *sslciphersuite* This sets the SSL Cipher suite (`SSLCipherSuite`) to the string passed as a parameter. The default is `ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP`
* *sslverifyclient* This sets the SSL client verification declaration (`SSLVerifyClient`) to the string passed as a parameter. Defaults to `none`
* *sslverifydepth* This sets the SSL verification depth declaration (`SSLVerifyDepth`) to the value passed as a parameter. The default value is `1`

How the directories are handled could be better. The defaults should change for different OS and distributions, but this has only been tested on Ubuntu.

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

For details on using the Shibboleth module (a.k.a. `mod_shib`) see README.mod_shib.md

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
