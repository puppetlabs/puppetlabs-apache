# Shibboleth module for Apache

The module `apache::mod::shib` configures the Apache Shibboleth Service Provider (SP) module in a manner consistent and compatible with the usage of the Puppetlabs Apache Module. Once this module is installed and configured it should just be a matter of specifying `authType shibboleth` in an Apache Virtual Host declaration.

## Shibboleth

Shibboleth is among the world's most widely deployed federated identity solutions, connecting users to applications both within and between organizations. Every software component of the Shibboleth system is free and open source.

Shibboleth is an open-source project that provides Single Sign-On capabilities and allows sites to make informed authorization decisions for individual access of protected on-line resources in a privacy-preserving manner.

* http://shibboleth.net/

# Example Usage

The following is an example installation:

```
# Set up Apache
class{'apache': }
class{'apache::mod::shib': }

# Set up the Shibboleth Single Sign On (sso) module
apache::mod::shib::sso{'Federation_Directory':
  discoveryURL  => 'https://example.federation.org/ds/DS',
}

apache::mod::shib::metadata{'Federation_metadata':
  provider_uri  => 'https://example.federation.org/metadata/fed-metadata-signed.xml',
  cert_uri      => 'http://example.federation.org/metadata/fed-metadata-cert.pem',
}

apache::mod::shib::attribute_map{'Federation_attribute_map':
  attribute_map_uri => 'https://example.federation.org/download/attribute-map.xml',
}

include apache::mod::shib::backend_cert
```
# Example Usage Breakdown

The following sections describe the sequence given in the Example Usage

## Apache and Shibboleth

```
# Set up Apache
class{'apache': }
class{'apache::mod::shib': }
```

Setting up the `apache` class from the PuppetLabs Apache Module is a requirement, no extra configuration is required. It is recommended that the `serveradmin` parameter is set.

This is followed by installing the Shibboleth module (`mod_shib`) for Apache. This provides the absolute minimum installation which could then be configured further with parameters.

## Configure Single Sign On with a Discovery Service

```
# Set up the Shibboleth Single Sign On (SSO) module
apache::mod::shib::sso{'Federation_Directory':
  discoveryURL  => 'https://example.federation.org/ds/DS',
}
```

This snippet sets up a Single Sign On (SSO) service that uses a Directory Service to handle multiple federated Identity Providers (IDp). 

*Note:* The URL is an example only, the Federation should provide the correct URL to use for its directory service.

*Note:* Alternatively if only a single IDp is to be used, use the `idpURL` parameter instead. The `idpURL` and `discoveryURL` parameters are mutually exclusive, the SSO can only use one or the other.

## Federation Metadata and Certificate

```
apache::mod::shib::metadata{'Federation_metadata':
  provider_uri  => 'https://example.federation.org/metadata/fed-metadata-signed.xml',
  cert_uri      => 'http://example.federation.org/metadata/fed-metadata-cert.pem',
}
```

Currently `apache::mod::shib::metadata` only supports a single metadata provider, but it is possible to configure Shibboleth to use multiple metadata in a co-federated environment, hence this has been defined as a resource to permit multiple declarations. This requires two URIs, one to obtain the Federation metadata XML file, and another to obtain the Federation metadata signing certificate.

# Updating the Attribute map

```
apache::mod::shib::attribute_map{'Federation_attribute_map':
  attribute_map_uri => 'https://example.federation.org/download/attribute-map.xml',
}
```

This is optional, and will allow `mod_shib` to use a customised attribute map downloaded from the provided URI. By default this is updated every 21 days. The parameter `max_age` can be used to set the number of days between updates.

# Create the Back-end x509 Certificate

```
include apache::mod::shib::backend_cert
```

This creates a self signed back-end x509 certificate and key with which this Service Provider can be registered with a Federation. This method currently just runs the `shib-keygen` command with the values supplied in the `apache::mod::shib` configuration. This certificate will be regenerated on a new deployment unless it has been saved or backed up. It is recommended that a specified certificate is deployed by Puppet from a private file server, or using a suitable x509 certificate management Puppet Module. Maintaining the back-end certificate is important as this is how a Service Provider identifies itself to other Shibboleth services.

The following snippet uploads a certificate, and uses parameters to configure Shibboleth to use it:

```puppet
class{'apache':
  servername => 'example.com'
}

file{'/etc/shibboleth/example.com.crt':
  ensure => 'file'
  source => 'puppet:///private/example.com.crt'
}

class{'apache::mod::shib':
  shib_sp_cert  => 'example.com.crt'
}
```

# Classes and Resources

The `apache::mod::shib` module provides the following classes and resource definitions:

## Class: `apache::mod::shib`

### Parameters for `apache::mod::shib`

* `shib_admin`      Sets the Shibboleth administrator's email address, defaults to `apache::serveradmin`
* `shib_hostname`   Sets the host name to be used in the Shibboleth configuration, defaults to `fqdn`
* `logoLocation`    Sets the location relative to the web root of the 'logo' to be used on error pages, defaults to `/shibboleth-sp/logo.jpg`
* `styleSheet`      = Sets the location relative to the web root of the CSS style sheet to be used on error pages, defaults to `/shibboleth-sp/main.css`
* `shib_conf_dir`   Sets the directory where the Shibboleth configuration is stored, defaults to `/etc/shibboleth`
* `shib_conf_file`  Sets the name of the Shibboleth configuration file, defaults to `shibboleth2.xml`
* `shib_sp_cert`    Sets the name of the Shibboleth Service Provider back end certificate, defaults to `sp-cert.pem`
* `shib_bin_dir`    Sets the location of the Shibboleth tools (esp. shib-keygen), defaults to  `/usr/sbin`
* `handlerSSL`      Sets the `handlerSSL` attribute in to `true` or `false`, defaults to `true`

## Resource: `apache::mod::shib::attribute_map`

### Parameters for `apache::mod::shib::attribute_map`

* `attribute_map_uri`   Sets the URI for downloading the Attribute map from. There is no default, and this parameter is required.
* `attribute_map_dir`   Sets the directory into which the attribute map is downloaded, defaults to `apache::mod::shib::shib_conf_dir`
* `attribute_map_name`  Sets the file name for the Attribute map file, by default this is extracted from the `attribute_map_uri`
* `max_age`             Sets the maximum age in days for the Attribute map before downloading and replacing it, defaults to `21` days

## Class: `apache::mod::shib::backend_cert`

### Parameters for `apache::mod::shib::backend_cert`

* `sp_hostname`         Set's the hostname used to sign the back-end certifcated, defaults to `apache::mod::shib::shib_hostname`

## Resource: `apache::mod::shib::metadata`

### Parameters for `apache::mod::shib::metadata`

* `provider_uri`            Sets URI for the metadata provider, there is no default and this parameter is required.
* `cert_uri`                Sets the URI for the metadata signing certificate, there is no default and this parameter is required.
* `backing_file_dir`        Sets the directory into which the metadata is downloaded into, defaults to `apache::mod::shib::shib_conf_dir`
* `backing_file_name`       Sets the name of the metadata backing file, by default this is derived from the `provider_uir`
* `cert_dir`                Sets the directory into which the certificate is downloaded into
* `cert_file_name`          Sets the name of the certificate file, by default this is derived from the `cert_uri`
* `provider_type`           Sets the metadata provider type, defaults to 'XML'
* `provider_reload_interval`  Set's the metadata reload interval in seconds, defaults to "7200"
* `metadata_filter_max_validity_interval` Sets the maximum interval for reloading the metadata_filter, defaults to "2419200" seconds

## Resource: `apache::mod::shib::sso`

### Prameters for `apache::mod::shib::sso`
* `discoveryURL`        The URL of the discovery service, is undefined by default
* `idpURL`              The URL of a single IDp, is undefined by default
* `discoveryProtocol`   Sets the discovery protocol for the discovery service provided in the `discoveryURL`, defaults to "SAMLDS",
* `ecp_support`         Sets support for non-web based ECP logins, by default this is `false`

**Note:** Either one of `discoveryURL` or `idpURL` is required, but not both.

# Registration

Manual resgistration of the Service Provider is still required. By default, the file `/etc/shibboleth/sp-cert.pem` contains the public key of the back-end certificate used for secure comminucation within the Shibboleth Federation.

# Attribution

The `apache::mod::shib` Puppet module was created Aaron Hicks (hicksa@landcareresearch.co.nz) for work on the NeSI Project and the Tuakiri New Zealand Access Federation as a fork from the PuppetLabs Apache module on GitHub.

* https://github.com/puppetlabs/puppetlabs-apache
* https://github.com/nesi/puppetlabs-apache
* http://www.nesi.org.nz//
* https://tuakiri.ac.nz/confluence/display/Tuakiri/Home

# Copyright and License

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