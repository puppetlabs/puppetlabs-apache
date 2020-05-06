# @summary
#   Allows specialised configurations for virtual hosts that possess requirements 
#   outside of the defaults.
#
# The apache module allows a lot of flexibility in the setup and configuration of virtual hosts. 
# This flexibility is due, in part, to `vhost` being a defined resource type, which allows Apache 
# to evaluate it multiple times with different parameters.<br />
# The `apache::vhost` defined type allows you to have specialized configurations for virtual hosts 
# that have requirements outside the defaults. You can set up a default virtual host within 
# the base `::apache` class, as well as set a customized virtual host as the default. 
# Customized virtual hosts have a lower numeric `priority` than the base class's, causing 
# Apache to process the customized virtual host first.<br />
# The `apache::vhost` defined type uses `concat::fragment` to build the configuration file. To 
# inject custom fragments for pieces of the configuration that the defined type doesn't 
# inherently support, add a custom fragment.<br />
# For the custom fragment's `order` parameter, the `apache::vhost` defined type uses multiples 
# of 10, so any `order` that isn't a multiple of 10 should work.<br />
# > **Note:** When creating an `apache::vhost`, it cannot be named `default` or `default-ssl`, 
# because vhosts with these titles are always managed by the module. This means that you cannot 
# override `Apache::Vhost['default']`  or `Apache::Vhost['default-ssl]` resources. An optional 
# workaround is to create a vhost named something else, such as `my default`, and ensure that the 
# `default` and `default_ssl` vhosts are set to `false`:
#
# @example
#   class { 'apache':
#     default_vhost     => false,
#     default_ssl_vhost => false,
#   }
#
# @param apache_version
#   Apache's version number as a string, such as '2.2' or '2.4'.
#
# @param access_log
#   Determines whether to configure `*_access.log` directives (`*_file`,`*_pipe`, or `*_syslog`).
# 
# @param access_log_env_var
#   Specifies that only requests with particular environment variables be logged.
# 
# @param access_log_file
#   Sets the filename of the `*_access.log` placed in `logroot`. Given a virtual host ---for 
#   instance, example.com--- it defaults to 'example.com_ssl.log' for 
#   [SSL-encrypted](https://httpd.apache.org/docs/current/ssl/index.html) virtual hosts and 
#   `example.com_access.log` for unencrypted virtual hosts.
# 
# @param access_log_format
#   Specifies the use of either a `LogFormat` nickname or a custom-formatted string for the 
#   access log.
# 
# @param access_log_pipe
#   Specifies a pipe where Apache sends access log messages.
#
# @param access_log_syslog
#   Sends all access log messages to syslog.
#
# @param access_logs
#   Allows you to give a hash that specifies the state of each of the `access_log_*` 
#   directives shown above, i.e. `access_log_pipe` and `access_log_syslog`.
# 
# @param add_default_charset
#   Sets a default media charset value for the `AddDefaultCharset` directive, which is 
#   added to `text/plain` and `text/html` responses.
# 
# @param add_listen
#   Determines whether the virtual host creates a `Listen` statement.<br />
#   Setting `add_listen` to `false` prevents the virtual host from creating a `Listen` 
#   statement. This is important when combining virtual hosts that aren't passed an `ip` 
#   parameter with those that are.
# 
# @param use_optional_includes
#   Specifies whether Apache uses the `IncludeOptional` directive instead of `Include` for 
#   `additional_includes` in Apache 2.4 or newer.
# 
# @param additional_includes
#   Specifies paths to additional static, virtual host-specific Apache configuration files. 
#   You can use this parameter to implement a unique, custom configuration not supported by 
#   this module.
# 
# @param aliases
#   Passes a list of [hashes][hash] to the virtual host to create `Alias`, `AliasMatch`, 
#   `ScriptAlias` or `ScriptAliasMatch` directives as per the `mod_alias` documentation.<br />
#   For example:
#   ``` puppet
#   aliases => [
#     { aliasmatch       => '^/image/(.*)\.jpg$',
#       path             => '/files/jpg.images/$1.jpg',
#     },
#     { alias            => '/image',
#       path             => '/ftp/pub/image',
#     },
#     { scriptaliasmatch => '^/cgi-bin(.*)',
#       path             => '/usr/local/share/cgi-bin$1',
#     },
#     { scriptalias      => '/nagios/cgi-bin/',
#       path             => '/usr/lib/nagios/cgi-bin/',
#     },
#     { alias            => '/nagios',
#       path             => '/usr/share/nagios/html',
#     },
#   ],
#   ```
#   For the `alias`, `aliasmatch`, `scriptalias` and `scriptaliasmatch` keys to work, each needs 
#   a corresponding context, such as `<Directory /path/to/directory>` or 
#   `<Location /some/location/here>`. Puppet creates the directives in the order specified in 
#   the `aliases` parameter. As described in the `mod_alias` documentation, add more specific 
#   `alias`, `aliasmatch`, `scriptalias` or `scriptaliasmatch` parameters before the more 
#   general ones to avoid shadowing.<BR />
#   > **Note**: Use the `aliases` parameter instead of the `scriptaliases` parameter because 
#   you can precisely control the order of various alias directives. Defining `ScriptAliases` 
#   using the `scriptaliases` parameter means *all* `ScriptAlias` directives will come after 
#   *all* `Alias` directives, which can lead to `Alias` directives shadowing `ScriptAlias` 
#   directives. This often causes problems; for example, this could cause problems with Nagios.<BR />
#   If `apache::mod::passenger` is loaded and `PassengerHighPerformance` is `true`, the `Alias` 
#   directive might not be able to honor the `PassengerEnabled => off` statement. See 
#   [this article](http://www.conandalton.net/2010/06/passengerenabled-off-not-working.html) for details.
# 
# @param allow_encoded_slashes
#   Sets the `AllowEncodedSlashes` declaration for the virtual host, overriding the server 
#   default. This modifies the virtual host responses to URLs with `\` and `/` characters. The 
#   default setting omits the declaration from the server configuration and selects the 
#   Apache default setting of `Off`.
# 
# @param block
#   Specifies the list of things to which Apache blocks access. Valid options are: `scm` (which 
#   blocks web access to `.svn`), `.git`, and `.bzr` directories.
# 
# @param cas_attribute_prefix
#   Adds a header with the value of this header being the attribute values when SAML 
#   validation is enabled.
# 
# @param cas_attribute_delimiter
#   Sets the delimiter between attribute values in the header created by `cas_attribute_prefix`.
# 
# @param cas_login_url
#   Sets the URL to which the module redirects users when they attempt to access a 
#   CAS-protected resource and don't have an active session.
# 
# @param cas_root_proxied_as
#   Sets the URL end users see when access to this Apache server is proxied per vhost. 
#   This URL should not include a trailing slash.
# 
# @param cas_scrub_request_headers
#   Remove inbound request headers that may have special meaning within mod_auth_cas.
# 
# @param cas_sso_enabled
#   Enables experimental support for single sign out (may mangle POST data).
# 
# @param cas_validate_saml
#   Parse response from CAS server for SAML.
# 
# @param cas_validate_url
#   Sets the URL to use when validating a client-presented ticket in an HTTP query string.
# 
# @param comment
#   Adds comments to the header of the configuration file. Pass as string or an array of strings.
#   For example:
#   ``` puppet
#   comment => "Account number: 123B",
#   ```
#   Or:
#   ``` puppet
#   comment => [
#     "Customer: X",
#     "Frontend domain: x.example.org",
#   ]
#   ```
# 
# @param custom_fragment
#   Passes a string of custom configuration directives to place at the end of the virtual 
#   host configuration.
# 
# @param default_vhost
#   Sets a given `apache::vhost` defined type as the default to serve requests that do not 
#   match any other `apache::vhost` defined types.
# 
# @param directoryindex
#   Sets the list of resources to look for when a client requests an index of the directory 
#   by specifying a '/' at the end of the directory name. See the `DirectoryIndex` directive 
#   documentation for details.
# 
# @param docroot
#   **Required**.<br />
#   Sets the `DocumentRoot` location, from which Apache serves files.<br />
#   If `docroot` and `manage_docroot` are both set to `false`, no `DocumentRoot` will be set 
#   and the accompanying `<Directory /path/to/directory>` block will not be created.
# 
# @param docroot_group
#   Sets group access to the `docroot` directory.
# 
# @param docroot_owner
#   Sets individual user access to the `docroot` directory.
# 
# @param docroot_mode
#   Sets access permissions for the `docroot` directory, in numeric notation.
# 
# @param manage_docroot
#   Determines whether Puppet manages the `docroot` directory.
# 
# @param error_log
#   Specifies whether `*_error.log` directives should be configured.
# 
# @param error_log_file
#   Points the virtual host's error logs to a `*_error.log` file. If this parameter is 
#   undefined, Puppet checks for values in `error_log_pipe`, then `error_log_syslog`.<br />
#   If none of these parameters is set, given a virtual host `example.com`, Puppet defaults 
#   to `$logroot/example.com_error_ssl.log` for SSL virtual hosts and 
#   `$logroot/example.com_error.log` for non-SSL virtual hosts.
# 
# @param error_log_pipe
#   Specifies a pipe to send error log messages to.<br />
#   This parameter has no effect if the `error_log_file` parameter has a value. If neither 
#   this parameter nor `error_log_file` has a value, Puppet then checks `error_log_syslog`.
# 
# @param error_log_syslog
#   Determines whether to send all error log messages to syslog.
#   This parameter has no effect if either of the `error_log_file` or `error_log_pipe` 
#   parameters has a value. If none of these parameters has a value, given a virtual host 
#   `example.com`, Puppet defaults to `$logroot/example.com_error_ssl.log` for SSL virtual 
#   hosts and `$logroot/example.com_error.log` for non-SSL virtual hosts.
#
# @param error_log_format
#   Sets the [ErrorLogFormat](https://httpd.apache.org/docs/current/mod/core.html#errorlogformat)
#   format specification for error log entries inside virtual host
#   For example:
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     ...
#     error_log_format => [
#       '[%{uc}t] [%-m:%-l] [R:%L] [C:%{C}L] %7F: %E: %M',
#       { '[%{uc}t] [R:%L] Request %k on C:%{c}L pid:%P tid:%T' => 'request' }, 
#       { "[%{uc}t] [R:%L] UA:'%+{User-Agent}i'" => 'request' },
#       { "[%{uc}t] [R:%L] Referer:'%+{Referer}i'" => 'request' },
#       { '[%{uc}t] [C:%{c}L] local\ %a remote\ %A' => 'connection' },
#     ],
#   }
#   ```
# 
# @param error_documents
#   A list of hashes which can be used to override the 
#   [ErrorDocument](https://httpd.apache.org/docs/current/mod/core.html#errordocument) 
#   settings for this virtual host.<br />
#   For example:
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     error_documents => [
#       { 'error_code' => '503', 'document' => '/service-unavail' },
#       { 'error_code' => '407', 'document' => 'https://example.com/proxy/login' },
#     ],
#   }
#   ```
# 
# @param ensure
#   Specifies if the virtual host is present or absent.<br />
# 
# @param fallbackresource
#   Sets the [FallbackResource](https://httpd.apache.org/docs/current/mod/mod_dir.html#fallbackresource) 
#   directive, which specifies an action to take for any URL that doesn't map to anything in 
#   your filesystem and would otherwise return 'HTTP 404 (Not Found)'. Values must either begin 
#   with a `/` or be `disabled`.
# 
# @param fastcgi_server
#   Specify an external FastCGI server to manage a connection to.
# 
# @param fastcgi_socket
#   Specify the socket that will be used to communicate with an external FastCGI server.
# 
# @param fastcgi_idle_timeout
#   If using fastcgi, this option sets the timeout for the server to respond.
# 
# @param fastcgi_dir
#   Specify an internal FastCGI directory that is to be managed.
# 
# @param filters
#   [Filters](https://httpd.apache.org/docs/current/mod/mod_filter.html) enable smart, 
#   context-sensitive configuration of output content filters.
#   ``` puppet
#   apache::vhost { "$::fqdn":
#     filters => [
#       'FilterDeclare   COMPRESS',
#       'FilterProvider  COMPRESS DEFLATE resp=Content-Type $text/html',
#       'FilterChain     COMPRESS',
#       'FilterProtocol  COMPRESS DEFLATE change=yes;byteranges=no',
#     ],
#   }
#   ```
# 
# @param h2_copy_files
#   Sets the [H2CopyFiles](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2copyfiles)
#   directive which influences how the requestion process pass files to the main connection.
# 
# @param h2_direct
#   Sets the [H2Direct](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2direct)
#   directive which toggles the usage of the HTTP/2 Direct Mode.
# 
# @param h2_early_hints
#   Sets the [H2EarlyHints](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2earlyhints)
#   directive which controls if HTTP status 103 interim responses are forwarded to
#   the client or not.
# 
# @param h2_max_session_streams
#   Sets the [H2MaxSessionStreams](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2maxsessionstreams)
#   directive which sets the maximum number of active streams per HTTP/2 session
#   that the server allows.
# 
# @param h2_modern_tls_only
#   Sets the [H2ModernTLSOnly](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2moderntlsonly)
#   directive which toggles the security checks on HTTP/2 connections in TLS mode.
# 
# @param h2_push
#   Sets the [H2Push](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2push)
#   directive which toggles the usage of the HTTP/2 server push protocol feature.
# 
# @param h2_push_diary_size
#   Sets the [H2PushDiarySize](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2pushdiarysize)
#   directive which toggles the maximum number of HTTP/2 server pushes that are
#   remembered per HTTP/2 connection.
# 
# @param h2_push_priority
#   Sets the [H2PushPriority](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2pushpriority)
#   directive which defines the priority handling of pushed responses based on the
#   content-type of the response.
# 
# @param h2_push_resource
#   Sets the [H2PushResource](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2pushresource)
#   directive which declares resources for early pushing to the client.
# 
# @param h2_serialize_headers
#   Sets the [H2SerializeHeaders](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2serializeheaders)
#   directive which toggles if HTTP/2 requests are serialized in HTTP/1.1
#   format for processing by httpd core.
# 
# @param h2_stream_max_mem_size
#   Sets the [H2StreamMaxMemSize](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2streammaxmemsize)
#   directive which sets the maximum number of outgoing data bytes buffered in
#   memory for an active stream.
# 
# @param h2_tls_cool_down_secs
#   Sets the [H2TLSCoolDownSecs](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2tlscooldownsecs)
#   directive which sets the number of seconds of idle time on a TLS connection
#   before the TLS write size falls back to a small (~1300 bytes) length.
# 
# @param h2_tls_warm_up_size
#   Sets the [H2TLSWarmUpSize](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2tlswarmupsize)
#   directive which sets the number of bytes to be sent in small TLS records (~1300
#   bytes) until doing maximum sized writes (16k) on https: HTTP/2 connections.
# 
# @param h2_upgrade
#   Sets the [H2Upgrade](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2upgrade)
#   directive which toggles the usage of the HTTP/1.1 Upgrade method for switching
#   to HTTP/2.
# 
# @param h2_window_size
#   Sets the [H2WindowSize](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2windowsize)
#   directive which sets the size of the window that is used for flow control from
#   client to server and limits the amount of data the server has to buffer.
# 
# @param headers
#   Adds lines to replace, merge, or remove response headers. See 
#   [Apache's mod_headers documentation](https://httpd.apache.org/docs/current/mod/mod_headers.html#header) for more information.
# 
# @param ip
#   Sets the IP address the virtual host listens on. By default, uses Apache's default behavior 
#   of listening on all IPs.
# 
# @param ip_based
#   Enables an [IP-based](https://httpd.apache.org/docs/current/vhosts/ip-based.html) virtual 
#   host. This parameter inhibits the creation of a NameVirtualHost directive, since those are 
#   used to funnel requests to name-based virtual hosts.
# 
# @param itk
#   Configures [ITK](http://mpm-itk.sesse.net/) in a hash.<br />
#   Usage typically looks something like:
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     docroot => '/path/to/directory',
#     itk     => {
#       user  => 'someuser',
#       group => 'somegroup',
#     },
#   }
#   ```
#   Valid values are: a hash, which can include the keys:
#   * `user` + `group`
#   * `assignuseridexpr`
#   * `assigngroupidexpr`
#   * `maxclientvhost`
#   * `nice`
#   * `limituidrange` (Linux 3.5.0 or newer)
#   * `limitgidrange` (Linux 3.5.0 or newer)
# 
# @param action
#   Specifies whether you wish to configure mod_actions action directive which will
#   activate cgi-script when triggered by a request.
# 
# @param jk_mounts
#   Sets up a virtual host with `JkMount` and `JkUnMount` directives to handle the paths 
#   for URL mapping between Tomcat and Apache.<br />
#   The parameter must be an array of hashes where each hash must contain the `worker` 
#   and either the `mount` or `unmount` keys.<br />
#   Usage typically looks like:
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     jk_mounts => [
#       { mount   => '/*',     worker => 'tcnode1', },
#       { unmount => '/*.jpg', worker => 'tcnode1', },
#     ],
#   }
#   ```
# 
# @param http_protocol_options
#   Specifies the strictness of HTTP protocol checks.
# 
# @param keepalive
#   Determines whether to enable persistent HTTP connections with the `KeepAlive` directive 
#   for the virtual host. By default, the global, server-wide `KeepAlive` setting is in effect.<br />
#   Use the `keepalive_timeout` and `max_keepalive_requests` parameters to set relevant options 
#   for the virtual host.
# 
# @param keepalive_timeout
#   Sets the `KeepAliveTimeout` directive for the virtual host, which determines the amount 
#   of time to wait for subsequent requests on a persistent HTTP connection. By default, the 
#   global, server-wide `KeepAlive` setting is in effect.<br />
#   This parameter is only relevant if either the global, server-wide `keepalive` parameter or 
#   the per-vhost `keepalive` parameter is enabled.
# 
# @param max_keepalive_requests
#   Limits the number of requests allowed per connection to the virtual host. By default,  
#   the global, server-wide `KeepAlive` setting is in effect.<br />
#   This parameter is only relevant if either the global, server-wide `keepalive` parameter or 
#   the per-vhost `keepalive` parameter is enabled.
# 
# @param auth_kerb
#   Enable `mod_auth_kerb` parameters for a virtual host.<br />
#   Usage typically looks like:
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     auth_kerb              => `true`,
#     krb_method_negotiate   => 'on',
#     krb_auth_realms        => ['EXAMPLE.ORG'],
#     krb_local_user_mapping => 'on',
#     directories            => {
#       path         => '/var/www/html',
#       auth_name    => 'Kerberos Login',
#       auth_type    => 'Kerberos',
#       auth_require => 'valid-user',
#     },
#   }
#   ```
# 
# @param krb_method_negotiate
#   Determines whether to use the Negotiate method.
# 
# @param krb_method_k5passwd
#   Determines whether to use password-based authentication for Kerberos v5.
# 
# @param krb_authoritative
#   If set to `off`, authentication controls can be passed on to another module.
# 
# @param krb_auth_realms
#   Specifies an array of Kerberos realms to use for authentication.
# 
# @param krb_5keytab
#   Specifies the Kerberos v5 keytab file's location.
# 
# @param krb_local_user_mapping
#   Strips @REALM from usernames for further use.
# 
# @param krb_verify_kdc
#   This option can be used to disable the verification tickets against local keytab to prevent 
#   KDC spoofing attacks.
# 
# @param krb_servicename
#   Specifies the service name that will be used by Apache for authentication. Corresponding 
#   key of this name must be stored in the keytab.
# 
# @param krb_save_credentials
#   This option enables credential saving functionality.
# 
# @param logroot
#   Specifies the location of the virtual host's logfiles.
# 
# @param logroot_ensure
#   Determines whether or not to remove the logroot directory for a virtual host.
# 
# @param logroot_mode
#   Overrides the mode the logroot directory is set to. Do *not* grant write access to the 
#   directory the logs are stored in without being aware of the consequences; for more 
#   information, see [Apache's log security documentation](https://httpd.apache.org/docs/2.4/logs.html#security).
# 
# @param logroot_owner
#   Sets individual user access to the logroot directory.
# 
# @param logroot_group
#   Sets group access to the `logroot` directory.
# 
# @param log_level
#   Specifies the verbosity of the error log.
# 
# @param modsec_body_limit
#   Configures the maximum request body size (in bytes) ModSecurity accepts for buffering.
# 
# @param modsec_disable_vhost
#   Disables `mod_security` on a virtual host. Only valid if `apache::mod::security` is included.
# 
# @param modsec_disable_ids
#   Removes `mod_security` IDs from the virtual host.<br />
#   Also takes a hash allowing removal of an ID from a specific location.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     modsec_disable_ids => [ 90015, 90016 ],
#   }
#   ```
# 
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     modsec_disable_ids => { '/location1' => [ 90015, 90016 ] },
#   }
#   ```
# 
# @param modsec_disable_ips
#   Specifies an array of IP addresses to exclude from `mod_security` rule matching.
# 
# @param modsec_disable_msgs
#   Array of mod_security Msgs to remove from the virtual host. Also takes a hash allowing 
#   removal of an Msg from a specific location.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     modsec_disable_msgs => ['Blind SQL Injection Attack', 'Session Fixation Attack'],
#   }
#   ```
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     modsec_disable_msgs => { '/location1' => ['Blind SQL Injection Attack', 'Session Fixation Attack'] },
#   }
#   ```
# 
# @param modsec_disable_tags
#   Array of mod_security Tags to remove from the virtual host. Also takes a hash allowing 
#   removal of an Tag from a specific location.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     modsec_disable_tags => ['WEB_ATTACK/SQL_INJECTION', 'WEB_ATTACK/XSS'],
#   }
#   ```
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     modsec_disable_tags => { '/location1' => ['WEB_ATTACK/SQL_INJECTION', 'WEB_ATTACK/XSS'] },
#   }
#   ```
# 
# @param modsec_audit_log_file
#   If set, it is relative to `logroot`.<br />
#   One of the parameters that determines how to send `mod_security` audit 
#   log ([SecAuditLog](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual#SecAuditLog)).
#   If none of those parameters are set, the global audit log is used 
#   (`/var/log/httpd/modsec\_audit.log`; Debian and derivatives: `/var/log/apache2/modsec\_audit.log`; others: ).
# 
# @param modsec_audit_log_pipe
#   If `modsec_audit_log_pipe` is set, it should start with a pipe. Example 
#   `|/path/to/mlogc /path/to/mlogc.conf`.<br />
#   One of the parameters that determines how to send `mod_security` audit 
#   log ([SecAuditLog](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual#SecAuditLog)).
#   If none of those parameters are set, the global audit log is used 
#   (`/var/log/httpd/modsec\_audit.log`; Debian and derivatives: `/var/log/apache2/modsec\_audit.log`; others: ).
# 
# @param modsec_audit_log
#   If `modsec_audit_log` is `true`, given a virtual host ---for instance, example.com--- it 
#   defaults to `example.com\_security\_ssl.log` for SSL-encrypted virtual hosts 
#   and `example.com\_security.log` for unencrypted virtual hosts.<br />
#   One of the parameters that determines how to send `mod_security` audit 
#   log ([SecAuditLog](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual#SecAuditLog)).<br />
#   If none of those parameters are set, the global audit log is used 
#   (`/var/log/httpd/modsec\_audit.log`; Debian and derivatives: `/var/log/apache2/modsec\_audit.log`; others: ).
# 
# @param no_proxy_uris
#   Specifies URLs you do not want to proxy. This parameter is meant to be used in combination 
#   with [`proxy_dest`](#proxy_dest).
# 
# @param no_proxy_uris_match
#   This directive is equivalent to `no_proxy_uris`, but takes regular expressions.
# 
# @param proxy_preserve_host
#   Sets the [ProxyPreserveHost Directive](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypreservehost).<br />
#   Setting this parameter to `true` enables the `Host:` line from an incoming request to be 
#   proxied to the host instead of hostname. Setting it to `false` sets this directive to 'Off'.
# 
# @param proxy_add_headers
#   Sets the [ProxyAddHeaders Directive](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxyaddheaders).<br />
#   This parameter controlls whether proxy-related HTTP headers (X-Forwarded-For, 
#   X-Forwarded-Host and X-Forwarded-Server) get sent to the backend server.
# 
# @param proxy_error_override
#   Sets the [ProxyErrorOverride Directive](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxyerroroverride). 
#   This directive controls whether Apache should override error pages for proxied content.
# 
# @param options
#   Sets the `Options` for the specified virtual host. For example:
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     options => ['Indexes','FollowSymLinks','MultiViews'],
#   }
#   ```
#   > **Note**: If you use the `directories` parameter of `apache::vhost`, 'Options', 
#   'Override', and 'DirectoryIndex' are ignored because they are parameters within `directories`.
# 
# @param override
#   Sets the overrides for the specified virtual host. Accepts an array of 
#   [AllowOverride](https://httpd.apache.org/docs/current/mod/core.html#allowoverride) arguments.
#
# @param passenger_enabled
#   Sets the value for the [PassengerEnabled](http://www.modrails.com/documentation/Users%20guide%20Apache.html#PassengerEnabled) 
#   directive to `on` or `off`. Requires `apache::mod::passenger` to be included.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     docroot     => '/path/to/directory',
#     directories => [
#       { path              => '/path/to/directory',
#         passenger_enabled => 'on',
#       },
#     ],
#   }
#   ```
#   > **Note:** There is an [issue](http://www.conandalton.net/2010/06/passengerenabled-off-not-working.html) 
#   using the PassengerEnabled directive with the PassengerHighPerformance directive.
# 
# @param passenger_base_uri
#   Sets [PassengerBaseURI](https://www.phusionpassenger.com/library/config/apache/reference/#passengerbase_rui), 
#    to specify that the given URI is a distinct application served by Passenger.
# 
# @param passenger_ruby
#   Sets [PassengerRuby](https://www.phusionpassenger.com/library/config/apache/reference/#passengerruby), 
#   specifying the Ruby interpreter to use when serving the relevant web applications.
# 
# @param passenger_python
#   Sets [PassengerPython](https://www.phusionpassenger.com/library/config/apache/reference/#passengerpython), 
#   specifying the Python interpreter to use when serving the relevant web applications.
# 
# @param passenger_nodejs
#   Sets the [`PassengerNodejs`](https://www.phusionpassenger.com/library/config/apache/reference/#passengernodejs), 
#   specifying Node.js command to use when serving the relevant web applications.
# 
# @param passenger_meteor_app_settings
#   Sets [PassengerMeteorAppSettings](https://www.phusionpassenger.com/library/config/apache/reference/#passengermeteorappsettings), 
#   specifying a JSON file with settings for the application when using a Meteor 
#   application in non-bundled mode.
# 
# @param passenger_app_env
#   Sets [PassengerAppEnv](https://www.phusionpassenger.com/library/config/apache/reference/#passengerappenv), 
#   the environment for the Passenger application. If not specified, defaults to the global 
#   setting or 'production'.
# 
# @param passenger_app_root
#   Sets [PassengerRoot](https://www.phusionpassenger.com/library/config/apache/reference/#passengerapproot), 
#   the location of the Passenger application root if different from the DocumentRoot.
# 
# @param passenger_app_group_name
#   Sets [PassengerAppGroupName](https://www.phusionpassenger.com/library/config/apache/reference/#passengerappgroupname), 
#    the name of the application group that the current application should belong to.
# 
# @param passenger_app_type
#   Sets [PassengerAppType](https://www.phusionpassenger.com/library/config/apache/reference/#passengerapptype), 
#    to force Passenger to recognize the application as a specific type.
# 
# @param passenger_startup_file
#   Sets the [PassengerStartupFile](https://www.phusionpassenger.com/library/config/apache/reference/#passengerstartupfile) 
#   path. This path is relative to the application root.
# 
# @param passenger_restart_dir
#   Sets the [PassengerRestartDir](https://www.phusionpassenger.com/library/config/apache/reference/#passengerrestartdir) 
#    to customize the directory in which `restart.txt` is searched for.
# 
# @param passenger_spawn_method
#   Sets [PassengerSpawnMethod](https://www.phusionpassenger.com/library/config/apache/reference/#passengerspawnmethod), 
#   whether Passenger spawns applications directly, or using a prefork copy-on-write mechanism.
# 
# @param passenger_load_shell_envvars
#   Sets [PassengerLoadShellEnvvars](https://www.phusionpassenger.com/library/config/apache/reference/#passengerloadshellenvvars), 
#   to enable or disable the loading of shell environment variables before spawning the application.
# 
# @param passenger_rolling_restarts
#   Sets [PassengerRollingRestarts](https://www.phusionpassenger.com/library/config/apache/reference/#passengerrollingrestarts), 
#   to enable or disable support for zero-downtime application restarts through `restart.txt`.
# 
# @param passenger_resist_deployment_errors
#   Sets [PassengerResistDeploymentErrors](https://www.phusionpassenger.com/library/config/apache/reference/#passengerresistdeploymenterrors), 
#   to enable or disable resistance against deployment errors.
# 
# @param passenger_user
#   Sets [PassengerUser](https://www.phusionpassenger.com/library/config/apache/reference/#passengeruser), 
#   the running user for sandboxing applications.
# 
# @param passenger_group
#   Sets [PassengerGroup](https://www.phusionpassenger.com/library/config/apache/reference/#passengergroup), 
#   the running group for sandboxing applications.
# 
# @param passenger_friendly_error_pages
#   Sets [PassengerFriendlyErrorPages](https://www.phusionpassenger.com/library/config/apache/reference/#passengerfriendlyerrorpages), 
#   which can display friendly error pages whenever an application fails to start. This 
#   friendly error page presents the startup error message, some suggestions for solving 
#   the problem, a backtrace and a dump of the environment variables.
# 
# @param passenger_min_instances
#   Sets [PassengerMinInstances](https://www.phusionpassenger.com/library/config/apache/reference/#passengermininstances), 
#   the minimum number of application processes to run.
# 
# @param passenger_max_instances
#   Sets [PassengerMaxInstances](https://www.phusionpassenger.com/library/config/apache/reference/#passengermaxinstances), 
#   the maximum number of application processes to run.
# 
# @param passenger_max_preloader_idle_time
#   Sets [PassengerMaxPreloaderIdleTime](https://www.phusionpassenger.com/library/config/apache/reference/#passengermaxpreloaderidletime), 
#   the maximum amount of time the preloader waits before shutting down an idle process.
# 
# @param passenger_force_max_concurrent_requests_per_process
#   Sets [PassengerForceMaxConcurrentRequestsPerProcess](https://www.phusionpassenger.com/library/config/apache/reference/#passengerforcemaxconcurrentrequestsperprocess), 
#   the maximum amount of concurrent requests the application can handle per process.
# 
# @param passenger_start_timeout
#   Sets [PassengerStartTimeout](https://www.phusionpassenger.com/library/config/apache/reference/#passengerstarttimeout), 
#   the timeout for the application startup.
# 
# @param passenger_concurrency_model
#   Sets [PassengerConcurrencyModel](https://www.phusionpassenger.com/library/config/apache/reference/#passengerconcurrencyodel), 
#   to specify the I/O concurrency model that should be used for Ruby application processes. 
#   Passenger supports two concurrency models:<br />
#   * `process` – single-threaded, multi-processed I/O concurrency.
#   * `thread` – multi-threaded, multi-processed I/O concurrency.
# 
# @param passenger_thread_count
#   Sets [PassengerThreadCount](https://www.phusionpassenger.com/library/config/apache/reference/#passengerthreadcount), 
#   the number of threads that Passenger should spawn per Ruby application process.<br />
#   This option only has effect if PassengerConcurrencyModel is `thread`.
# 
# @param passenger_max_requests
#   Sets [PassengerMaxRequests](https://www.phusionpassenger.com/library/config/apache/reference/#passengermaxrequests), 
#   the maximum number of requests an application process will process.
# 
# @param passenger_max_request_time
#   Sets [PassengerMaxRequestTime](https://www.phusionpassenger.com/library/config/apache/reference/#passengermaxrequesttime), 
#   the maximum amount of time, in seconds, that an application process may take to 
#   process a request.
# 
# @param passenger_memory_limit
#   Sets [PassengerMemoryLimit](https://www.phusionpassenger.com/library/config/apache/reference/#passengermemorylimit), 
#   the maximum amount of memory that an application process may use, in megabytes.
# 
# @param passenger_stat_throttle_rate
#   Sets [PassengerStatThrottleRate](https://www.phusionpassenger.com/library/config/apache/reference/#passengerstatthrottlerate), 
#   to set a limit, in seconds, on how often Passenger will perform it's filesystem checks.
# 
# @param passenger_pre_start
#   Sets [PassengerPreStart](https://www.phusionpassenger.com/library/config/apache/reference/#passengerprestart), 
#   the URL of the application if pre-starting is required.
# 
# @param passenger_high_performance
#   Sets [PassengerHighPerformance](https://www.phusionpassenger.com/library/config/apache/reference/#passengerhighperformance), 
#   to enhance performance in return for reduced compatibility.
# 
# @param passenger_buffer_upload
#   Sets [PassengerBufferUpload](https://www.phusionpassenger.com/library/config/apache/reference/#passengerbufferupload),
#   to buffer HTTP client request bodies before they are sent to the application.
# 
# @param passenger_buffer_response
#   Sets [PassengerBufferResponse](https://www.phusionpassenger.com/library/config/apache/reference/#passengerbufferresponse),
#   to buffer Happlication-generated responses.
# 
# @param passenger_error_override
#   Sets [PassengerErrorOverride](https://www.phusionpassenger.com/library/config/apache/reference/#passengererroroverride),
#   to specify whether Apache will intercept and handle response with HTTP status codes of
#   400 and higher.
# 
# @param passenger_max_request_queue_size
#   Sets [PassengerMaxRequestQueueSize](https://www.phusionpassenger.com/library/config/apache/reference/#passengermaxrequestqueuesize),
#   to specify the maximum amount of requests that are allowed to queue whenever the maximum
#   concurrent request limit is reached. If the queue is already at this specified limit, then 
#   Passenger immediately sends a "503 Service Unavailable" error to any incoming requests.<br />
#   A value of 0 means that the queue size is unbounded.
# 
# @param passenger_max_request_queue_time
#   Sets [PassengerMaxRequestQueueTime](https://www.phusionpassenger.com/library/config/apache/reference/#passengermaxrequestqueuetime),
#   to specify the maximum amount of time that requests are allowed to stay in the queue 
#   whenever the maximum concurrent request limit is reached. If a request reaches this specified 
#   limit, then Passenger immeaditly sends a "504 Gateway Timeout" error for that request.<br />
#   A value of 0 means that the queue time is unbounded.
# 
# @param passenger_sticky_sessions
#   Sets [PassengerStickySessions](https://www.phusionpassenger.com/library/config/apache/reference/#passengerstickysessions), 
#   to specify that, whenever possible, all requests sent by a client will be routed to the same 
#   originating application process.
# 
# @param passenger_sticky_sessions_cookie_name
#   Sets [PassengerStickySessionsCookieName](https://www.phusionpassenger.com/library/config/apache/reference/#passengerstickysessionscookiename), 
#   to specify the name of the sticky sessions cookie.
# 
# @param passenger_allow_encoded_slashes
#   Sets [PassengerAllowEncodedSlashes](https://www.phusionpassenger.com/library/config/apache/reference/#passengerallowencodedslashes), 
#   to allow URLs with encoded slashes. Please note that this feature will not work properly
#   unless Apache's `AllowEncodedSlashes` is also enabled.
# 
# @param passenger_debugger
#   Sets [PassengerDebugger](https://www.phusionpassenger.com/library/config/apache/reference/#passengerdebugger), 
#   to turn support for Ruby application debugging on or off. 
# 
# @param passenger_lve_min_uid
#   Sets [PassengerLveMinUid](https://www.phusionpassenger.com/library/config/apache/reference/#passengerlveminuid), 
#   to only allow the spawning of application processes with UIDs equal to, or higher than, this 
#   specified value on LVE-enabled kernels.
# 
# @param php_values
#   Allows per-virtual host setting [`php_value`s](http://php.net/manual/en/configuration.changes.php). 
#   These flags or values can be overwritten by a user or an application.
#   Within a vhost declaration:
#   ``` puppet
#     php_values    => [ 'include_path ".:/usr/local/example-app/include"' ],
#   ```
#
# @param php_flags
#   Allows per-virtual host setting [`php_flags\``](http://php.net/manual/en/configuration.changes.php). 
#   These flags or values can be overwritten by a user or an application.
#
# @param php_admin_values
#   Allows per-virtual host setting [`php_admin_value`](http://php.net/manual/en/configuration.changes.php). 
#   These flags or values cannot be overwritten by a user or an application.
#
# @param php_admin_flags
#   Allows per-virtual host setting [`php_admin_flag`](http://php.net/manual/en/configuration.changes.php). 
#   These flags or values cannot be overwritten by a user or an application.
#
# @param port
#   Sets the port the host is configured on. The module's defaults ensure the host listens 
#   on port 80 for non-SSL virtual hosts and port 443 for SSL virtual hosts. The host only 
#   listens on the port set in this parameter.
#
# @param priority
#   Sets the relative load-order for Apache HTTPD VirtualHost configuration files.<br />
#   If nothing matches the priority, the first name-based virtual host is used. Likewise, 
#   passing a higher priority causes the alphabetically first name-based virtual host to be 
#   used if no other names match.<br />
#   > **Note:** You should not need to use this parameter. However, if you do use it, be 
#   aware that the `default_vhost` parameter for `apache::vhost` passes a priority of '15'.<br />
#   To omit the priority prefix in file names, pass a priority of `false`.
#
# @param protocols
#   Sets the [Protocols](https://httpd.apache.org/docs/current/en/mod/core.html#protocols) 
#   directive, which lists available protocols for the virutal host.
#
# @param protocols_honor_order
#   Sets the [ProtocolsHonorOrder](https://httpd.apache.org/docs/current/en/mod/core.html#protocolshonororder) 
#   directive which determines wether the order of Protocols sets precedence during negotiation.
#
# @param proxy_dest
#   Specifies the destination address of a [ProxyPass](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass) configuration.
#
# @param proxy_pass
#   Specifies an array of `path => URI` values for a [ProxyPass](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypass) 
#   configuration. Optionally, parameters can be added as an array.
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     proxy_pass => [
#       { 'path' => '/a', 'url' => 'http://backend-a/' },
#       { 'path' => '/b', 'url' => 'http://backend-b/' },
#       { 'path' => '/c', 'url' => 'http://backend-a/c', 'params' => {'max'=>20, 'ttl'=>120, 'retry'=>300}},
#       { 'path' => '/l', 'url' => 'http://backend-xy',
#         'reverse_urls' => ['http://backend-x', 'http://backend-y'] },
#       { 'path' => '/d', 'url' => 'http://backend-a/d',
#         'params' => { 'retry' => '0', 'timeout' => '5' }, },
#       { 'path' => '/e', 'url' => 'http://backend-a/e',
#         'keywords' => ['nocanon', 'interpolate'] },
#       { 'path' => '/f', 'url' => 'http://backend-f/',
#         'setenv' => ['proxy-nokeepalive 1','force-proxy-request-1.0 1']},
#       { 'path' => '/g', 'url' => 'http://backend-g/',
#         'reverse_cookies' => [{'path' => '/g', 'url' => 'http://backend-g/',}, {'domain' => 'http://backend-g', 'url' => 'http:://backend-g',},], },
#       { 'path' => '/h', 'url' => 'http://backend-h/h',
#         'no_proxy_uris' => ['/h/admin', '/h/server-status'] },
#     ],
#   }
#   ```
#   * `reverse_urls`. *Optional.* This setting is useful when used with `mod_proxy_balancer`. Values: an array or string.
#   * `reverse_cookies`. *Optional.* Sets `ProxyPassReverseCookiePath` and `ProxyPassReverseCookieDomain`.
#   * `params`. *Optional.* Allows for ProxyPass key-value parameters, such as connection settings.
#   * `setenv`. *Optional.* Sets [environment variables](https://httpd.apache.org/docs/current/mod/mod_proxy.html#envsettings) for the proxy directive. Values: array.
#
# @param proxy_dest_match
#   This directive is equivalent to `proxy_dest`, but takes regular expressions, see 
#   [ProxyPassMatch](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassmatch) 
#   for details.
#
# @param proxy_dest_reverse_match
#   Allows you to pass a ProxyPassReverse if `proxy_dest_match` is specified. See 
#   [ProxyPassReverse](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassreverse) 
#   for details.
#
# @param proxy_pass_match
#   This directive is equivalent to `proxy_pass`, but takes regular expressions, see 
#   [ProxyPassMatch](https://httpd.apache.org/docs/current/mod/mod_proxy.html#proxypassmatch) 
#   for details.
#
# @param redirect_dest
#   Specifies the address to redirect to.
#
# @param redirect_source
#   Specifies the source URIs that redirect to the destination specified in `redirect_dest`. 
#   If more than one item for redirect is supplied, the source and destination must be the same 
#   length, and the items are order-dependent.
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     redirect_source => ['/images','/downloads'],
#     redirect_dest   => ['http://img.example.com/','http://downloads.example.com/'],
#   }
#   ```
#
# @param redirect_status
#   Specifies the status to append to the redirect.
#   ``` puppet
#     apache::vhost { 'site.name.fdqn':
#     …
#     redirect_status => ['temp','permanent'],
#   }
#   ```
#
# @param redirectmatch_regexp
#   Determines which server status should be raised for a given regular expression 
#   and where to forward the user to. Entered as an array alongside redirectmatch_status 
#   and redirectmatch_dest.
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     redirectmatch_status => ['404','404'],
#     redirectmatch_regexp => ['\.git(/.*|$)/','\.svn(/.*|$)'],
#     redirectmatch_dest => ['http://www.example.com/$1','http://www.example.com/$2'],
#   }
#   ```
#
# @param redirectmatch_status
#   Determines which server status should be raised for a given regular expression 
#   and where to forward the user to. Entered as an array alongside redirectmatch_regexp 
#   and redirectmatch_dest.
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     redirectmatch_status => ['404','404'],
#     redirectmatch_regexp => ['\.git(/.*|$)/','\.svn(/.*|$)'],
#     redirectmatch_dest => ['http://www.example.com/$1','http://www.example.com/$2'],
#   }
#   ```
#
# @param redirectmatch_dest
#   Determines which server status should be raised for a given regular expression 
#   and where to forward the user to. Entered as an array alongside redirectmatch_status 
#   and redirectmatch_regexp.
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     redirectmatch_status => ['404','404'],
#     redirectmatch_regexp => ['\.git(/.*|$)/','\.svn(/.*|$)'],
#     redirectmatch_dest => ['http://www.example.com/$1','http://www.example.com/$2'],
#   }
#   ```
#
# @param request_headers
#   Modifies collected [request headers](https://httpd.apache.org/docs/current/mod/mod_headers.html#requestheader) 
#   in various ways, including adding additional request headers, removing request headers, 
#   and so on.
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     request_headers => [
#       'append MirrorID "mirror 12"',
#       'unset MirrorID',
#     ],
#   }
#   ```
#
# @param rewrites
#   Creates URL rewrite rules. Expects an array of hashes.<br />
#   Valid Hash keys include `comment`, `rewrite_base`, `rewrite_cond`, `rewrite_rule`
#   or `rewrite_map`.<br />
#   For example, you can specify that anyone trying to access index.html is served welcome.html
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     rewrites => [ { rewrite_rule => ['^index\.html$ welcome.html'] } ]
#   }
#   ```
#   The parameter allows rewrite conditions that, when `true`, execute the associated rule. 
#   For instance, if you wanted to rewrite URLs only if the visitor is using IE
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     rewrites => [
#       {
#         comment      => 'redirect IE',
#         rewrite_cond => ['%{HTTP_USER_AGENT} ^MSIE'],
#         rewrite_rule => ['^index\.html$ welcome.html'],
#       },
#     ],
#   }
#   ```
#   You can also apply multiple conditions. For instance, rewrite index.html to welcome.html 
#   only when the browser is Lynx or Mozilla (version 1 or 2)
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     rewrites => [
#       {
#         comment      => 'Lynx or Mozilla v1/2',
#         rewrite_cond => ['%{HTTP_USER_AGENT} ^Lynx/ [OR]', '%{HTTP_USER_AGENT} ^Mozilla/[12]'],
#         rewrite_rule => ['^index\.html$ welcome.html'],
#       },
#     ],
#   }
#   ```
#   Multiple rewrites and conditions are also possible
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     rewrites => [
#       {
#         comment      => 'Lynx or Mozilla v1/2',
#         rewrite_cond => ['%{HTTP_USER_AGENT} ^Lynx/ [OR]', '%{HTTP_USER_AGENT} ^Mozilla/[12]'],
#         rewrite_rule => ['^index\.html$ welcome.html'],
#       },
#       {
#         comment      => 'Internet Explorer',
#         rewrite_cond => ['%{HTTP_USER_AGENT} ^MSIE'],
#         rewrite_rule => ['^index\.html$ /index.IE.html [L]'],
#       },
#       {
#         rewrite_base => /apps/,
#         rewrite_rule => ['^index\.cgi$ index.php', '^index\.html$ index.php', '^index\.asp$ index.html'],
#       },
#       { comment      => 'Rewrite to lower case',
#         rewrite_cond => ['%{REQUEST_URI} [A-Z]'],
#         rewrite_map  => ['lc int:tolower'],
#         rewrite_rule => ['(.*) ${lc:$1} [R=301,L]'],
#       },
#     ],
#   }
#   ```
#   Refer to the [`mod_rewrite` documentation](https://httpd.apache.org/docs/2.4/mod/mod_rewrite.html)
#   for more details on what is possible with rewrite rules and conditions.<br />
#   > **Note**: If you include rewrites in your directories, also include `apache::mod::rewrite` 
#   and consider setting the rewrites using the `rewrites` parameter in `apache::vhost` rather 
#   than setting the rewrites in the virtual host's directories.
#
# @param rewrite_base
#   The parameter [`rewrite_base`](https://httpd.apache.org/docs/current/mod/mod_rewrite.html#rewritebase)
#   specifies the URL prefix to be used for per-directory (htaccess) RewriteRule directives
#   that substitue a relative path.
# 
# @param rewrite_rule
#   The parameter [`rewrite_rile`](https://httpd.apache.org/docs/current/mod/mod_rewrite.html#rewriterule)
#   allows the user to define the rules that will be used by the rewrite engine.
# 
# @param rewrite_cond
#   The parameter [`rewrite_cond`](https://httpd.apache.org/docs/current/mod/mod_rewrite.html#rewritecond)
#   defines a rule condition, that when satisfied will implement that rule within the 
#   rewrite engine.
#
# @param rewrite_inherit
#   Determines whether the virtual host inherits global rewrite rules.<br />
#   Rewrite rules may be specified globally (in `$conf_file` or `$confd_dir`) or 
#   inside the virtual host `.conf` file. By default, virtual hosts do not inherit 
#   global settings. To activate inheritance, specify the `rewrites` parameter and set 
#   `rewrite_inherit` parameter to `true`:
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     …
#     rewrites => [
#       <rules>,
#     ],
#     rewrite_inherit => `true`,
#   }
#   ```
#   > **Note**: The `rewrites` parameter is **required** for this to have effect<br />
#   Apache activates global `Rewrite` rules inheritance if the virtual host files contains 
#   the following directives:
#   ``` ApacheConf
#   RewriteEngine On
#   RewriteOptions Inherit
#   ```
#   Refer to the official [`mod_rewrite`](https://httpd.apache.org/docs/2.2/mod/mod_rewrite.html)
#   documentation, section "Rewriting in Virtual Hosts".
#
# @param scriptalias
#   Defines a directory of CGI scripts to be aliased to the path '/cgi-bin', such as 
#   '/usr/scripts'.
#
# @param scriptaliases
#   > **Note**: This parameter is deprecated in favor of the `aliases` parameter.<br />
#   Passes an array of hashes to the virtual host to create either ScriptAlias or 
#   ScriptAliasMatch statements per the `mod_alias` documentation.
#   ``` puppet
#   scriptaliases => [
#     {
#       alias => '/myscript',
#       path  => '/usr/share/myscript',
#     },
#     {
#       aliasmatch => '^/foo(.*)',
#       path       => '/usr/share/fooscripts$1',
#     },
#     {
#       aliasmatch => '^/bar/(.*)',
#       path       => '/usr/share/bar/wrapper.sh/$1',
#     },
#     {
#       alias => '/neatscript',
#       path  => '/usr/share/neatscript',
#     },
#   ]
#   ```
#   The ScriptAlias and ScriptAliasMatch directives are created in the order specified. 
#   As with [Alias and AliasMatch](#aliases) directives, specify more specific aliases 
#   before more general ones to avoid shadowing.
#
# @param serveradmin
#   Specifies the email address Apache displays when it renders one of its error pages.
#
# @param serveraliases
#   Sets the [ServerAliases](https://httpd.apache.org/docs/current/mod/core.html#serveralias) 
#   of the site.
#
# @param servername
#   Sets the servername corresponding to the hostname you connect to the virtual host at.
#
# @param setenv
#   Used by HTTPD to set environment variables for virtual hosts.<br />
#   Example:
#   ``` puppet
#   apache::vhost { 'setenv.example.com':
#     setenv => ['SPECIAL_PATH /foo/bin'],
#   }
#   ```
#
# @param setenvif
#   Used by HTTPD to conditionally set environment variables for virtual hosts.
#
# @param setenvifnocase
#   Used by HTTPD to conditionally set environment variables for virtual hosts (caseless matching).
#
# @param suexec_user_group
#   Allows the spcification of user and group execution privileges for CGI programs through
#   inclusion of the `mod_suexec` module.
# 
# @param suphp_addhandler
#   Sets up a virtual host with [suPHP](http://suphp.org/DocumentationView.html?file=apache/CONFIG)
#   working together with suphp_configpath and suphp_engine.<br />
#   An example virtual host configuration with suPHP:
#   ``` puppet
#   apache::vhost { 'suphp.example.com':
#     port             => '80',
#     docroot          => '/home/appuser/myphpapp',
#     suphp_addhandler => 'x-httpd-php',
#     suphp_engine     => 'on',
#     suphp_configpath => '/etc/php5/apache2',
#     directories      => { path => '/home/appuser/myphpapp',
#       'suphp'        => { user => 'myappuser', group => 'myappgroup' },
#     }
#   }
#   ```
#
# @param suphp_configpath
#   Sets up a virtual host with [suPHP](http://suphp.org/DocumentationView.html?file=apache/CONFIG)
#   working together with suphp_addhandler and suphp_engine.<br />
#   An example virtual host configuration with suPHP:
#   ``` puppet
#   apache::vhost { 'suphp.example.com':
#     port             => '80',
#     docroot          => '/home/appuser/myphpapp',
#     suphp_addhandler => 'x-httpd-php',
#     suphp_engine     => 'on',
#     suphp_configpath => '/etc/php5/apache2',
#     directories      => { path => '/home/appuser/myphpapp',
#       'suphp'        => { user => 'myappuser', group => 'myappgroup' },
#     }
#   }
#   ```
#
# @param suphp_engine
#   Sets up a virtual host with [suPHP](http://suphp.org/DocumentationView.html?file=apache/CONFIG)
#   working together with suphp_configpath and suphp_addhandler.<br />
#   An example virtual host configuration with suPHP:
#   ``` puppet
#   apache::vhost { 'suphp.example.com':
#     port             => '80',
#     docroot          => '/home/appuser/myphpapp',
#     suphp_addhandler => 'x-httpd-php',
#     suphp_engine     => 'on',
#     suphp_configpath => '/etc/php5/apache2',
#     directories      => { path => '/home/appuser/myphpapp',
#       'suphp'        => { user => 'myappuser', group => 'myappgroup' },
#     }
#   }
#   ```
#
# @param vhost_name
#   Enables name-based virtual hosting. If no IP is passed to the virtual host, but the 
#   virtual host is assigned a port, then the virtual host name is `vhost_name:port`. 
#   If the virtual host has no assigned IP or port, the virtual host name is set to the 
#   title of the resource.
#
# @param virtual_docroot
#   Sets up a virtual host with a wildcard alias subdomain mapped to a directory with the 
#   same name. For example, `http://example.com` would map to `/var/www/example.com`.
#   ``` puppet
#   apache::vhost { 'subdomain.loc':
#     vhost_name      => '*',
#     port            => '80',
#     virtual_docroot => '/var/www/%-2+',
#     docroot         => '/var/www',
#     serveraliases   => ['*.loc',],
#   }
#   ```
# 
# @param wsgi_daemon_process
#   Sets up a virtual host with [WSGI](https://github.com/GrahamDumpleton/mod_wsgi) alongside
#   wsgi_daemon_process_options, wsgi_process_group, 
#   wsgi_script_aliases and wsgi_pass_authorization.<br />
#   A hash that sets the name of the WSGI daemon, accepting 
#   [certain keys](http://modwsgi.readthedocs.org/en/latest/configuration-directives/WSGIDaemonProcess.html).<br />
#   An example virtual host configuration with WSGI:
#   ``` puppet
#   apache::vhost { 'wsgi.example.com':
#     port                        => '80',
#     docroot                     => '/var/www/pythonapp',
#     wsgi_daemon_process         => 'wsgi',
#     wsgi_daemon_process_options =>
#       { processes    => '2',
#         threads      => '15',
#         display-name => '%{GROUP}',
#       },
#     wsgi_process_group          => 'wsgi',
#     wsgi_script_aliases         => { '/' => '/var/www/demo.wsgi' },
#     wsgi_chunked_request        => 'On',
#   }
#   ```
#
# @param wsgi_daemon_process_options
#   Sets up a virtual host with [WSGI](https://github.com/GrahamDumpleton/mod_wsgi) alongside
#   wsgi_daemon_process, wsgi_process_group, 
#   wsgi_script_aliases and wsgi_pass_authorization.<br />
#   Sets the group ID that the virtual host runs under.
#
# @param wsgi_application_group
#   Sets up a virtual host with [WSGI](https://github.com/GrahamDumpleton/mod_wsgi) alongside
#   wsgi_daemon_process, wsgi_daemon_process_options, wsgi_process_group, 
#   and wsgi_pass_authorization.<br />
#   This parameter defines the [`WSGIApplicationGroup directive`](https://modwsgi.readthedocs.io/en/develop/configuration-directives/WSGIApplicationGroup.html),
#   thus allowing you to specify which application group the WSGI application belongs to,
#   with all WSGI applications within the same group executing within the context of the
#   same Python sub interpreter.
#
# @param wsgi_import_script
#   Sets up a virtual host with [WSGI](https://github.com/GrahamDumpleton/mod_wsgi) alongside
#   wsgi_daemon_process, wsgi_daemon_process_options, wsgi_process_group, 
#   and wsgi_pass_authorization.<br />
#   This parameter defines the [`WSGIImportScript directive`](https://modwsgi.readthedocs.io/en/develop/configuration-directives/WSGIImportScript.html),
#   which can be used in order to specify a script file to be loaded upon a process starting.
#
# @param wsgi_import_script_options
#   Sets up a virtual host with [WSGI](https://github.com/GrahamDumpleton/mod_wsgi) alongside
#   wsgi_daemon_process, wsgi_daemon_process_options, wsgi_process_group, 
#   and wsgi_pass_authorization.<br />
#   This parameter defines the [`WSGIImportScript directive`](https://modwsgi.readthedocs.io/en/develop/configuration-directives/WSGIImportScript.html),
#   which can be used in order to specify a script file to be loaded upon a process starting.<br />
#   Specifies the process and aplication groups of the script.
#
# @param wsgi_chunked_request
#   Sets up a virtual host with [WSGI](https://github.com/GrahamDumpleton/mod_wsgi) alongside
#   wsgi_daemon_process, wsgi_daemon_process_options, wsgi_process_group, 
#   and wsgi_pass_authorization.<br />
#   This parameter defines the [`WSGIChunkedRequest directive`](https://modwsgi.readthedocs.io/en/develop/configuration-directives/WSGIChunkedRequest.html),
#   allowing you to enable support for chunked request content.<br />
#   WSGI is technically incapable of supporting chunked request content without all chunked
#   request content having first been read in and buffered.
#
# @param wsgi_process_group
#   Sets up a virtual host with [WSGI](https://github.com/GrahamDumpleton/mod_wsgi) alongside
#   wsgi_daemon_process, wsgi_daemon_process_options,  
#   wsgi_script_aliases and wsgi_pass_authorization.<br />
#   Requires a hash of web paths to filesystem `.wsgi paths/`.
#
# @param wsgi_script_aliases
#   Sets up a virtual host with [WSGI](https://github.com/GrahamDumpleton/mod_wsgi) alongside
#   wsgi_daemon_process, wsgi_daemon_process_options, wsgi_process_group, 
#   and wsgi_pass_authorization.<br />
#   Uses the WSGI application to handle authorization instead of Apache when set to `On`.<br />
#   For more information, see mod_wsgi's [WSGIPassAuthorization documentation](https://modwsgi.readthedocs.org/en/latest/configuration-directives/WSGIPassAuthorization.html).
#
# @param wsgi_script_aliases_match
#   Sets up a virtual host with [WSGI](https://github.com/GrahamDumpleton/mod_wsgi) alongside
#   wsgi_daemon_process, wsgi_daemon_process_options, wsgi_process_group, 
#   and wsgi_pass_authorization.<br />
#   Uses the WSGI application to handle authorization instead of Apache when set to `On`.<br />
#   This directive is similar to `wsgi_script_aliases`, but makes use of regular expressions
#   in place of simple prefix matching.<br />
#   For more information, see mod_wsgi's [WSGIPassAuthorization documentation](https://modwsgi.readthedocs.org/en/latest/configuration-directives/WSGIPassAuthorization.html).
# 
# @param wsgi_pass_authorization
#   Sets up a virtual host with [WSGI](https://github.com/GrahamDumpleton/mod_wsgi) alongside
#   wsgi_daemon_process, wsgi_daemon_process_options, wsgi_process_group and
#   wsgi_script_aliases.<br />
#   Enables support for chunked requests.
#
# @param directories
#   The `directories` parameter within the `apache::vhost` class passes an array of hashes 
#   to the virtual host to create [Directory](https://httpd.apache.org/docs/current/mod/core.html#directory), 
#   [File](https://httpd.apache.org/docs/current/mod/core.html#files), and 
#   [Location](https://httpd.apache.org/docs/current/mod/core.html#location) directive blocks. 
#   These blocks take the form, `< Directory /path/to/directory>...< /Directory>`.<br />
#   The `path` key sets the path for the directory, files, and location blocks. Its value 
#   must be a path for the `directory`, `files`, and `location` providers, or a regex for 
#   the `directorymatch`, `filesmatch`, or `locationmatch` providers. Each hash passed to 
#   `directories` **must** contain `path` as one of the keys.<br />
#   The `provider` key is optional. If missing, this key defaults to `directory`.
#    Values: `directory`, `files`, `proxy`, `location`, `directorymatch`, `filesmatch`, 
#   `proxymatch` or `locationmatch`. If you set `provider` to `directorymatch`, it 
#   uses the keyword `DirectoryMatch` in the Apache config file.<br />
#   An example use of `directories`:
#   ``` puppet
#   apache::vhost { 'files.example.net':
#     docroot     => '/var/www/files',
#     directories => [
#       { 'path'     => '/var/www/files',
#         'provider' => 'files',
#         'deny'     => 'from all',
#       },
#     ],
#   }
#   ```
#   > **Note:** At least one directory should match the `docroot` parameter. After you 
#   start declaring directories, `apache::vhost` assumes that all required Directory blocks 
#   will be declared. If not defined, a single default Directory block is created that matches 
#   the `docroot` parameter.<br />
#   Available handlers, represented as keys, should be placed within the `directory`, 
#   `files`, or `location` hashes. This looks like
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     docroot     => '/path/to/directory',
#     directories => [ { path => '/path/to/directory', handler => value } ],
#   }
#   ```
#   Any handlers you do not set in these hashes are considered `undefined` within Puppet and 
#   are not added to the virtual host, resulting in the module using their default values.
#
# @param custom_fragment
#   Pass a string of custom configuration directives to be placed at the end of the directory 
#   configuration.
#   ``` puppet
#   apache::vhost { 'monitor':
#     …
#     directories => [
#       {
#         path => '/path/to/directory',
#         custom_fragment => '
#   <Location /balancer-manager>
#     SetHandler balancer-manager
#     Order allow,deny
#     Allow from all
#   </Location>
#   <Location /server-status>
#     SetHandler server-status
#     Order allow,deny
#     Allow from all
#   </Location>
#   ProxyStatus On',
#       },
#     ]
#   }
#   ```
#
# @param error_documents
#   An array of hashes used to override the [ErrorDocument](https://httpd.apache.org/docs/current/mod/core.html#errordocument) 
#   settings for the directory.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     directories => [
#       { path            => '/srv/www',
#         error_documents => [
#           { 'error_code' => '503',
#             'document'   => '/service-unavail',
#           },
#         ],
#       },
#     ],
#   }
#   ```
#
# @param h2_copy_files
#   Sets the [H2CopyFiles](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2copyfiles) directive.<br />
#   Note that you must declare `class {'apache::mod::http2': }` before using this directive.
#
# @param h2_push_resource
#   Sets the [H2PushResource](https://httpd.apache.org/docs/current/mod/mod_http2.html#h2pushresource) directive.<br />
#   Note that you must declare `class {'apache::mod::http2': }` before using this directive.
#
# @param headers
#   Adds lines for [Header](https://httpd.apache.org/docs/current/mod/mod_headers.html#header) directives.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     docroot     => '/path/to/directory',
#     directories => {
#       path    => '/path/to/directory',
#       headers => 'Set X-Robots-Tag "noindex, noarchive, nosnippet"',
#     },
#   }
#   ```
#
# @param options
#   Lists the [Options](https://httpd.apache.org/docs/current/mod/core.html#options) for the 
#   given Directory block.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     docroot     => '/path/to/directory',
#     directories => [
#       { path    => '/path/to/directory',
#         options => ['Indexes','FollowSymLinks','MultiViews'],
#       },
#     ],
#   }
#   ```
# 
# @param shib_compat_valid_user
#   Default is Off, matching the behavior prior to this command's existence. Addresses a conflict 
#   when using Shibboleth in conjunction with other auth/auth modules by restoring `standard` 
#   Apache behavior when processing the `valid-user` and `user` Require rules. See the 
#   [`mod_shib`documentation](https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPApacheConfig#NativeSPApacheConfig-Server/VirtualHostOptions), 
#   and [NativeSPhtaccess](https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPhtaccess) 
#   topic for more details. This key is disabled if `apache::mod::shib` is not defined.
#
# @param ssl_options
#   String or list of [SSLOptions](https://httpd.apache.org/docs/current/mod/mod_ssl.html#ssloptions), 
#   which configure SSL engine run-time options. This handler takes precedence over SSLOptions 
#   set in the parent block of the virtual host.
#   ``` puppet
#   apache::vhost { 'secure.example.net':
#     docroot     => '/path/to/directory',
#     directories => [
#       { path        => '/path/to/directory',
#         ssl_options => '+ExportCertData',
#       },
#       { path        => '/path/to/different/dir',
#         ssl_options => ['-StdEnvVars', '+ExportCertData'],
#       },
#     ],
#   }
#   ```
#
# @param additional_includes
#   Specifies paths to additional static, specific Apache configuration files in virtual 
#   host directories.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     docroot     => '/path/to/directory',
#     directories => [
#       { path  => '/path/to/different/dir',
#         additional_includes => ['/custom/path/includes', '/custom/path/another_includes',],
#       },
#     ],
#   }
#   ```
# 
# @param ssl
#   Enables SSL for the virtual host. SSL virtual hosts only respond to HTTPS queries.
#
# @param ssl_ca
#   Specifies the SSL certificate authority to be used to verify client certificates used 
#   for authentication. You must also set `ssl_verify_client` to use this.
#
# @param ssl_cert
#   Specifies the SSL certification.
#
# @param ssl_protocol
#   Specifies [SSLProtocol](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslprotocol). 
#   Expects an array or space separated string of accepted protocols.
#
# @param ssl_cipher
#   Specifies [SSLCipherSuite](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslciphersuite).
#
# @param ssl_honorcipherorder
#   Sets [SSLHonorCipherOrder](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslhonorcipherorder), 
#   to cause Apache to use the server's preferred order of ciphers rather than the client's 
#   preferred order.
#
# @param ssl_certs_dir
#   Specifies the location of the SSL certification directory to verify client certs. Will not 
#   be used unless `ssl_verify_client` is also set (see below).
#
# @param ssl_chain
#   Specifies the SSL chain. This default works out of the box, but it must be updated in 
#   the base `apache` class with your specific certificate information before being used in 
#   production.
#
# @param ssl_crl
#   Specifies the certificate revocation list to use. (This default works out of the box but 
#   must be updated in the base `apache` class with your specific certificate information 
#   before being used in production.)
#
# @param ssl_crl_path
#   Specifies the location of the certificate revocation list to verify certificates for 
#   client authentication with. (This default works out of the box but must be updated in 
#   the base `apache` class with your specific certificate information before being used in 
#   production.)
#
# @param ssl_crl_check
#   Sets the certificate revocation check level via the [SSLCARevocationCheck directive](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslcarevocationcheck) 
#   for ssl client authentication. The default works out of the box but must be specified when 
#   using CRLs in production. Only applicable to Apache 2.4 or higher; the value is ignored on 
#   older versions.
#
# @param ssl_key
#   Specifies the SSL key.<br />
#   Defaults are based on your operating system. Default work out of the box but must be 
#   updated in the base `apache` class with your specific certificate information before 
#   being used in production.
#
# @param ssl_verify_client
#   Sets the [SSLVerifyClient](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslverifyclient) 
#   directive, which sets the certificate verification level for client authentication.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     …
#     ssl_verify_client => 'optional',
#   }
#   ```
#
# @param ssl_verify_depth
#   Sets the [SSLVerifyDepth](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslverifydepth) 
#   directive, which specifies the maximum depth of CA certificates in client certificate 
#   verification. You must set `ssl_verify_client` for it to take effect.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     …
#     ssl_verify_client => 'require',
#     ssl_verify_depth => 1,
#   }
#   ```
#
# @param ssl_proxy_protocol
#   Sets the [SSLProxyProtocol](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslproxyprotocol) 
#   directive, which controls which SSL protocol flavors `mod_ssl` should use when establishing 
#   its server environment for proxy. It connects to servers using only one of the provided 
#   protocols.
#
# @param ssl_proxy_verify
#   Sets the [SSLProxyVerify](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslproxyverify) 
#   directive, which configures certificate verification of the remote server when a proxy is 
#   configured to forward requests to a remote SSL server.
#
# @param ssl_proxy_verify_depth
#   Sets the [SSLProxyVerifyDepth](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslproxyverifydepth) 
#   directive, which configures how deeply mod_ssl should verify before deciding that the 
#   remote server does not have a valid certificate.<br />
#   A depth of 0 means that only self-signed remote server certificates are accepted, 
#   the default depth of 1 means the remote server certificate can be self-signed or 
#   signed by a CA that is directly known to the server.
#
# @param ssl_proxy_cipher_suite
#   Sets the [SSLProxyCipherSuite](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslproxyciphersuite) 
#   directive, which controls cipher suites supported for ssl proxy traffic.
#
# @param ssl_proxy_ca_cert
#   Sets the [SSLProxyCACertificateFile](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslproxycacertificatefile) 
#   directive, which specifies an all-in-one file where you can assemble the Certificates 
#   of Certification Authorities (CA) whose remote servers you deal with. These are used 
#   for Remote Server Authentication. This file should be a concatenation of the PEM-encoded 
#   certificate files in order of preference.
#
# @param ssl_proxy_machine_cert
#   Sets the [SSLProxyMachineCertificateFile](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslproxymachinecertificatefile) 
#   directive, which specifies an all-in-one file where you keep the certs and keys used 
#   for this server to authenticate itself to remote servers. This file should be a 
#   concatenation of the PEM-encoded certificate files in order of preference.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     …
#     ssl_proxy_machine_cert => '/etc/httpd/ssl/client_certificate.pem',
#   }
#   ```
#
# @param ssl_proxy_check_peer_cn
#   Sets the [SSLProxyCheckPeerCN](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslproxycheckpeercn) 
#   directive, which specifies whether the remote server certificate's CN field is compared 
#   against the hostname of the request URL.
#
# @param ssl_proxy_check_peer_name
#   Sets the [SSLProxyCheckPeerName](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslproxycheckpeername) 
#   directive, which specifies whether the remote server certificate's CN field is compared 
#   against the hostname of the request URL.
#
# @param ssl_proxy_check_peer_expire
#   Sets the [SSLProxyCheckPeerExpire](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslproxycheckpeerexpire) 
#   directive, which specifies whether the remote server certificate is checked for expiration 
#   or not.
#
# @param ssl_options
#   Sets the [SSLOptions](https://httpd.apache.org/docs/current/mod/mod_ssl.html#ssloptions) 
#   directive, which configures various SSL engine run-time options. This is the global 
#   setting for the given virtual host and can be a string or an array.<br />
#   A string:
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     …
#     ssl_options => '+ExportCertData',
#   }
#   ```
#   An array:
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     …
#     ssl_options => ['+StrictRequire', '+ExportCertData'],
#   }
#   ```
#
# @param ssl_openssl_conf_cmd
#   Sets the [SSLOpenSSLConfCmd](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslopensslconfcmd) 
#   directive, which provides direct configuration of OpenSSL parameters.
#
# @param ssl_proxyengine
#   Specifies whether or not to use [SSLProxyEngine](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslproxyengine).
#
# @param ssl_stapling
#   Specifies whether or not to use [SSLUseStapling](http://httpd.apache.org/docs/current/mod/mod_ssl.html#sslusestapling). 
#   By default, uses what is set globally.<br />
#   This parameter only applies to Apache 2.4 or higher and is ignored on older versions.
#
# @param ssl_stapling_timeout
#   Can be used to set the [SSLStaplingResponderTimeout](http://httpd.apache.org/docs/current/mod/mod_ssl.html#sslstaplingrespondertimeout) directive.<br />
#   This parameter only applies to Apache 2.4 or higher and is ignored on older versions.
#
# @param ssl_stapling_return_errors
#   Can be used to set the [SSLStaplingReturnResponderErrors](http://httpd.apache.org/docs/current/mod/mod_ssl.html#sslstaplingreturnrespondererrors) directive.<br />
#   This parameter only applies to Apache 2.4 or higher and is ignored on older versions.
#
# @param use_canonical_name
#   Specifies whether to use the [`UseCanonicalName directive`](https://httpd.apache.org/docs/2.4/mod/core.html#usecanonicalname),
#   which allows you to configure how the server determines it's own name and port.
# 
# @param define
#   this lets you define configuration variables inside a vhost using [`Define`](https://httpd.apache.org/docs/2.4/mod/core.html#define),
#   these can then be used to replace configuration values. All Defines are Undefined at the end of the VirtualHost.
#
# @param auth_oidc
#   Enable `mod_auth_openidc` parameters for OpenID Connect authentication.
#
# @param oidc_settings
#   An Apache::OIDCSettings Struct containing (mod_auth_openidc settings)[https://github.com/zmartzone/mod_auth_openidc/blob/master/auth_openidc.conf].
#
# @param limitreqfields
#   The `limitreqfields` parameter sets the maximum number of request header fields in
#   an HTTP request. This directive gives the server administrator greater control over
#   abnormal client request behavior, which may be useful for avoiding some forms of
#   denial-of-service attacks. The value should be increased if normal clients see an error
#   response from the server that indicates too many fields were sent in the request.
#
# @param limitreqfieldsize
#   The `limitreqfieldsize` parameter sets the maximum ammount of _bytes_ that will
#   be allowed within a request header.
#
# @param limitreqline
#   Limit the size of the HTTP request line that will be accepted from the client
#   This directive sets the number of bytes that will be allowed on the HTTP
#   request-line. The LimitRequestLine directive allows the server administrator
#   to set the limit on the allowed size of a client's HTTP request-line. Since
#   the request-line consists of the HTTP method, URI, and protocol version, the
#   LimitRequestLine directive places a restriction on the length of a request-URI
#   allowed for a request on the server. A server needs this value to be large
#   enough to hold any of its resource names, including any information that might
#   be passed in the query part of a GET request.
#
# @param limitreqbody
#   Restricts the total size of the HTTP request body sent from the client
#   The LimitRequestBody directive allows the user to set a limit on the allowed
#   size of an HTTP request message body within the context in which the
#   directive is given (server, per-directory, per-file or per-location). If the
#   client request exceeds that limit, the server will return an error response
#   instead of servicing the request.
#
define apache::vhost(
  Variant[Boolean,String] $docroot,
  $manage_docroot                                                                   = true,
  $virtual_docroot                                                                  = false,
  $port                                                                             = undef,
  $ip                                                                               = undef,
  Boolean $ip_based                                                                 = false,
  $add_listen                                                                       = true,
  $docroot_owner                                                                    = 'root',
  $docroot_group                                                                    = $::apache::params::root_group,
  $docroot_mode                                                                     = undef,
  Array[Enum['h2', 'h2c', 'http/1.1']] $protocols                                   = [],
  Optional[Boolean] $protocols_honor_order                                          = undef,
  $serveradmin                                                                      = undef,
  Boolean $ssl                                                                      = false,
  $ssl_cert                                                                         = $::apache::default_ssl_cert,
  $ssl_key                                                                          = $::apache::default_ssl_key,
  $ssl_chain                                                                        = $::apache::default_ssl_chain,
  $ssl_ca                                                                           = $::apache::default_ssl_ca,
  $ssl_crl_path                                                                     = $::apache::default_ssl_crl_path,
  $ssl_crl                                                                          = $::apache::default_ssl_crl,
  $ssl_crl_check                                                                    = $::apache::default_ssl_crl_check,
  $ssl_certs_dir                                                                    = $::apache::params::ssl_certs_dir,
  $ssl_protocol                                                                     = undef,
  $ssl_cipher                                                                       = undef,
  $ssl_honorcipherorder                                                             = undef,
  $ssl_verify_client                                                                = undef,
  $ssl_verify_depth                                                                 = undef,
  Optional[Enum['none', 'optional', 'require', 'optional_no_ca']] $ssl_proxy_verify = undef,
  Optional[Integer[0]] $ssl_proxy_verify_depth                                      = undef,
  $ssl_proxy_ca_cert                                                                = undef,
  Optional[Enum['on', 'off']] $ssl_proxy_check_peer_cn                              = undef,
  Optional[Enum['on', 'off']] $ssl_proxy_check_peer_name                            = undef,
  Optional[Enum['on', 'off']] $ssl_proxy_check_peer_expire                          = undef,
  $ssl_proxy_machine_cert                                                           = undef,
  $ssl_proxy_cipher_suite                                                           = undef,
  $ssl_proxy_protocol                                                               = undef,
  $ssl_options                                                                      = undef,
  $ssl_openssl_conf_cmd                                                             = undef,
  Boolean $ssl_proxyengine                                                          = false,
  Optional[Boolean] $ssl_stapling                                                   = undef,
  $ssl_stapling_timeout                                                             = undef,
  $ssl_stapling_return_errors                                                       = undef,
  $priority                                                                         = undef,
  Boolean $default_vhost                                                            = false,
  $servername                                                                       = $name,
  $serveraliases                                                                    = [],
  $options                                                                          = ['Indexes','FollowSymLinks','MultiViews'],
  $override                                                                         = ['None'],
  $directoryindex                                                                   = '',
  $vhost_name                                                                       = '*',
  $logroot                                                                          = $::apache::logroot,
  Enum['directory', 'absent'] $logroot_ensure                                       = 'directory',
  $logroot_mode                                                                     = undef,
  $logroot_owner                                                                    = undef,
  $logroot_group                                                                    = undef,
  Optional[Apache::LogLevel] $log_level                                             = undef,
  Boolean $access_log                                                               = true,
  $access_log_file                                                                  = false,
  $access_log_pipe                                                                  = false,
  $access_log_syslog                                                                = false,
  $access_log_format                                                                = false,
  $access_log_env_var                                                               = false,
  Optional[Array] $access_logs                                                      = undef,
  $aliases                                                                          = undef,
  Optional[Variant[Hash, Array[Variant[Array,Hash]]]] $directories                  = undef,
  Boolean $error_log                                                                = true,
  $error_log_file                                                                   = undef,
  $error_log_pipe                                                                   = undef,
  $error_log_syslog                                                                 = undef,
  Optional[
    Array[
      Variant[
        String,
        Hash[String, Enum['connection', 'request']]
      ]
    ]
  ]       $error_log_format                                                         = undef,
  Optional[Pattern[/^((Strict|Unsafe)?\s*(\b(Registered|Lenient)Methods)?\s*(\b(Allow0\.9|Require1\.0))?)$/]] $http_protocol_options = undef,
  $modsec_audit_log                                                                 = undef,
  $modsec_audit_log_file                                                            = undef,
  $modsec_audit_log_pipe                                                            = undef,
  $error_documents                                                                  = [],
  Optional[Variant[Stdlib::Absolutepath, Enum['disabled']]] $fallbackresource       = undef,
  $scriptalias                                                                      = undef,
  $scriptaliases                                                                    = [],
  Optional[Integer] $limitreqfieldsize                                              = undef,
  Optional[Integer] $limitreqfields                                                 = undef,
  Optional[Integer] $limitreqline                                                   = undef,
  Optional[Integer] $limitreqbody                                                   = undef,
  $proxy_dest                                                                       = undef,
  $proxy_dest_match                                                                 = undef,
  $proxy_dest_reverse_match                                                         = undef,
  $proxy_pass                                                                       = undef,
  $proxy_pass_match                                                                 = undef,
  Boolean $proxy_requests                                                           = false,
  $suphp_addhandler                                                                 = $::apache::params::suphp_addhandler,
  Enum['on', 'off'] $suphp_engine                                                   = $::apache::params::suphp_engine,
  $suphp_configpath                                                                 = $::apache::params::suphp_configpath,
  $php_flags                                                                        = {},
  $php_values                                                                       = {},
  $php_admin_flags                                                                  = {},
  $php_admin_values                                                                 = {},
  $no_proxy_uris                                                                    = [],
  $no_proxy_uris_match                                                              = [],
  $proxy_preserve_host                                                              = false,
  $proxy_add_headers                                                                = undef,
  $proxy_error_override                                                             = false,
  $redirect_source                                                                  = '/',
  $redirect_dest                                                                    = undef,
  $redirect_status                                                                  = undef,
  $redirectmatch_status                                                             = undef,
  $redirectmatch_regexp                                                             = undef,
  $redirectmatch_dest                                                               = undef,
  $headers                                                                          = undef,
  $request_headers                                                                  = undef,
  $filters                                                                          = undef,
  Optional[Array] $rewrites                                                         = undef,
  $rewrite_base                                                                     = undef,
  $rewrite_rule                                                                     = undef,
  $rewrite_cond                                                                     = undef,
  $rewrite_inherit                                                                  = false,
  $setenv                                                                           = [],
  $setenvif                                                                         = [],
  $setenvifnocase                                                                   = [],
  $block                                                                            = [],
  Enum['absent', 'present'] $ensure                                                 = 'present',
  $wsgi_application_group                                                           = undef,
  Optional[Variant[String,Hash]] $wsgi_daemon_process                               = undef,
  Optional[Hash] $wsgi_daemon_process_options                                       = undef,
  $wsgi_import_script                                                               = undef,
  Optional[Hash] $wsgi_import_script_options                                        = undef,
  $wsgi_process_group                                                               = undef,
  Optional[Hash] $wsgi_script_aliases_match                                         = undef,
  Optional[Hash] $wsgi_script_aliases                                               = undef,
  Optional[Enum['on', 'off', 'On', 'Off']] $wsgi_pass_authorization                 = undef,
  $wsgi_chunked_request                                                             = undef,
  Optional[String] $custom_fragment                                                 = undef,
  Optional[Hash] $itk                                                               = undef,
  $action                                                                           = undef,
  $fastcgi_server                                                                   = undef,
  $fastcgi_socket                                                                   = undef,
  $fastcgi_dir                                                                      = undef,
  $fastcgi_idle_timeout                                                             = undef,
  $additional_includes                                                              = [],
  $use_optional_includes                                                            = $::apache::use_optional_includes,
  $apache_version                                                                   = $::apache::apache_version,
  Optional[Enum['on', 'off', 'nodecode']] $allow_encoded_slashes                    = undef,
  Optional[Pattern[/^[\w-]+ [\w-]+$/]] $suexec_user_group                           = undef,

  Optional[Boolean] $h2_copy_files                                                  = undef,
  Optional[Boolean] $h2_direct                                                      = undef,
  Optional[Boolean] $h2_early_hints                                                 = undef,
  Optional[Integer] $h2_max_session_streams                                         = undef,
  Optional[Boolean] $h2_modern_tls_only                                             = undef,
  Optional[Boolean] $h2_push                                                        = undef,
  Optional[Integer] $h2_push_diary_size                                             = undef,
  Array[String]     $h2_push_priority                                               = [],
  Array[String]     $h2_push_resource                                               = [],
  Optional[Boolean] $h2_serialize_headers                                           = undef,
  Optional[Integer] $h2_stream_max_mem_size                                         = undef,
  Optional[Integer] $h2_tls_cool_down_secs                                          = undef,
  Optional[Integer] $h2_tls_warm_up_size                                            = undef,
  Optional[Boolean] $h2_upgrade                                                     = undef,
  Optional[Integer] $h2_window_size                                                 = undef,

  Optional[Boolean] $passenger_enabled                                              = undef,
  Optional[String] $passenger_base_uri                                              = undef,
  Optional[Stdlib::Absolutepath] $passenger_ruby                                    = undef,
  Optional[Stdlib::Absolutepath] $passenger_python                                  = undef,
  Optional[Stdlib::Absolutepath] $passenger_nodejs                                  = undef,
  Optional[String] $passenger_meteor_app_settings                                   = undef,
  Optional[String] $passenger_app_env                                               = undef,
  Optional[Stdlib::Absolutepath] $passenger_app_root                                = undef,
  Optional[String] $passenger_app_group_name                                        = undef,
  Optional[Enum['meteor', 'node', 'rack', 'wsgi']] $passenger_app_type              = undef,
  Optional[String] $passenger_startup_file                                          = undef,
  Optional[String] $passenger_restart_dir                                           = undef,
  Optional[Enum['direct', 'smart']] $passenger_spawn_method                         = undef,
  Optional[Boolean] $passenger_load_shell_envvars                                   = undef,
  Optional[Boolean] $passenger_rolling_restarts                                     = undef,
  Optional[Boolean] $passenger_resist_deployment_errors                             = undef,
  Optional[String] $passenger_user                                                  = undef,
  Optional[String] $passenger_group                                                 = undef,
  Optional[Boolean] $passenger_friendly_error_pages                                 = undef,
  Optional[Integer] $passenger_min_instances                                        = undef,
  Optional[Integer] $passenger_max_instances                                        = undef,
  Optional[Integer] $passenger_max_preloader_idle_time                              = undef,
  Optional[Integer] $passenger_force_max_concurrent_requests_per_process            = undef,
  Optional[Integer] $passenger_start_timeout                                        = undef,
  Optional[Enum['process', 'thread']] $passenger_concurrency_model                  = undef,
  Optional[Integer] $passenger_thread_count                                         = undef,
  Optional[Integer] $passenger_max_requests                                         = undef,
  Optional[Integer] $passenger_max_request_time                                     = undef,
  Optional[Integer] $passenger_memory_limit                                         = undef,
  Optional[Integer] $passenger_stat_throttle_rate                                   = undef,
  Optional[Variant[String,Array[String]]] $passenger_pre_start                      = undef,
  Optional[Boolean] $passenger_high_performance                                     = undef,
  Optional[Boolean] $passenger_buffer_upload                                        = undef,
  Optional[Boolean] $passenger_buffer_response                                      = undef,
  Optional[Boolean] $passenger_error_override                                       = undef,
  Optional[Integer] $passenger_max_request_queue_size                               = undef,
  Optional[Integer] $passenger_max_request_queue_time                               = undef,
  Optional[Boolean] $passenger_sticky_sessions                                      = undef,
  Optional[String] $passenger_sticky_sessions_cookie_name                           = undef,
  Optional[Boolean] $passenger_allow_encoded_slashes                                = undef,
  Optional[Boolean] $passenger_debugger                                             = undef,
  Optional[Integer] $passenger_lve_min_uid                                          = undef,
  $add_default_charset                                                              = undef,
  $modsec_disable_vhost                                                             = undef,
  Optional[Variant[Hash, Array]] $modsec_disable_ids                                = undef,
  $modsec_disable_ips                                                               = undef,
  Optional[Variant[Hash, Array]] $modsec_disable_msgs                               = undef,
  Optional[Variant[Hash, Array]] $modsec_disable_tags                               = undef,
  $modsec_body_limit                                                                = undef,
  $jk_mounts                                                                        = undef,
  Boolean $auth_kerb                                                                = false,
  $krb_method_negotiate                                                             = 'on',
  $krb_method_k5passwd                                                              = 'on',
  $krb_authoritative                                                                = 'on',
  $krb_auth_realms                                                                  = [],
  $krb_5keytab                                                                      = undef,
  $krb_local_user_mapping                                                           = undef,
  $krb_verify_kdc                                                                   = 'on',
  $krb_servicename                                                                  = 'HTTP',
  $krb_save_credentials                                                             = 'off',
  Optional[Enum['on', 'off']] $keepalive                                            = undef,
  $keepalive_timeout                                                                = undef,
  $max_keepalive_requests                                                           = undef,
  $cas_attribute_prefix                                                             = undef,
  $cas_attribute_delimiter                                                          = undef,
  $cas_root_proxied_as                                                              = undef,
  $cas_scrub_request_headers                                                        = undef,
  $cas_sso_enabled                                                                  = undef,
  $cas_login_url                                                                    = undef,
  $cas_validate_url                                                                 = undef,
  $cas_validate_saml                                                                = undef,
  Optional[String] $shib_compat_valid_user                                          = undef,
  Optional[Enum['On', 'on', 'Off', 'off', 'DNS', 'dns']] $use_canonical_name        = undef,
  Optional[Variant[String,Array[String]]] $comment                                  = undef,
  Hash $define                                                                      = {},
  Boolean $auth_oidc                                                                = false,
  Optional[Apache::OIDCSettings] $oidc_settings                                     = undef,
) {

  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['apache']) {
    fail('You must include the apache base class before using any apache defined resources')
  }

  $apache_name = $::apache::apache_name

  if $rewrites {
    unless empty($rewrites) {
      $rewrites_flattened = delete_undef_values(flatten([$rewrites]))
      assert_type(Array[Hash], $rewrites_flattened)
    }
  }

  # Input validation begins

  if $access_log_file and $access_log_pipe {
    fail("Apache::Vhost[${name}]: 'access_log_file' and 'access_log_pipe' cannot be defined at the same time")
  }

  if $error_log_file and $error_log_pipe {
    fail("Apache::Vhost[${name}]: 'error_log_file' and 'error_log_pipe' cannot be defined at the same time")
  }

  if $modsec_audit_log_file and $modsec_audit_log_pipe {
    fail("Apache::Vhost[${name}]: 'modsec_audit_log_file' and 'modsec_audit_log_pipe' cannot be defined at the same time")
  }

  # Input validation ends

  if $ssl and $ensure == 'present' {
    include ::apache::mod::ssl
    # Required for the AddType lines.
    include ::apache::mod::mime
  }

  if $auth_kerb and $ensure == 'present' {
    include ::apache::mod::auth_kerb
  }

  if $auth_oidc and $ensure == 'present' {
    include ::apache::mod::auth_openidc
  }

  if $virtual_docroot {
    include ::apache::mod::vhost_alias
  }

  if $wsgi_application_group or $wsgi_daemon_process or ($wsgi_import_script and $wsgi_import_script_options) or $wsgi_process_group or ($wsgi_script_aliases and ! empty($wsgi_script_aliases)) or $wsgi_pass_authorization {
    include ::apache::mod::wsgi
  }

  if $suexec_user_group {
    include ::apache::mod::suexec
  }

  if $passenger_spawn_method or $passenger_app_root or $passenger_app_env or $passenger_ruby or $passenger_min_instances or $passenger_max_requests or $passenger_start_timeout or $passenger_pre_start or $passenger_user or $passenger_group or $passenger_high_performance or $passenger_nodejs or $passenger_sticky_sessions or $passenger_startup_file {
    include ::apache::mod::passenger
  }

  # Configure the defaultness of a vhost
  if $priority {
    $priority_real = "${priority}-"
  } elsif $priority == false {
    $priority_real = ''
  } elsif $default_vhost {
    $priority_real = '10-'
  } else {
    $priority_real = '25-'
  }

  ## Apache include does not always work with spaces in the filename
  $filename = regsubst($name, ' ', '_', 'G')

  # This ensures that the docroot exists
  # But enables it to be specified across multiple vhost resources
  if $manage_docroot and $docroot and ! defined(File[$docroot]) {
    file { $docroot:
      ensure  => directory,
      owner   => $docroot_owner,
      group   => $docroot_group,
      mode    => $docroot_mode,
      require => Package['httpd'],
      before  => Concat["${priority_real}${filename}.conf"],
    }
  }

  # Same as above, but for logroot
  if ! defined(File[$logroot]) {
    file { $logroot:
      ensure  => $logroot_ensure,
      owner   => $logroot_owner,
      group   => $logroot_group,
      mode    => $logroot_mode,
      require => Package['httpd'],
      before  => Concat["${priority_real}${filename}.conf"],
      notify  => Class['Apache::Service'],
    }
  }

  # Is apache::mod::shib enabled (or apache::mod['shib2'])
  $shibboleth_enabled = defined(Apache::Mod['shib2'])

  # Is apache::mod::cas enabled (or apache::mod['cas'])
  $cas_enabled = defined(Apache::Mod['auth_cas'])

  if $access_log and !$access_logs {
    $_access_logs = [{
      'file'        => $access_log_file,
      'pipe'        => $access_log_pipe,
      'syslog'      => $access_log_syslog,
      'format'      => $access_log_format,
      'env'         => $access_log_env_var
    }]
  } elsif $access_logs {
    $_access_logs = $access_logs
  }

  if $error_log_file {
    if $error_log_file =~ /^\// {
      # Absolute path provided - don't prepend $logroot
      $error_log_destination = $error_log_file
    } else {
      $error_log_destination = "${logroot}/${error_log_file}"
    }
  } elsif $error_log_pipe {
    $error_log_destination = $error_log_pipe
  } elsif $error_log_syslog {
    $error_log_destination = $error_log_syslog
  } else {
    if $ssl {
      $error_log_destination = "${logroot}/${name}_error_ssl.log"
    } else {
      $error_log_destination = "${logroot}/${name}_error.log"
    }
  }

  if versioncmp($apache_version, '2.4') >= 0 {
    $error_log_format24 = $error_log_format
  }
  else {
    $error_log_format24 = undef
  }

  if $modsec_audit_log == false {
    $modsec_audit_log_destination = undef
  } elsif $modsec_audit_log_file {
    $modsec_audit_log_destination = "${logroot}/${modsec_audit_log_file}"
  } elsif $modsec_audit_log_pipe {
    $modsec_audit_log_destination = $modsec_audit_log_pipe
  } elsif $modsec_audit_log {
    if $ssl {
      $modsec_audit_log_destination = "${logroot}/${name}_security_ssl.log"
    } else {
      $modsec_audit_log_destination = "${logroot}/${name}_security.log"
    }
  } else {
    $modsec_audit_log_destination = undef
  }


  if $ip {
    $_ip = any2array(enclose_ipv6($ip))
    if $port {
      $_port = any2array($port)
      $listen_addr_port = split(inline_template("<%= @_ip.product(@_port).map {|x| x.join(':')  }.join(',')%>"), ',')
      $nvh_addr_port = split(inline_template("<%= @_ip.product(@_port).map {|x| x.join(':')  }.join(',')%>"), ',')
    } else {
      $listen_addr_port = undef
      $nvh_addr_port = $_ip
      if ! $servername and ! $ip_based {
        fail("Apache::Vhost[${name}]: must pass 'ip' and/or 'port' parameters for name-based vhosts")
      }
    }
  } else {
    if $port {
      $listen_addr_port = $port
      $nvh_addr_port = prefix(any2array($port),"${vhost_name}:")
    } else {
      $listen_addr_port = undef
      $nvh_addr_port = $name
      if ! $servername and $servername != '' {
        fail("Apache::Vhost[${name}]: must pass 'ip' and/or 'port' parameters, and/or 'servername' parameter")
      }
    }
  }

  if $add_listen {
    if $ip and defined(Apache::Listen[String($port)]) {
      fail("Apache::Vhost[${name}]: Mixing IP and non-IP Listen directives is not possible; check the add_listen parameter of the apache::vhost define to disable this")
    }
    if $listen_addr_port and $ensure == 'present' {
      ensure_resource('apache::listen', $listen_addr_port)
    }
  }
  if ! $ip_based {
    if $ensure == 'present' and (versioncmp($apache_version, '2.4') < 0) {
      ensure_resource('apache::namevirtualhost', $nvh_addr_port)
    }
  }

  # Load mod_rewrite if needed and not yet loaded
  if $rewrites or $rewrite_cond {
    if ! defined(Class['apache::mod::rewrite']) {
      include ::apache::mod::rewrite
    }
  }

  # Load mod_alias if needed and not yet loaded
  if ($scriptalias or $scriptaliases != [])
    or ($aliases and $aliases != [])
    or ($redirect_source and $redirect_dest)
    or ($redirectmatch_regexp or $redirectmatch_status or $redirectmatch_dest){
    if ! defined(Class['apache::mod::alias'])  and ($ensure == 'present') {
      include ::apache::mod::alias
    }
  }

  # Load mod_proxy if needed and not yet loaded
  if ($proxy_dest or $proxy_pass or $proxy_pass_match or $proxy_dest_match) {
    if ! defined(Class['apache::mod::proxy']) {
      include ::apache::mod::proxy
    }
    if ! defined(Class['apache::mod::proxy_http']) {
      include ::apache::mod::proxy_http
    }
  }

  # Load mod_fastcgi if needed and not yet loaded
  if $fastcgi_server and $fastcgi_socket {
    if ! defined(Class['apache::mod::fastcgi']) {
      include ::apache::mod::fastcgi
    }
  }

  # Check if mod_headers is required to process $headers/$request_headers
  if $headers or $request_headers {
    if ! defined(Class['apache::mod::headers']) {
      include ::apache::mod::headers
    }
  }

  # Check if mod_filter is required to process $filters
  if $filters {
    if ! defined(Class['apache::mod::filter']) {
      include ::apache::mod::filter
    }
  }

  # Check if mod_env is required and not yet loaded.
  # create an expression to simplify the conditional check
  $use_env_mod = $setenv and ! empty($setenv)
  if ($use_env_mod) {
    if ! defined(Class['apache::mod::env']) {
      include ::apache::mod::env
    }
  }
  # Check if mod_setenvif is required and not yet loaded.
  # create an expression to simplify the conditional check
  $use_setenvif_mod = ($setenvif and ! empty($setenvif)) or ($setenvifnocase and ! empty($setenvifnocase))

  if ($use_setenvif_mod) {
    if ! defined(Class['apache::mod::setenvif']) {
      include ::apache::mod::setenvif
    }
  }

  ## Create a default directory list if none defined
  if $directories {
    $_directories = $directories
  } elsif $docroot {
    $_directory = {
      provider       => 'directory',
      path           => $docroot,
      options        => $options,
      allow_override => $override,
      directoryindex => $directoryindex,
    }

    if versioncmp($apache_version, '2.4') >= 0 {
      $_directory_version = {
        require => 'all granted',
      }
    } else {
      $_directory_version = {
        order => 'allow,deny',
        allow => 'from all',
      }
    }

    $_directories = [ merge($_directory, $_directory_version) ]
  } else {
    $_directories = undef
  }

  ## Create a global LocationMatch if locations aren't defined
  if $modsec_disable_ids {
    if $modsec_disable_ids =~ Array {
      $_modsec_disable_ids = { '.*' => $modsec_disable_ids }
    } else {
      $_modsec_disable_ids = $modsec_disable_ids
    }
  }

  if $modsec_disable_msgs {
    if $modsec_disable_msgs =~ Array {
      $_modsec_disable_msgs = { '.*' => $modsec_disable_msgs }
    } else {
      $_modsec_disable_msgs = $modsec_disable_msgs
    }
  }

  if $modsec_disable_tags {
    if $modsec_disable_tags =~ Array {
      $_modsec_disable_tags = { '.*' => $modsec_disable_tags }
    } else {
      $_modsec_disable_tags = $modsec_disable_tags
    }
  }

  concat { "${priority_real}${filename}.conf":
    ensure  => $ensure,
    path    => "${::apache::vhost_dir}/${priority_real}${filename}.conf",
    owner   => 'root',
    group   => $::apache::params::root_group,
    mode    => $::apache::file_mode,
    order   => 'numeric',
    require => Package['httpd'],
    notify  => Class['apache::service'],
  }
  # NOTE(pabelanger): This code is duplicated in ::apache::vhost::custom and
  # needs to be converted into something generic.
  if $::apache::vhost_enable_dir {
    $vhost_enable_dir = $::apache::vhost_enable_dir
    $vhost_symlink_ensure = $ensure ? {
      present => link,
      default => $ensure,
    }
    file{ "${priority_real}${filename}.conf symlink":
      ensure  => $vhost_symlink_ensure,
      path    => "${vhost_enable_dir}/${priority_real}${filename}.conf",
      target  => "${::apache::vhost_dir}/${priority_real}${filename}.conf",
      owner   => 'root',
      group   => $::apache::params::root_group,
      mode    => $::apache::file_mode,
      require => Concat["${priority_real}${filename}.conf"],
      notify  => Class['apache::service'],
    }
  }

  # Template uses:
  # - $comment
  # - $nvh_addr_port
  # - $servername
  # - $serveradmin
  # - $protocols
  # - $protocols_honor_order
  # - $apache_version
  concat::fragment { "${name}-apache-header":
    target  => "${priority_real}${filename}.conf",
    order   => 0,
    content => template('apache/vhost/_file_header.erb'),
  }

  # Template uses:
  # - $virtual_docroot
  # - $docroot
  if $docroot {
    concat::fragment { "${name}-docroot":
      target  => "${priority_real}${filename}.conf",
      order   => 10,
      content => template('apache/vhost/_docroot.erb'),
    }
  }

  # Template uses:
  # - $aliases
  if $aliases and ! empty($aliases) {
    concat::fragment { "${name}-aliases":
      target  => "${priority_real}${filename}.conf",
      order   => 20,
      content => template('apache/vhost/_aliases.erb'),
    }
  }

  # Template uses:
  # - $itk
  # - $::kernelversion
  if $itk and ! empty($itk) {
    concat::fragment { "${name}-itk":
      target  => "${priority_real}${filename}.conf",
      order   => 30,
      content => template('apache/vhost/_itk.erb'),
    }
  }

  # Template uses:
  # - $fallbackresource
  if $fallbackresource {
    concat::fragment { "${name}-fallbackresource":
      target  => "${priority_real}${filename}.conf",
      order   => 40,
      content => template('apache/vhost/_fallbackresource.erb'),
    }
  }

  # Template uses:
  # - $allow_encoded_slashes
  if $allow_encoded_slashes {
    concat::fragment { "${name}-allow_encoded_slashes":
      target  => "${priority_real}${filename}.conf",
      order   => 50,
      content => template('apache/vhost/_allow_encoded_slashes.erb'),
    }
  }

  # Template uses:
  # - $_directories
  # - $docroot
  # - $apache_version
  # - $suphp_engine
  # - $shibboleth_enabled
  if $_directories and ! empty($_directories) {
    concat::fragment { "${name}-directories":
      target  => "${priority_real}${filename}.conf",
      order   => 60,
      content => template('apache/vhost/_directories.erb'),
    }
  }

  # Template uses:
  # - $additional_includes
  if $additional_includes and ! empty($additional_includes) {
    concat::fragment { "${name}-additional_includes":
      target  => "${priority_real}${filename}.conf",
      order   => 70,
      content => template('apache/vhost/_additional_includes.erb'),
    }
  }

  # Template uses:
  # - $error_log
  # - $error_log_format24
  # - $log_level
  # - $error_log_destination
  # - $log_level
  if $error_log or $log_level {
    concat::fragment { "${name}-logging":
      target  => "${priority_real}${filename}.conf",
      order   => 80,
      content => template('apache/vhost/_logging.erb'),
    }
  }

  # Template uses no variables
  concat::fragment { "${name}-serversignature":
    target  => "${priority_real}${filename}.conf",
    order   => 90,
    content => template('apache/vhost/_serversignature.erb'),
  }

  # Template uses:
  # - $access_log
  # - $_access_log_env_var
  # - $access_log_destination
  # - $_access_log_format
  # - $_access_log_env_var
  # - $access_logs
  if $access_log or $access_logs {
    concat::fragment { "${name}-access_log":
      target  => "${priority_real}${filename}.conf",
      order   => 100,
      content => template('apache/vhost/_access_log.erb'),
    }
  }

  # Template uses:
  # - $action
  if $action {
    concat::fragment { "${name}-action":
      target  => "${priority_real}${filename}.conf",
      order   => 110,
      content => template('apache/vhost/_action.erb'),
    }
  }

  # Template uses:
  # - $block
  # - $apache_version
  if $block and ! empty($block) {
    concat::fragment { "${name}-block":
      target  => "${priority_real}${filename}.conf",
      order   => 120,
      content => template('apache/vhost/_block.erb'),
    }
  }

  # Template uses:
  # - $error_documents
  if $error_documents and ! empty($error_documents) {
    concat::fragment { "${name}-error_document":
      target  => "${priority_real}${filename}.conf",
      order   => 130,
      content => template('apache/vhost/_error_document.erb'),
    }
  }

  # Template uses:
  # - $headers
  if $headers and ! empty($headers) {
    concat::fragment { "${name}-header":
      target  => "${priority_real}${filename}.conf",
      order   => 140,
      content => template('apache/vhost/_header.erb'),
    }
  }

  # Template uses:
  # - $request_headers
  if $request_headers and ! empty($request_headers) {
    concat::fragment { "${name}-requestheader":
      target  => "${priority_real}${filename}.conf",
      order   => 150,
      content => template('apache/vhost/_requestheader.erb'),
    }
  }

  # Template uses:
  # - $ssl_proxyengine
  # - $ssl_proxy_verify
  # - $ssl_proxy_verify_depth
  # - $ssl_proxy_ca_cert
  # - $ssl_proxy_check_peer_cn
  # - $ssl_proxy_check_peer_name
  # - $ssl_proxy_check_peer_expire
  # - $ssl_proxy_machine_cert
  # - $ssl_proxy_protocol
  if $ssl_proxyengine {
    concat::fragment { "${name}-sslproxy":
      target  => "${priority_real}${filename}.conf",
      order   => 160,
      content => template('apache/vhost/_sslproxy.erb'),
    }
  }

  # Template uses:
  # - $proxy_dest
  # - $proxy_pass
  # - $proxy_pass_match
  # - $proxy_preserve_host
  # - $proxy_add_headers
  # - $no_proxy_uris
  if $proxy_dest or $proxy_pass or $proxy_pass_match or $proxy_dest_match or $proxy_preserve_host {
    concat::fragment { "${name}-proxy":
      target  => "${priority_real}${filename}.conf",
      order   => 170,
      content => template('apache/vhost/_proxy.erb'),
    }
  }

  # Template uses:
  # - $redirect_source
  # - $redirect_dest
  # - $redirect_status
  # - $redirect_dest_a
  # - $redirect_source_a
  # - $redirect_status_a
  # - $redirectmatch_status
  # - $redirectmatch_regexp
  # - $redirectmatch_dest
  # - $redirectmatch_status_a
  # - $redirectmatch_regexp_a
  # - $redirectmatch_dest
  if ($redirect_source and $redirect_dest) or ($redirectmatch_regexp and $redirectmatch_dest) {
    concat::fragment { "${name}-redirect":
      target  => "${priority_real}${filename}.conf",
      order   => 180,
      content => template('apache/vhost/_redirect.erb'),
    }
  }

  # Template uses:
  # - $rewrites
  # - $rewrite_base
  # - $rewrite_rule
  # - $rewrite_cond
  # - $rewrite_map
  if $rewrites or $rewrite_rule {
    concat::fragment { "${name}-rewrite":
      target  => "${priority_real}${filename}.conf",
      order   => 190,
      content => template('apache/vhost/_rewrite.erb'),
    }
  }

  # Template uses:
  # - $scriptaliases
  # - $scriptalias
  if ( $scriptalias or $scriptaliases != [] ) {
    concat::fragment { "${name}-scriptalias":
      target  => "${priority_real}${filename}.conf",
      order   => 200,
      content => template('apache/vhost/_scriptalias.erb'),
    }
  }

  # Template uses:
  # - $serveraliases
  if $serveraliases and ! empty($serveraliases) {
    concat::fragment { "${name}-serveralias":
      target  => "${priority_real}${filename}.conf",
      order   => 210,
      content => template('apache/vhost/_serveralias.erb'),
    }
  }

  # Template uses:
  # - $setenv
  # - $setenvif
  if ($use_env_mod or $use_setenvif_mod) {
    concat::fragment { "${name}-setenv":
      target  => "${priority_real}${filename}.conf",
      order   => 220,
      content => template('apache/vhost/_setenv.erb'),
    }
  }

  # Template uses:
  # - $ssl
  # - $ssl_cert
  # - $ssl_key
  # - $ssl_chain
  # - $ssl_certs_dir
  # - $ssl_ca
  # - $ssl_crl_path
  # - $ssl_crl
  # - $ssl_crl_check
  # - $ssl_protocol
  # - $ssl_cipher
  # - $ssl_honorcipherorder
  # - $ssl_verify_client
  # - $ssl_verify_depth
  # - $ssl_options
  # - $ssl_openssl_conf_cmd
  # - $ssl_stapling
  # - $apache_version
  if $ssl {
    concat::fragment { "${name}-ssl":
      target  => "${priority_real}${filename}.conf",
      order   => 230,
      content => template('apache/vhost/_ssl.erb'),
    }
  }

  # Template uses:
  # - $auth_kerb
  # - $krb_method_negotiate
  # - $krb_method_k5passwd
  # - $krb_authoritative
  # - $krb_auth_realms
  # - $krb_5keytab
  # - $krb_local_user_mapping
  if $auth_kerb {
    concat::fragment { "${name}-auth_kerb":
      target  => "${priority_real}${filename}.conf",
      order   => 230,
      content => template('apache/vhost/_auth_kerb.erb'),
    }
  }

  # Template uses:
  # - $suphp_engine
  # - $suphp_addhandler
  # - $suphp_configpath
  if $suphp_engine == 'on' {
    concat::fragment { "${name}-suphp":
      target  => "${priority_real}${filename}.conf",
      order   => 240,
      content => template('apache/vhost/_suphp.erb'),
    }
  }

  # Template uses:
  # - $php_values
  # - $php_flags
  if ($php_values and ! empty($php_values)) or ($php_flags and ! empty($php_flags)) {
    concat::fragment { "${name}-php":
      target  => "${priority_real}${filename}.conf",
      order   => 240,
      content => template('apache/vhost/_php.erb'),
    }
  }

  # Template uses:
  # - $php_admin_values
  # - $php_admin_flags
  if ($php_admin_values and ! empty($php_admin_values)) or ($php_admin_flags and ! empty($php_admin_flags)) {
    concat::fragment { "${name}-php_admin":
      target  => "${priority_real}${filename}.conf",
      order   => 250,
      content => template('apache/vhost/_php_admin.erb'),
    }
  }

  # Template uses:
  # - $wsgi_application_group
  # - $wsgi_daemon_process
  # - $wsgi_daemon_process_options
  # - $wsgi_import_script
  # - $wsgi_import_script_options
  # - $wsgi_process_group
  # - $wsgi_script_aliases
  # - $wsgi_pass_authorization
  if $wsgi_daemon_process_options {
    deprecation('apache::vhost::wsgi_daemon_process_options', 'This parameter is deprecated. Please add values inside Hash `wsgi_daemon_process`.')
  }
  if $wsgi_application_group or $wsgi_daemon_process or ($wsgi_import_script and $wsgi_import_script_options) or $wsgi_process_group or ($wsgi_script_aliases and ! empty($wsgi_script_aliases)) or $wsgi_pass_authorization {
    concat::fragment { "${name}-wsgi":
      target  => "${priority_real}${filename}.conf",
      order   => 260,
      content => template('apache/vhost/_wsgi.erb'),
    }
  }

  # Template uses:
  # - $custom_fragment
  if $custom_fragment {
    concat::fragment { "${name}-custom_fragment":
      target  => "${priority_real}${filename}.conf",
      order   => 270,
      content => template('apache/vhost/_custom_fragment.erb'),
    }
  }

  # Template uses:
  # - $fastcgi_server
  # - $fastcgi_socket
  # - $fastcgi_dir
  # - $fastcgi_idle_timeout
  # - $apache_version
  if $fastcgi_server or $fastcgi_dir {
    concat::fragment { "${name}-fastcgi":
      target  => "${priority_real}${filename}.conf",
      order   => 280,
      content => template('apache/vhost/_fastcgi.erb'),
    }
  }

  # Template uses:
  # - $suexec_user_group
  if $suexec_user_group {
    concat::fragment { "${name}-suexec":
      target  => "${priority_real}${filename}.conf",
      order   => 290,
      content => template('apache/vhost/_suexec.erb'),
    }
  }

  if $h2_copy_files != undef or $h2_direct != undef or $h2_early_hints != undef or $h2_max_session_streams != undef or $h2_modern_tls_only != undef or $h2_push != undef or $h2_push_diary_size != undef or $h2_push_priority != [] or $h2_push_resource != [] or $h2_serialize_headers != undef or $h2_stream_max_mem_size != undef or $h2_tls_cool_down_secs != undef or $h2_tls_warm_up_size != undef or $h2_upgrade != undef or $h2_window_size != undef {
    include ::apache::mod::http2

    concat::fragment { "${name}-http2":
      target  => "${priority_real}${filename}.conf",
      order   => 300,
      content => template('apache/vhost/_http2.erb'),
    }
  }

  # Template uses:
  # - $passenger_spawn_method
  # - $passenger_app_root
  # - $passenger_app_env
  # - $passenger_ruby
  # - $passenger_min_instances
  # - $passenger_max_requests
  # - $passenger_start_timeout
  # - $passenger_user
  # - $passenger_group
  # - $passenger_nodejs
  # - $passenger_sticky_sessions
  # - $passenger_startup_file
  if $passenger_spawn_method or $passenger_app_root or $passenger_app_env or $passenger_ruby or $passenger_min_instances or $passenger_start_timeout or $passenger_user or $passenger_group or $passenger_nodejs or $passenger_sticky_sessions or $passenger_startup_file{
    concat::fragment { "${name}-passenger":
      target  => "${priority_real}${filename}.conf",
      order   => 300,
      content => template('apache/vhost/_passenger.erb'),
    }
  }

  # Template uses:
  # - $add_default_charset
  if $add_default_charset {
    concat::fragment { "${name}-charsets":
      target  => "${priority_real}${filename}.conf",
      order   => 310,
      content => template('apache/vhost/_charsets.erb'),
    }
  }

  # Template uses:
  # - $modsec_disable_vhost
  # - $modsec_disable_ids
  # - $modsec_disable_ips
  # - $modsec_disable_msgs
  # - $modsec_disable_tags
  # - $modsec_body_limit
  # - $modsec_audit_log_destination
  if $modsec_disable_vhost or $modsec_disable_ids or $modsec_disable_ips or $modsec_disable_msgs or $modsec_disable_tags or $modsec_audit_log_destination {
    concat::fragment { "${name}-security":
      target  => "${priority_real}${filename}.conf",
      order   => 320,
      content => template('apache/vhost/_security.erb'),
    }
  }

  # Template uses:
  # - $filters
  if $filters and ! empty($filters) {
    concat::fragment { "${name}-filters":
      target  => "${priority_real}${filename}.conf",
      order   => 330,
      content => template('apache/vhost/_filters.erb'),
    }
  }

  # Template uses:
  # - $jk_mounts
  if $jk_mounts and ! empty($jk_mounts) {
    concat::fragment { "${name}-jk_mounts":
      target  => "${priority_real}${filename}.conf",
      order   => 340,
      content => template('apache/vhost/_jk_mounts.erb'),
    }
  }

  # Template uses:
  # - $keepalive
  # - $keepalive_timeout
  # - $max_keepalive_requests
  if $keepalive or $keepalive_timeout or $max_keepalive_requests {
    concat::fragment { "${name}-keepalive_options":
      target  => "${priority_real}${filename}.conf",
      order   => 350,
      content => template('apache/vhost/_keepalive_options.erb'),
    }
  }

  # Template uses:
  # - $cas_*
  if $cas_enabled {
    concat::fragment { "${name}-auth_cas":
      target  => "${priority_real}${filename}.conf",
      order   => 350,
      content => template('apache/vhost/_auth_cas.erb'),
    }
  }

  # Template uses:
  # - $http_protocol_options
  if $http_protocol_options {
    concat::fragment { "${name}-http_protocol_options":
      target  => "${priority_real}${filename}.conf",
      order   => 350,
      content => template('apache/vhost/_http_protocol_options.erb'),
    }
  }

  # Template uses:
  # - $auth_oidc
  # - $oidc_settings
  if $auth_oidc {
    concat::fragment { "${name}-auth_oidc":
      target  => "${priority_real}${filename}.conf",
      order   => 360,
      content => template('apache/vhost/_auth_oidc.erb'),
    }
  }

  # Template uses:
  # - $shib_compat_valid_user
  if $shibboleth_enabled {
    concat::fragment { "${name}-shibboleth":
      target  => "${priority_real}${filename}.conf",
      order   => 370,
      content => template('apache/vhost/_shib.erb'),
    }
  }

  # - $use_canonical_name
  if $use_canonical_name {
    concat::fragment { "${name}-use_canonical_name":
      target  => "${priority_real}${filename}.conf",
      order   => 360,
      content => template('apache/vhost/_use_canonical_name.erb'),
    }
  }

  # Template uses no variables
  concat::fragment { "${name}-file_footer":
    target  => "${priority_real}${filename}.conf",
    order   => 999,
    content => template('apache/vhost/_file_footer.erb'),
  }
}
