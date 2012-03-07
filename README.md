# Apache Module for Puppet

## Description
This Puppet module allows you to manage vhosts and sites enabled.

## Usage

### apache::vhost
<pre>
  apache::vhost { 'site.name.fqdn':
   priority => '20',
   port     => '80',
   docroot  => '/var/www',
  }
 </pre>

### apache::vhost::proxy
<pre>
  apache::vhost::proxy { 'proxy.name.fqdn':
   priority => '20',
   port     => '80',
   dest     => 'site.fqdn.com',
  }
 </pre>

### apache::vhost::redirect
<pre>
  apache::vhost { 'redirect.name.fqdn':
   port     => '80',
   dest     => 'sites.fqdn.com'
  }
 </pre>
