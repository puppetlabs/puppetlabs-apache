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
# @param access_log
#   Determines whether to configure `*_access.log` directives (`*_file`, `*_pipe`, or `*_syslog`).
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
# @param cas_cookie_path
#   Sets the location where information on the current session should be stored. This should
#   be writable by the web server only.
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
# @param show_diff
#   Specifies whether to set the show_diff parameter for the file resource.
#
# @param fallbackresource
#   Sets the [FallbackResource](https://httpd.apache.org/docs/current/mod/mod_dir.html#fallbackresource) 
#   directive, which specifies an action to take for any URL that doesn't map to anything in 
#   your filesystem and would otherwise return 'HTTP 404 (Not Found)'. Values must either begin 
#   with a `/` or be `disabled`.
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
#     directories            => [
#       {
#         path         => '/var/www/html',
#         auth_name    => 'Kerberos Login',
#         auth_type    => 'Kerberos',
#         auth_require => 'valid-user',
#       },
#     ],
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
# @param modsec_inbound_anomaly_threshold
#   Override the global scoring threshold level of the inbound blocking rules
#   for the Collaborative Detection Mode in the OWASP ModSecurity Core Rule
#   Set.
#
# @param modsec_outbound_anomaly_threshold
#   Override the global scoring threshold level of the outbound blocking rules
#   for the Collaborative Detection Mode in the OWASP ModSecurity Core Rule
#   Set.
#
# @param modsec_allowed_methods
#   Override global allowed methods. A space-separated list of allowed HTTP methods.
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
#   Sets the [`Options`](https://httpd.apache.org/docs/current/mod/core.html#options) for the specified virtual host. For example:
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     ...
#     options => ['Indexes', 'FollowSymLinks', 'MultiViews'],
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
#   Sets [PassengerBaseURI](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerbase_rui),
#    to specify that the given URI is a distinct application served by Passenger.
#
# @param passenger_ruby
#   Sets [PassengerRuby](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerruby),
#   specifying the Ruby interpreter to use when serving the relevant web applications.
#
# @param passenger_python
#   Sets [PassengerPython](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerpython),
#   specifying the Python interpreter to use when serving the relevant web applications.
#
# @param passenger_nodejs
#   Sets the [`PassengerNodejs`](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengernodejs),
#   specifying Node.js command to use when serving the relevant web applications.
#
# @param passenger_meteor_app_settings
#   Sets [PassengerMeteorAppSettings](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengermeteorappsettings),
#   specifying a JSON file with settings for the application when using a Meteor 
#   application in non-bundled mode.
#
# @param passenger_app_env
#   Sets [PassengerAppEnv](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerappenv),
#   the environment for the Passenger application. If not specified, defaults to the global 
#   setting or 'production'.
#
# @param passenger_app_root
#   Sets [PassengerRoot](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerapproot),
#   the location of the Passenger application root if different from the DocumentRoot.
#
# @param passenger_app_group_name
#   Sets [PassengerAppGroupName](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerappgroupname),
#    the name of the application group that the current application should belong to.
#
# @param passenger_app_start_command
#   Sets [PassengerAppStartCommand](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerappstartcommand),
#    how Passenger should start your app on a specific port.
#
# @param passenger_app_type
#   Sets [PassengerAppType](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerapptype),
#    to force Passenger to recognize the application as a specific type.
#
# @param passenger_startup_file
#   Sets the [PassengerStartupFile](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerstartupfile),
#   path. This path is relative to the application root.
#
# @param passenger_restart_dir
#   Sets the [PassengerRestartDir](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerrestartdir),
#    to customize the directory in which `restart.txt` is searched for.
#
# @param passenger_spawn_method
#   Sets [PassengerSpawnMethod](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerspawnmethod),
#   whether Passenger spawns applications directly, or using a prefork copy-on-write mechanism.
#
# @param passenger_load_shell_envvars
#   Sets [PassengerLoadShellEnvvars](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerloadshellenvvars),
#   to enable or disable the loading of shell environment variables before spawning the application.
#
# @param passenger_preload_bundler
#   Sets [PassengerPreloadBundler](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerpreloadbundler),
#   to enable or disable the loading of bundler before loading the application.
#
# @param passenger_rolling_restarts
#   Sets [PassengerRollingRestarts](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerrollingrestarts),
#   to enable or disable support for zero-downtime application restarts through `restart.txt`.
#
# @param passenger_resist_deployment_errors
#   Sets [PassengerResistDeploymentErrors](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerresistdeploymenterrors),
#   to enable or disable resistance against deployment errors.
#
# @param passenger_user
#   Sets [PassengerUser](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengeruser),
#   the running user for sandboxing applications.
#
# @param passenger_group
#   Sets [PassengerGroup](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengergroup),
#   the running group for sandboxing applications.
#
# @param passenger_friendly_error_pages
#   Sets [PassengerFriendlyErrorPages](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerfriendlyerrorpages),
#   which can display friendly error pages whenever an application fails to start. This 
#   friendly error page presents the startup error message, some suggestions for solving 
#   the problem, a backtrace and a dump of the environment variables.
#
# @param passenger_min_instances
#   Sets [PassengerMinInstances](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengermininstances),
#   the minimum number of application processes to run.
#
# @param passenger_max_instances
#   Sets [PassengerMaxInstances](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengermaxinstances),
#   the maximum number of application processes to run.
#
# @param passenger_max_preloader_idle_time
#   Sets [PassengerMaxPreloaderIdleTime](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengermaxpreloaderidletime),
#   the maximum amount of time the preloader waits before shutting down an idle process.
#
# @param passenger_force_max_concurrent_requests_per_process
#   Sets [PassengerForceMaxConcurrentRequestsPerProcess](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerforcemaxconcurrentrequestsperprocess),
#   the maximum amount of concurrent requests the application can handle per process.
#
# @param passenger_start_timeout
#   Sets [PassengerStartTimeout](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerstarttimeout),
#   the timeout for the application startup.
#
# @param passenger_concurrency_model
#   Sets [PassengerConcurrencyModel](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerconcurrencyodel),
#   to specify the I/O concurrency model that should be used for Ruby application processes. 
#   Passenger supports two concurrency models:<br />
#   * `process` - single-threaded, multi-processed I/O concurrency.
#   * `thread` - multi-threaded, multi-processed I/O concurrency.
#
# @param passenger_thread_count
#   Sets [PassengerThreadCount](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerthreadcount),
#   the number of threads that Passenger should spawn per Ruby application process.<br />
#   This option only has effect if PassengerConcurrencyModel is `thread`.
#
# @param passenger_max_requests
#   Sets [PassengerMaxRequests](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengermaxrequests),
#   the maximum number of requests an application process will process.
#
# @param passenger_max_request_time
#   Sets [PassengerMaxRequestTime](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengermaxrequesttime),
#   the maximum amount of time, in seconds, that an application process may take to 
#   process a request.
#
# @param passenger_memory_limit
#   Sets [PassengerMemoryLimit](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengermemorylimit),
#   the maximum amount of memory that an application process may use, in megabytes.
#
# @param passenger_stat_throttle_rate
#   Sets [PassengerStatThrottleRate](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerstatthrottlerate),
#   to set a limit, in seconds, on how often Passenger will perform it's filesystem checks.
#
# @param passenger_pre_start
#   Sets [PassengerPreStart](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerprestart),
#   the URL of the application if pre-starting is required.
#
# @param passenger_high_performance
#   Sets [PassengerHighPerformance](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerhighperformance),
#   to enhance performance in return for reduced compatibility.
#
# @param passenger_buffer_upload
#   Sets [PassengerBufferUpload](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerbufferupload),
#   to buffer HTTP client request bodies before they are sent to the application.
#
# @param passenger_buffer_response
#   Sets [PassengerBufferResponse](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerbufferresponse),
#   to buffer Happlication-generated responses.
#
# @param passenger_error_override
#   Sets [PassengerErrorOverride](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengererroroverride),
#   to specify whether Apache will intercept and handle response with HTTP status codes of
#   400 and higher.
#
# @param passenger_max_request_queue_size
#   Sets [PassengerMaxRequestQueueSize](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengermaxrequestqueuesize),
#   to specify the maximum amount of requests that are allowed to queue whenever the maximum
#   concurrent request limit is reached. If the queue is already at this specified limit, then 
#   Passenger immediately sends a "503 Service Unavailable" error to any incoming requests.<br />
#   A value of 0 means that the queue size is unbounded.
#
# @param passenger_max_request_queue_time
#   Sets [PassengerMaxRequestQueueTime](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengermaxrequestqueuetime),
#   to specify the maximum amount of time that requests are allowed to stay in the queue 
#   whenever the maximum concurrent request limit is reached. If a request reaches this specified 
#   limit, then Passenger immeaditly sends a "504 Gateway Timeout" error for that request.<br />
#   A value of 0 means that the queue time is unbounded.
#
# @param passenger_sticky_sessions
#   Sets [PassengerStickySessions](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerstickysessions),
#   to specify that, whenever possible, all requests sent by a client will be routed to the same 
#   originating application process.
#
# @param passenger_sticky_sessions_cookie_name
#   Sets [PassengerStickySessionsCookieName](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerstickysessionscookiename),
#   to specify the name of the sticky sessions cookie.
#
# @param passenger_sticky_sessions_cookie_attributes
#   Sets [PassengerStickySessionsCookieAttributes](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerstickysessionscookieattributes),
#   the attributes of the sticky sessions cookie.
#
# @param passenger_allow_encoded_slashes
#   Sets [PassengerAllowEncodedSlashes](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerallowencodedslashes),
#   to allow URLs with encoded slashes. Please note that this feature will not work properly
#   unless Apache's `AllowEncodedSlashes` is also enabled.
#
# @param passenger_app_log_file
#   Sets [PassengerAppLogFile](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerapplogfile),
#   app specific messages logged to a different file in addition to Passenger log file.
#
# @param passenger_debugger
#   Sets [PassengerDebugger](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerdebugger),
#   to turn support for Ruby application debugging on or off. 
#
# @param passenger_lve_min_uid
#   Sets [PassengerLveMinUid](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerlveminuid),
#   to only allow the spawning of application processes with UIDs equal to, or higher than, this 
#   specified value on LVE-enabled kernels.
#
# @param passenger_dump_config_manifest
#   Sets [PassengerLveMinUid](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengerlveminuid),
#   to dump the configuration manifest to a file.
#
# @param passenger_admin_panel_url
#   Sets [PassengerAdminPanelUrl](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengeradminpanelurl),
#   to specify the URL of the Passenger admin panel.
#
# @param passenger_admin_panel_auth_type
#   Sets [PassengerAdminPanelAuthType](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengeradminpanelauthtype),
#   to specify the authentication type for the Passenger admin panel.
#
# @param passenger_admin_panel_username
#   Sets [PassengerAdminPanelUsername](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengeradminpanelusername),
#   to specify the username for the Passenger admin panel.
#
# @param passenger_admin_panel_password
#   Sets [PassengerAdminPanelPassword](https://www.phusionpassenger.com/docs/references/config_reference/apache/#passengeradminpanelpassword),
#   to specify the password for the Passenger admin panel.
#
# @param php_values
#   Allows per-virtual host setting [`php_value`s](http://php.net/manual/en/configuration.changes.php). 
#   These flags or values can be overwritten by a user or an application.
#   Within a vhost declaration:
#   ``` puppet
#     php_values    => { 'include_path' => '.:/usr/local/example-app/include' },
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
#   aware that the `default_vhost` parameter for `apache::vhost` passes a priority of 15.<br />
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
#     ...
#     proxy_pass => [
#       { 'path' => '/a', 'url' => 'http://backend-a/' },
#       { 'path' => '/b', 'url' => 'http://backend-b/' },
#       { 'path' => '/c', 'url' => 'http://backend-a/c', 'params' => {'max'=>20, 'ttl'=>120, 'retry'=>300}},
#       { 'path' => '/l', 'url' => 'http://backend-xy',
#         'reverse_urls' => ['http://backend-x', 'http://backend-y'] },
#       { 'path' => '/d', 'url' => 'http://backend-a/d',
#         'params' => { 'retry' => 0, 'timeout' => 5 }, },
#       { 'path' => '/e', 'url' => 'http://backend-a/e',
#         'keywords' => ['nocanon', 'interpolate'] },
#       { 'path' => '/f', 'url' => 'http://backend-f/',
#         'setenv' => ['proxy-nokeepalive 1', 'force-proxy-request-1.0 1']},
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
#     ...
#     redirect_source => ['/images', '/downloads'],
#     redirect_dest   => ['http://img.example.com/', 'http://downloads.example.com/'],
#   }
#   ```
#
# @param redirect_status
#   Specifies the status to append to the redirect.
#   ``` puppet
#     apache::vhost { 'site.name.fdqn':
#     ...
#     redirect_status => ['temp', 'permanent'],
#   }
#   ```
#
# @param redirectmatch_regexp
#   Determines which server status should be raised for a given regular expression 
#   and where to forward the user to. Entered as an array alongside redirectmatch_status 
#   and redirectmatch_dest.
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     ...
#     redirectmatch_status => ['404', '404'],
#     redirectmatch_regexp => ['\.git(/.*|$)/', '\.svn(/.*|$)'],
#     redirectmatch_dest => ['http://www.example.com/$1', 'http://www.example.com/$2'],
#   }
#   ```
#
# @param redirectmatch_status
#   Determines which server status should be raised for a given regular expression 
#   and where to forward the user to. Entered as an array alongside redirectmatch_regexp 
#   and redirectmatch_dest.
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     ...
#     redirectmatch_status => ['404', '404'],
#     redirectmatch_regexp => ['\.git(/.*|$)/', '\.svn(/.*|$)'],
#     redirectmatch_dest => ['http://www.example.com/$1', 'http://www.example.com/$2'],
#   }
#   ```
#
# @param redirectmatch_dest
#   Determines which server status should be raised for a given regular expression 
#   and where to forward the user to. Entered as an array alongside redirectmatch_status 
#   and redirectmatch_regexp.
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     ...
#     redirectmatch_status => ['404', '404'],
#     redirectmatch_regexp => ['\.git(/.*|$)/', '\.svn(/.*|$)'],
#     redirectmatch_dest => ['http://www.example.com/$1', 'http://www.example.com/$2'],
#   }
#   ```
#
# @param request_headers
#   Modifies collected [request headers](https://httpd.apache.org/docs/current/mod/mod_headers.html#requestheader) 
#   in various ways, including adding additional request headers, removing request headers, 
#   and so on.
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     ...
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
#     ...
#     rewrites => [ { rewrite_rule => ['^index\.html$ welcome.html'] } ]
#   }
#   ```
#   The parameter allows rewrite conditions that, when `true`, execute the associated rule. 
#   For instance, if you wanted to rewrite URLs only if the visitor is using IE
#   ``` puppet
#   apache::vhost { 'site.name.fdqn':
#     ...
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
#     ...
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
#     ...
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
#     ...
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
# @param vhost_name
#   Enables name-based virtual hosting. If no IP is passed to the virtual host, but the 
#   virtual host is assigned a port, then the virtual host name is `vhost_name:port`. 
#   If the virtual host has no assigned IP or port, the virtual host name is set to the 
#   title of the resource.
#
# @param virtual_docroot
#   Sets up a virtual host with a wildcard alias subdomain mapped to a directory with the 
#   same name. For example, `http://example.com` would map to `/var/www/example.com`.
#   Note that the `DocumentRoot` directive will not be present even though there is a value
#   set for `docroot` in the manifest. See [`virtual_use_default_docroot`](#virtual_use_default_docroot) to change this behavior.
#   ``` puppet
#   apache::vhost { 'subdomain.loc':
#     vhost_name      => '*',
#     port            => 80,
#     virtual_docroot => '/var/www/%-2+',
#     docroot         => '/var/www',
#     serveraliases   => ['*.loc',],
#   }
#   ```
#
# @param virtual_use_default_docroot
#   By default, when using `virtual_docroot`, the value of `docroot` is ignored. Setting this
#   to `true` will mean both directives will be added to the configuration.
#   ``` puppet
#   apache::vhost { 'subdomain.loc':
#     vhost_name                  => '*',
#     port                        => 80,
#     virtual_docroot             => '/var/www/%-2+',
#     docroot                     => '/var/www',
#     virtual_use_default_docroot => true,
#     serveraliases               => ['*.loc',],
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
#     port                        => 80,
#     docroot                     => '/var/www/pythonapp',
#     wsgi_daemon_process         => {
#       'wsgi' => {
#         processes    => '2',
#         threads      => '15',
#         display-name => '%{GROUP}',
#       },
#       'foo' => {},
#     },
#     wsgi_process_group          => 'wsgi',
#     wsgi_script_aliases         => { '/' => '/var/www/demo.wsgi' },
#     wsgi_chunked_request        => 'On',
#   }
#   ```
#
# @param wsgi_daemon_process_options
#   Depricated, move to wsgi_daemon_process
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
#   proxy_pass and proxy_pass_match are supported like their parameters to apache::vhost, and will
#   be rendered without their path parameter as this will be inherited from the Location/LocationMatch container.
#   An example use of `directories`:
#   ``` puppet
#   apache::vhost { 'files.example.net':
#     docroot     => '/var/www/files',
#     directories => [
#       { 'path'     => '/var/www/files',
#         'provider' => 'files',
#         'deny'     => 'from all',
#       },
#       { 'path'           => '/var/www/html',
#         'provider'       => 'directory',
#         'options'        => ['-Indexes'],
#         'allow_override' => ['All'],
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
#   The `directories` param can accepts the different authentication ways, including `gssapi`, `Basic (authz_core)`, 
#   and others.
#
#     * `gssapi` - Specifies mod_auth_gssapi parameters for particular directories in a virtual host directory
#       TODO: check, if this Documentation is obsolete
#
#       ```puppet
#       apache::vhost { 'sample.example.net':
#         docroot     => '/path/to/directory',
#         directories => [
#           { path   => '/path/to/different/dir',
#             gssapi => {
#               acceptor_name            => '{HOSTNAME}',
#               allowed_mech             => ['krb5', 'iakerb', 'ntlmssp'],
#               authname                 => 'Kerberos 5',
#               authtype                 => 'GSSAPI',
#               basic_auth               => true,
#               basic_auth_mech          => ['krb5', 'iakerb', 'ntlmssp'],
#               basic_ticket_timeout     => 300,
#               connection_bound         => true,
#               cred_store               => {
#                 ccache        => ['/path/to/directory'],
#                 client_keytab => ['/path/to/example.keytab'],
#                 keytab        => ['/path/to/example.keytab'],
#               },
#               deleg_ccache_dir         => '/path/to/directory',
#               deleg_ccache_env_var     => 'KRB5CCNAME',
#               deleg_ccache_perms       => {
#                 mode => '0600',
#                 uid  => 'example-user',
#                 gid  => 'example-group',
#               },
#               deleg_ccache_unique      => true,
#               impersonate              => true,
#               local_name               => true,
#               name_attributes          => 'json',
#               negotiate_once           => true,
#               publish_errors           => true,
#               publish_mech             => true,
#               required_name_attributes =>	'auth-indicators=high',
#               session_key              => 'file:/path/to/example.key',
#               signal_persistent_auth   => true,
#               ssl_only                 => true,
#               use_s4u2_proxy           => true,
#               use_sessions             => true,
#             }
#           },
#         ],
#       }
#       ```
#
#     * `Basic` - Specifies mod_authz_core parameters for particular directories in a virtual host directory
#       ```puppet
#       apache::vhost { 'sample.example.net':
#         docroot     => '/path/to/directory',
#         directories => [
#           {
#             path        => '/path/to/different/dir',
#             auth_type => 'Basic',
#             authz_core  => {
#               require_all => {
#                 'require_any' => {
#                   'require' => ['user superadmin'],
#                   'require_all' => {
#                     'require' => ['group admins', 'ldap-group "cn=Administrators,o=Airius"'],
#                   },
#                 },
#                 'require_none' => {
#                   'require' => ['group temps', 'ldap-group "cn=Temporary Employees,o=Airius"']
#                 }
#               }
#             }
#           },
#         ],
#       }
#       ```
#
# @param custom_fragment
#   Pass a string of custom configuration directives to be placed at the end of the directory 
#   configuration.
#   ``` puppet
#   apache::vhost { 'monitor':
#     ...
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
# @param headers
#   Adds lines for [Header](https://httpd.apache.org/docs/current/mod/mod_headers.html#header) directives.
#   ``` puppet
#   apache::vhost { 'sample.example.net':
#     docroot     => '/path/to/directory',
#     directories => [
#       {
#         path    => '/path/to/directory',
#         headers => 'Set X-Robots-Tag "noindex, noarchive, nosnippet"',
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
#   for authentication.
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
#   Specifies the location of the SSL certification directory to verify client certs.
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
#     ...
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
#     ...
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
#     ...
#     ssl_proxy_machine_cert => '/etc/httpd/ssl/client_certificate.pem',
#   }
#   ```
# @param ssl_proxy_machine_cert_chain
#   Sets the [SSLProxyMachineCertificateChainFile](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslproxymachinecertificatechainfile)
#   directive, which specifies an all-in-one file where you keep the certificate chain for
#   all of the client certs in use. This directive will be needed if the remote server
#   presents a list of CA certificates that are not direct signers of one of the configured
#   client certificates. This referenced file is simply the concatenation of the various
#   PEM-encoded certificate files. Upon startup, each client certificate configured will be
#   examined and a chain of trust will be constructed.
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
# @param ssl_user_name
#   Sets the [SSLUserName](https://httpd.apache.org/docs/current/mod/mod_ssl.html#sslusername) directive.
#
# @param ssl_reload_on_change
#   Enable reloading of apache if the content of ssl files have changed.
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
# @param use_servername_for_filenames
#   When set to true, default log / config file names will be derived from the sanitized
#   value of the $servername parameter.
#   When set to false (default), the existing behaviour of using the $name parameter
#   will remain.
#
# @param use_port_for_filenames
#   When set to true and use_servername_for_filenames is also set to true, default log /
#   config file names will be derived from the sanitized value of both the $servername and
#   $port parameters.
#   When set to false (default), the port is not included in the file names and may lead to
#   duplicate declarations if two virtual hosts use the same domain.
#
# @param mdomain
#   All the names in the list are managed as one Managed Domain (MD). mod_md will request
#   one single certificate that is valid for all these names.
#
# @param proxy_requests
#   Whether to accept proxy requests
#
# @param userdir
#   Instances of apache::mod::userdir
#
define apache::vhost (
  Variant[Stdlib::Absolutepath, Boolean] $docroot,
  Boolean $manage_docroot                                                             = true,
  Variant[Stdlib::Absolutepath, Boolean] $virtual_docroot                             = false,
  Boolean $virtual_use_default_docroot                                                = false,
  Optional[Variant[Array[Stdlib::Port], Stdlib::Port]] $port                          = undef,
  Optional[
    Variant[
      Array[Variant[Stdlib::IP::Address, Enum['*']]],
      Variant[Stdlib::IP::Address, Enum['*']]
    ]
  ] $ip                                                                               = undef,
  Boolean $ip_based                                                                   = false,
  Boolean $add_listen                                                                 = true,
  String $docroot_owner                                                               = 'root',
  String $docroot_group                                                               = $apache::params::root_group,
  Optional[Stdlib::Filemode] $docroot_mode                                            = undef,
  Array[Enum['h2', 'h2c', 'http/1.1']] $protocols                                     = [],
  Optional[Boolean] $protocols_honor_order                                            = undef,
  Optional[String] $serveradmin                                                       = undef,
  Boolean $ssl                                                                        = false,
  Optional[Stdlib::Absolutepath] $ssl_cert                                            = $apache::default_ssl_cert,
  Optional[Stdlib::Absolutepath] $ssl_key                                             = $apache::default_ssl_key,
  Optional[Stdlib::Absolutepath] $ssl_chain                                           = $apache::default_ssl_chain,
  Optional[Stdlib::Absolutepath] $ssl_ca                                              = $apache::default_ssl_ca,
  Optional[Stdlib::Absolutepath] $ssl_crl_path                                        = $apache::default_ssl_crl_path,
  Optional[Stdlib::Absolutepath] $ssl_crl                                             = $apache::default_ssl_crl,
  Optional[String] $ssl_crl_check                                                     = $apache::default_ssl_crl_check,
  Optional[Stdlib::Absolutepath] $ssl_certs_dir                                       = $apache::params::ssl_certs_dir,
  Boolean $ssl_reload_on_change                                                       = $apache::default_ssl_reload_on_change,
  Optional[Variant[Array[String], String]] $ssl_protocol                              = undef,
  Optional[Variant[Array[String[1]], String[1], Hash[String[1], String[1]]]] $ssl_cipher = undef,
  Variant[Boolean, Apache::OnOff, Undef] $ssl_honorcipherorder                        = undef,
  Optional[Enum['none', 'optional', 'require', 'optional_no_ca']] $ssl_verify_client  = undef,
  Optional[Integer] $ssl_verify_depth                                                 = undef,
  Optional[Enum['none', 'optional', 'require', 'optional_no_ca']] $ssl_proxy_verify   = undef,
  Optional[Integer[0]] $ssl_proxy_verify_depth                                        = undef,
  Optional[Stdlib::Absolutepath] $ssl_proxy_ca_cert                                   = undef,
  Optional[Apache::OnOff] $ssl_proxy_check_peer_cn                                    = undef,
  Optional[Apache::OnOff] $ssl_proxy_check_peer_name                                  = undef,
  Optional[Apache::OnOff] $ssl_proxy_check_peer_expire                                = undef,
  Optional[Stdlib::Absolutepath] $ssl_proxy_machine_cert                              = undef,
  Optional[Stdlib::Absolutepath] $ssl_proxy_machine_cert_chain                        = undef,
  Optional[String] $ssl_proxy_cipher_suite                                            = undef,
  Optional[String] $ssl_proxy_protocol                                                = undef,
  Optional[Variant[Array[String], String]] $ssl_options                               = undef,
  Optional[String] $ssl_openssl_conf_cmd                                              = undef,
  Boolean $ssl_proxyengine                                                            = false,
  Optional[Boolean] $ssl_stapling                                                     = undef,
  Optional[Integer] $ssl_stapling_timeout                                             = undef,
  Optional[Apache::OnOff] $ssl_stapling_return_errors                                 = undef,
  Optional[String] $ssl_user_name                                                     = undef,
  Optional[Apache::Vhost::Priority] $priority                                         = undef,
  Boolean $default_vhost                                                              = false,
  Optional[String] $servername                                                        = $name,
  Variant[Array[String], String] $serveraliases                                       = [],
  Array[String] $options                                                              = ['Indexes', 'FollowSymLinks', 'MultiViews'],
  Array[String] $override                                                             = ['None'],
  Optional[String] $directoryindex                                                    = undef,
  String $vhost_name                                                                  = '*',
  Stdlib::Absolutepath $logroot                                                       = $apache::logroot,
  Enum['directory', 'absent'] $logroot_ensure                                         = 'directory',
  Optional[Stdlib::Filemode] $logroot_mode                                            = undef,
  Optional[String] $logroot_owner                                                     = undef,
  Optional[String] $logroot_group                                                     = undef,
  Optional[Apache::LogLevel] $log_level                                               = undef,
  Boolean $access_log                                                                 = true,
  Optional[String[1]] $access_log_file                                                = undef,
  Optional[String[1]] $access_log_pipe                                                = undef,
  Optional[Variant[String, Boolean]] $access_log_syslog                               = undef,
  Optional[String[1]] $access_log_format                                              = undef,
  Optional[Variant[Boolean, String]] $access_log_env_var                              = undef,
  Optional[Array[Hash]] $access_logs                                                  = undef,
  Boolean $use_servername_for_filenames                                               = false,
  Boolean $use_port_for_filenames                                                     = false,
  Array[Hash[String[1], String[1]]] $aliases                                          = [],
  Array[Hash] $directories                                                            = [],
  Boolean $error_log                                                                  = true,
  Optional[String] $error_log_file                                                    = undef,
  Optional[String] $error_log_pipe                                                    = undef,
  Optional[Variant[String, Boolean]] $error_log_syslog                                = undef,
  Optional[
    Array[
      Variant[
        String,
        Hash[String, Enum['connection', 'request']]
      ]
    ]
  ] $error_log_format                                                                 = undef,
  Optional[Pattern[/^((Strict|Unsafe)?\s*(\b(Registered|Lenient)Methods)?\s*(\b(Allow0\.9|Require1\.0))?)$/]] $http_protocol_options = undef,
  Optional[Variant[String, Boolean]] $modsec_audit_log                                = undef,
  Optional[String] $modsec_audit_log_file                                             = undef,
  Optional[String] $modsec_audit_log_pipe                                             = undef,
  Variant[Array[Hash], String] $error_documents                                       = [],
  Optional[Variant[Stdlib::Absolutepath, Enum['disabled']]] $fallbackresource         = undef,
  Optional[String] $scriptalias                                                       = undef,
  Optional[Integer] $limitreqfieldsize                                                = undef,
  Optional[Integer] $limitreqfields                                                   = undef,
  Optional[Integer] $limitreqline                                                     = undef,
  Optional[Integer] $limitreqbody                                                     = undef,
  Optional[String] $proxy_dest                                                        = undef,
  Optional[String] $proxy_dest_match                                                  = undef,
  Optional[String] $proxy_dest_reverse_match                                          = undef,
  Optional[Variant[Array[Hash], Hash]] $proxy_pass                                    = undef,
  Optional[Variant[Array[Hash], Hash]] $proxy_pass_match                              = undef,
  Boolean $proxy_requests                                                             = false,
  Hash $php_flags                                                                     = {},
  Hash $php_values                                                                    = {},
  Variant[Array[String], Hash] $php_admin_flags                                       = {},
  Variant[Array[String], Hash] $php_admin_values                                      = {},
  Variant[Array[String], String] $no_proxy_uris                                       = [],
  Variant[Array[String], String] $no_proxy_uris_match                                 = [],
  Boolean $proxy_preserve_host                                                        = false,
  Optional[Variant[String, Boolean]] $proxy_add_headers                               = undef,
  Boolean $proxy_error_override                                                       = false,
  Variant[String, Array[String]] $redirect_source                                     = '/',
  Optional[Variant[Array[String], String]] $redirect_dest                             = undef,
  Optional[Variant[Array[String], String]] $redirect_status                           = undef,
  Optional[Variant[Array[String], String]] $redirectmatch_status                      = undef,
  Optional[Variant[Array[String], String]] $redirectmatch_regexp                      = undef,
  Optional[Variant[Array[String], String]] $redirectmatch_dest                        = undef,
  Array[String[1]] $headers                                                           = [],
  Array[String[1]] $request_headers                                                   = [],
  Array[String[1]] $filters                                                           = [],
  Array[Hash] $rewrites                                                               = [],
  Optional[String[1]] $rewrite_base                                                   = undef,
  Optional[Variant[Array[String[1]], String[1]]] $rewrite_rule                        = undef,
  Array[String[1]] $rewrite_cond                                                      = [],
  Boolean $rewrite_inherit                                                            = false,
  Variant[Array[String], String] $setenv                                              = [],
  Variant[Array[String], String] $setenvif                                            = [],
  Variant[Array[String], String] $setenvifnocase                                      = [],
  Variant[Array[String], String] $block                                               = [],
  Enum['absent', 'present'] $ensure                                                   = 'present',
  Boolean $show_diff                                                                  = true,
  Optional[String] $wsgi_application_group                                            = undef,
  Optional[Variant[String, Hash]] $wsgi_daemon_process                                = undef,
  Optional[Hash] $wsgi_daemon_process_options                                         = undef,
  Optional[String] $wsgi_import_script                                                = undef,
  Optional[Hash] $wsgi_import_script_options                                          = undef,
  Optional[String] $wsgi_process_group                                                = undef,
  Optional[Hash] $wsgi_script_aliases_match                                           = undef,
  Optional[Hash] $wsgi_script_aliases                                                 = undef,
  Optional[Apache::OnOff] $wsgi_pass_authorization                                    = undef,
  Optional[Apache::OnOff] $wsgi_chunked_request                                       = undef,
  Optional[String] $custom_fragment                                                   = undef,
  Optional[Hash] $itk                                                                 = undef,
  Optional[String] $action                                                            = undef,
  Variant[Array[String], String] $additional_includes                                 = [],
  Boolean $use_optional_includes                                                      = $apache::use_optional_includes,
  Optional[Variant[Apache::OnOff, Enum['nodecode']]] $allow_encoded_slashes           = undef,
  Optional[Pattern[/^[\w-]+ [\w-]+$/]] $suexec_user_group                             = undef,

  Optional[Boolean] $h2_copy_files                                                    = undef,
  Optional[Boolean] $h2_direct                                                        = undef,
  Optional[Boolean] $h2_early_hints                                                   = undef,
  Optional[Integer] $h2_max_session_streams                                           = undef,
  Optional[Boolean] $h2_modern_tls_only                                               = undef,
  Optional[Boolean] $h2_push                                                          = undef,
  Optional[Integer] $h2_push_diary_size                                               = undef,
  Array[String]     $h2_push_priority                                                 = [],
  Array[String]     $h2_push_resource                                                 = [],
  Optional[Boolean] $h2_serialize_headers                                             = undef,
  Optional[Integer] $h2_stream_max_mem_size                                           = undef,
  Optional[Integer] $h2_tls_cool_down_secs                                            = undef,
  Optional[Integer] $h2_tls_warm_up_size                                              = undef,
  Optional[Boolean] $h2_upgrade                                                       = undef,
  Optional[Integer] $h2_window_size                                                   = undef,

  Optional[Boolean] $passenger_enabled                                                = undef,
  Optional[String] $passenger_base_uri                                                = undef,
  Optional[Stdlib::Absolutepath] $passenger_ruby                                      = undef,
  Optional[Stdlib::Absolutepath] $passenger_python                                    = undef,
  Optional[Stdlib::Absolutepath] $passenger_nodejs                                    = undef,
  Optional[String] $passenger_meteor_app_settings                                     = undef,
  Optional[String] $passenger_app_env                                                 = undef,
  Optional[Stdlib::Absolutepath] $passenger_app_root                                  = undef,
  Optional[String] $passenger_app_group_name                                          = undef,
  Optional[String] $passenger_app_start_command                                       = undef,
  Optional[Enum['meteor', 'node', 'rack', 'wsgi']] $passenger_app_type                = undef,
  Optional[String] $passenger_startup_file                                            = undef,
  Optional[String] $passenger_restart_dir                                             = undef,
  Optional[Enum['direct', 'smart']] $passenger_spawn_method                           = undef,
  Optional[Boolean] $passenger_load_shell_envvars                                     = undef,
  Optional[Boolean] $passenger_preload_bundler                                        = undef,
  Optional[Boolean] $passenger_rolling_restarts                                       = undef,
  Optional[Boolean] $passenger_resist_deployment_errors                               = undef,
  Optional[String] $passenger_user                                                    = undef,
  Optional[String] $passenger_group                                                   = undef,
  Optional[Boolean] $passenger_friendly_error_pages                                   = undef,
  Optional[Integer] $passenger_min_instances                                          = undef,
  Optional[Integer] $passenger_max_instances                                          = undef,
  Optional[Integer] $passenger_max_preloader_idle_time                                = undef,
  Optional[Integer] $passenger_force_max_concurrent_requests_per_process              = undef,
  Optional[Integer] $passenger_start_timeout                                          = undef,
  Optional[Enum['process', 'thread']] $passenger_concurrency_model                    = undef,
  Optional[Integer] $passenger_thread_count                                           = undef,
  Optional[Integer] $passenger_max_requests                                           = undef,
  Optional[Integer] $passenger_max_request_time                                       = undef,
  Optional[Integer] $passenger_memory_limit                                           = undef,
  Optional[Integer] $passenger_stat_throttle_rate                                     = undef,
  Optional[Variant[String, Array[String]]] $passenger_pre_start                       = undef,
  Optional[Boolean] $passenger_high_performance                                       = undef,
  Optional[Boolean] $passenger_buffer_upload                                          = undef,
  Optional[Boolean] $passenger_buffer_response                                        = undef,
  Optional[Boolean] $passenger_error_override                                         = undef,
  Optional[Integer] $passenger_max_request_queue_size                                 = undef,
  Optional[Integer] $passenger_max_request_queue_time                                 = undef,
  Optional[Boolean] $passenger_sticky_sessions                                        = undef,
  Optional[String] $passenger_sticky_sessions_cookie_name                             = undef,
  Optional[String] $passenger_sticky_sessions_cookie_attributes                       = undef,
  Optional[Boolean] $passenger_allow_encoded_slashes                                  = undef,
  Optional[String] $passenger_app_log_file                                            = undef,
  Optional[Boolean] $passenger_debugger                                               = undef,
  Optional[Integer] $passenger_lve_min_uid                                            = undef,
  Optional[String] $passenger_admin_panel_url                                         = undef,
  Optional[Enum['basic']] $passenger_admin_panel_auth_type                            = undef,
  Optional[String] $passenger_admin_panel_username                                    = undef,
  Optional[String] $passenger_admin_panel_password                                    = undef,
  Optional[String] $passenger_dump_config_manifest                                    = undef,
  Optional[String] $add_default_charset                                               = undef,
  Boolean $modsec_disable_vhost                                                       = false,
  Optional[Variant[Hash, Array]] $modsec_disable_ids                                  = undef,
  Array[String[1]] $modsec_disable_ips                                                = [],
  Optional[Variant[Hash, Array]] $modsec_disable_msgs                                 = undef,
  Optional[Variant[Hash, Array]] $modsec_disable_tags                                 = undef,
  Optional[String] $modsec_body_limit                                                 = undef,
  Optional[Integer[1, default]] $modsec_inbound_anomaly_threshold                     = undef,
  Optional[Integer[1, default]] $modsec_outbound_anomaly_threshold                    = undef,
  Optional[String] $modsec_allowed_methods                                            = undef,
  Array[Hash] $jk_mounts                                                              = [],
  Boolean $auth_kerb                                                                  = false,
  Apache::OnOff $krb_method_negotiate                                                 = 'on',
  Apache::OnOff $krb_method_k5passwd                                                  = 'on',
  Apache::OnOff $krb_authoritative                                                    = 'on',
  Array[String] $krb_auth_realms                                                      = [],
  Optional[String] $krb_5keytab                                                       = undef,
  Optional[Apache::OnOff] $krb_local_user_mapping                                     = undef,
  Apache::OnOff $krb_verify_kdc                                                       = 'on',
  String $krb_servicename                                                             = 'HTTP',
  Apache::OnOff $krb_save_credentials                                                 = 'off',
  Optional[Apache::OnOff] $keepalive                                                  = undef,
  Optional[Variant[Integer, String]] $keepalive_timeout                               = undef,
  Optional[Variant[Integer, String]] $max_keepalive_requests                          = undef,
  Optional[String] $cas_attribute_prefix                                              = undef,
  Optional[String] $cas_attribute_delimiter                                           = undef,
  Optional[String] $cas_root_proxied_as                                               = undef,
  Boolean $cas_scrub_request_headers                                                  = false,
  Boolean $cas_sso_enabled                                                            = false,
  Optional[String] $cas_login_url                                                     = undef,
  Optional[String] $cas_validate_url                                                  = undef,
  Boolean $cas_validate_saml                                                          = false,
  Optional[String] $cas_cookie_path                                                   = undef,
  Optional[String] $shib_compat_valid_user                                            = undef,
  Optional[Variant[Apache::OnOff, Enum['DNS', 'dns']]] $use_canonical_name            = undef,
  Optional[Variant[String, Array[String]]] $comment                                   = undef,
  Hash $define                                                                        = {},
  Boolean $auth_oidc                                                                  = false,
  Apache::OIDCSettings $oidc_settings                                                 = {},
  Optional[Variant[Boolean, String]] $mdomain                                         = undef,
  Optional[Variant[String[1], Array[String[1]]]] $userdir                             = undef,
) {
  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['apache']) {
    fail('You must include the apache base class before using any apache defined resources')
  }

  $apache_name = $apache::apache_name

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

  if $ssl_honorcipherorder =~ Boolean or $ssl_honorcipherorder == undef {
    $_ssl_honorcipherorder = $ssl_honorcipherorder
  } else {
    $_ssl_honorcipherorder = $ssl_honorcipherorder ? {
      'on'    => true,
      'On'    => true,
      'off'   => false,
      'Off'   => false,
      default => true,
    }
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

  # https://httpd.apache.org/docs/2.4/fr/mod/core.html#servername
  # Syntax:	ServerName [scheme://]domain-name|ip-address[:port]
  # Sometimes, the server runs behind a device that processes SSL, such as a reverse proxy, load balancer or SSL offload
  # appliance.
  # When this is the case, specify the https:// scheme and the port number to which the clients connect in the ServerName
  # directive to make sure that the server generates the correct self-referential URLs.
  $normalized_servername = regsubst($servername, '(https?:\/\/)?([a-z0-9\/%_+.,#?!@&=-]+)(:?\d+)?', '\2', 'G')

  # IAC-1186: A number of configuration and log file names are generated using the $name parameter. It is possible for
  # the $name parameter to contain spaces, which could then be transferred to the log / config filenames. Although
  # POSIX compliant, this can be cumbersome.
  #
  # It seems more appropriate to use the $servername parameter to derive default log / config filenames from. We should
  # also perform some sanitiation on the $servername parameter to strip spaces from it, as it defaults to the value of
  # $name, should $servername NOT be defined.
  #
  # Because a single hostname may be use by multiple virtual hosts listening on different ports, the $port paramter can
  # optionaly be used to avoid duplicate resources.
  $filename = $use_servername_for_filenames ? {
    true => $use_port_for_filenames ? {
      true  => regsubst("${normalized_servername}-${port}", ' ', '_', 'G'),
      false => regsubst($normalized_servername, ' ', '_', 'G'),
    },
    false => $name,
  }

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
  } else {
    $_access_logs = []
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
      $error_log_destination = "${logroot}/${filename}_error_ssl.log"
    } else {
      $error_log_destination = "${logroot}/${filename}_error.log"
    }
  }

  if $modsec_audit_log == false {
    $modsec_audit_log_destination = undef
  } elsif $modsec_audit_log_file {
    $modsec_audit_log_destination = "${logroot}/${modsec_audit_log_file}"
  } elsif $modsec_audit_log_pipe {
    $modsec_audit_log_destination = $modsec_audit_log_pipe
  } elsif $modsec_audit_log {
    if $ssl {
      $modsec_audit_log_destination = "${logroot}/${filename}_security_ssl.log"
    } else {
      $modsec_audit_log_destination = "${logroot}/${filename}_security.log"
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
      $nvh_addr_port = prefix(any2array($port), "${vhost_name}:")
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

  ## Create a default directory list if none defined
  if !empty($directories) {
    $_directories = $directories
  } elsif $docroot {
    $_directories = [
      {
        provider       => 'directory',
        path           => $docroot,
        options        => $options,
        allow_override => $override,
        directoryindex => $directoryindex,
        require        => 'all granted',
      },
    ]
  } else {
    $_directories = []
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
    ensure    => $ensure,
    path      => "${apache::vhost_dir}/${priority_real}${filename}.conf",
    owner     => 'root',
    group     => $apache::params::root_group,
    mode      => $apache::file_mode,
    show_diff => $show_diff,
    order     => 'numeric',
    require   => Package['httpd'],
    notify    => Class['apache::service'],
  }
  # NOTE(pabelanger): This code is duplicated in ::apache::vhost::custom and
  # needs to be converted into something generic.
  if $apache::vhost_enable_dir {
    $vhost_enable_dir = $apache::vhost_enable_dir
    $vhost_symlink_ensure = $ensure ? {
      'present' => link,
      default => $ensure,
    }
    file { "${priority_real}${filename}.conf symlink":
      ensure  => $vhost_symlink_ensure,
      path    => "${vhost_enable_dir}/${priority_real}${filename}.conf",
      target  => "${apache::vhost_dir}/${priority_real}${filename}.conf",
      owner   => 'root',
      group   => $apache::params::root_group,
      mode    => $apache::file_mode,
      require => Concat["${priority_real}${filename}.conf"],
      notify  => Class['apache::service'],
    }
  }

  $file_header_params = {
    'comment'               => $comment,
    'nvh_addr_port'         => $nvh_addr_port,
    'mdomain'               => $mdomain,
    'servername'            => $servername,
    'define'                => $define,
    'protocols'             => $protocols,
    'protocols_honor_order' => $protocols_honor_order,
    'limitreqfieldsize'     => $limitreqfieldsize,
    'limitreqfields'        => $limitreqfields,
    'limitreqline'          => $limitreqline,
    'limitreqbody'          => $limitreqbody,
    'serveradmin'           => $serveradmin,
  }

  concat::fragment { "${name}-apache-header":
    target  => "${priority_real}${filename}.conf",
    order   => 0,
    content => epp('apache/vhost/_file_header.epp', $file_header_params),
  }

  if $docroot and $ensure == 'present' {
    if $virtual_docroot {
      include apache::mod::vhost_alias
    }

    $docroot_params = {
      'virtual_docroot'             => $virtual_docroot,
      'docroot'                     => $docroot,
      'virtual_use_default_docroot' => $virtual_use_default_docroot,
    }

    concat::fragment { "${name}-docroot":
      target  => "${priority_real}${filename}.conf",
      order   => 10,
      content => epp('apache/vhost/_docroot.epp', $docroot_params),
    }
  }

  if ! empty($aliases) and $ensure == 'present' {
    include apache::mod::alias
    $aliases_params = {
      'aliases' => $aliases,
    }
    concat::fragment { "${name}-aliases":
      target  => "${priority_real}${filename}.conf",
      order   => 20,
      content => epp('apache/vhost/_aliases.epp', $aliases_params),
    }
  }

  if $itk and ! empty($itk) {
    $itk_params = {
      'itk'           => $itk,
      'kernelversion' => $facts['kernelversion'],
    }
    concat::fragment { "${name}-itk":
      target  => "${priority_real}${filename}.conf",
      order   => 30,
      content => epp('apache/vhost/_itk.epp', $itk_params),
    }
  }

  if $fallbackresource {
    $fall_back_res_params = {
      'fallbackresource' => $fallbackresource,
    }
    concat::fragment { "${name}-fallbackresource":
      target  => "${priority_real}${filename}.conf",
      order   => 40,
      content => epp('apache/vhost/_fallbackresource.epp', $fall_back_res_params),
    }
  }

  if $allow_encoded_slashes {
    $allow_encoded_slashes_params = {
      'allow_encoded_slashes' => $allow_encoded_slashes,
    }
    concat::fragment { "${name}-allow_encoded_slashes":
      target  => "${priority_real}${filename}.conf",
      order   => 50,
      content => epp('apache/vhost/_allow_encoded_slashes.epp', $allow_encoded_slashes_params),
    }
  }

  if $ensure == 'present' {
    $_directories.each |Hash $directory| {
      if 'auth_basic_authoritative' in $directory or 'auth_basic_fake' in $directory or 'auth_basic_provider' in $directory {
        include apache::mod::auth_basic
      }

      if 'auth_user_file' in $directory {
        include apache::mod::authn_file
      }

      if 'auth_group_file' in $directory {
        include apache::mod::authz_groupfile
      }

      if 'gssapi' in $directory {
        include apache::mod::auth_gssapi
      }

      if $directory['provider'] and $directory['provider'] =~ 'location' and ('proxy_pass' in $directory or 'proxy_pass_match' in $directory) {
        include apache::mod::proxy_http

        # To match processing in templates/vhost/_directories.erb
        if $directory['proxy_pass_match'] {
          Array($directory['proxy_pass_match']).each |$proxy| {
            if $proxy['url'] =~ /"h2c?:\/\// {
              include apache::mod::proxy_http2
            }
          }
        } elsif $directory['proxy_pass'] {
          Array($directory['proxy_pass']).each |$proxy| {
            if $proxy['url'] =~ /"h2c?:\/\// {
              include apache::mod::proxy_http2
            }
          }
        }
      }

      if 'request_headers' in $directory {
        include apache::mod::headers
      }

      if 'rewrites' in $directory {
        include apache::mod::rewrite
      }

      if 'setenv' in $directory {
        include apache::mod::env
      }
    }

    # Template uses:
    # - $_directories
    # - $docroot
    # - $shibboleth_enabled
    # - $cas_enabled
    unless empty($_directories) {
      concat::fragment { "${name}-directories":
        target  => "${priority_real}${filename}.conf",
        order   => 60,
        content => template('apache/vhost/_directories.erb'),
      }
    }
  }

  # Template uses:
  # - $additional_includes
  # - $use_optional_includes
  if $additional_includes and ! empty($additional_includes) {
    concat::fragment { "${name}-additional_includes":
      target  => "${priority_real}${filename}.conf",
      order   => 70,
      content => template('apache/vhost/_additional_includes.erb'),
    }
  }

  if $error_log or $log_level {
    $logging_params = {
      'error_log'             => $error_log,
      'log_level'             => $log_level,
      'error_log_destination' => $error_log_destination,
      'error_log_format'      => $error_log_format,
    }
    concat::fragment { "${name}-logging":
      target  => "${priority_real}${filename}.conf",
      order   => 80,
      content => epp('apache/vhost/_logging.epp', $logging_params),
    }
  }

  # Template uses no variables
  concat::fragment { "${name}-serversignature":
    target  => "${priority_real}${filename}.conf",
    order   => 90,
    content => "  ServerSignature Off\n",
  }

  # Template uses:
  # - $_access_logs
  # - $_access_log_env_var
  # - $access_log_destination
  # - $_access_log_format
  # - $_access_log_env_var
  if !empty($_access_logs) {
    concat::fragment { "${name}-access_log":
      target  => "${priority_real}${filename}.conf",
      order   => 100,
      content => template('apache/vhost/_access_log.erb'),
    }
  }

  if $action {
    concat::fragment { "${name}-action":
      target  => "${priority_real}${filename}.conf",
      order   => 110,
      content => epp('apache/vhost/_action.epp', { 'action' => $action }),
    }
  }

  # Template uses:
  # - $block
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

  if ! empty($headers) and $ensure == 'present' {
    include apache::mod::headers

    concat::fragment { "${name}-header":
      target  => "${priority_real}${filename}.conf",
      order   => 140,
      content => epp('apache/vhost/_header.epp', { 'headers' => $headers }),
    }
  }

  if ! empty($request_headers) and $ensure == 'present' {
    include apache::mod::headers

    concat::fragment { "${name}-requestheader":
      target  => "${priority_real}${filename}.conf",
      order   => 150,
      content => epp('apache/vhost/_requestheader.epp', { 'request_headers' => $request_headers }),
    }
  }

  if $ssl_proxyengine {
    $ssl_proxy_params = {
      'ssl_proxyengine'              => $ssl_proxyengine,
      'ssl_proxy_verify'             => $ssl_proxy_verify,
      'ssl_proxy_verify_depth'       => $ssl_proxy_verify_depth,
      'ssl_proxy_ca_cert'            => $ssl_proxy_ca_cert,
      'ssl_proxy_check_peer_cn'      => $ssl_proxy_check_peer_cn,
      'ssl_proxy_check_peer_name'    => $ssl_proxy_check_peer_name,
      'ssl_proxy_check_peer_expire'  => $ssl_proxy_check_peer_expire,
      'ssl_proxy_machine_cert'       => $ssl_proxy_machine_cert,
      'ssl_proxy_machine_cert_chain' => $ssl_proxy_machine_cert_chain,
      'ssl_proxy_cipher_suite'       => $ssl_proxy_cipher_suite,
      'ssl_proxy_protocol'           => $ssl_proxy_protocol,
    }
    concat::fragment { "${name}-sslproxy":
      target  => "${priority_real}${filename}.conf",
      order   => 160,
      content => epp('apache/vhost/_sslproxy.epp', $ssl_proxy_params),
    }
  }

  if ($proxy_dest or $proxy_pass or $proxy_pass_match or $proxy_dest_match or $proxy_preserve_host or ($proxy_add_headers =~ NotUndef)) and $ensure == 'present' {
    include apache::mod::proxy_http

    # To match processing in templates/vhost/_proxy.erb
    if $proxy_dest =~ Pattern[/^h2c?:\/\//] or $proxy_dest_match =~ Pattern[/^h2c?:\/\//] {
      include apache::mod::proxy_http2
    }
    [$proxy_pass, $proxy_pass_match].flatten.each |$proxy| {
      if $proxy and $proxy['url'] =~ Pattern[/^h2c?:\/\//] {
        include apache::mod::proxy_http2
      }
    }
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
  if (($redirect_source and $redirect_dest) or ($redirectmatch_regexp and $redirectmatch_dest)) and $ensure == 'present' {
    include apache::mod::alias

    concat::fragment { "${name}-redirect":
      target  => "${priority_real}${filename}.conf",
      order   => 180,
      content => template('apache/vhost/_redirect.erb'),
    }
  }

  # Template uses:
  # - $rewrites
  # - $rewrite_inherit
  # - $rewrite_base
  # - $rewrite_rule
  # - $rewrite_cond
  # - $rewrite_map
  if (! empty($rewrites) or $rewrite_rule or $rewrite_inherit) and $ensure == 'present' {
    include apache::mod::rewrite
    concat::fragment { "${name}-rewrite":
      target  => "${priority_real}${filename}.conf",
      order   => 190,
      content => template('apache/vhost/_rewrite.erb'),
    }
  }

  if $scriptalias and $ensure == 'present' {
    include apache::mod::alias
    concat::fragment { "${name}-scriptalias":
      target  => "${priority_real}${filename}.conf",
      order   => 200,
      content => epp('apache/vhost/_scriptalias.epp', { 'scriptalias' => $scriptalias }),
    }
  }

  if ! empty($serveraliases) and $ensure == 'present' {
    concat::fragment { "${name}-serveralias":
      target  => "${priority_real}${filename}.conf",
      order   => 210,
      content => epp('apache/vhost/_serveralias.epp', { 'serveraliases' => [$serveraliases].flatten }),
    }
  }

  # Template uses:
  # - $setenv
  # - $setenvif
  # - $setenvifnocase
  $use_env_mod = !empty($setenv)
  $use_setenvif_mod = !empty($setenvif) or !empty($setenvifnocase)
  if ($use_env_mod or $use_setenvif_mod) and $ensure == 'present' {
    if $use_env_mod {
      include apache::mod::env
    }
    if $use_setenvif_mod {
      include apache::mod::setenvif
    }

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
  # - $_ssl_honorcipherorder
  # - $ssl_verify_client
  # - $ssl_verify_depth
  # - $ssl_options
  # - $ssl_openssl_conf_cmd
  # - $ssl_stapling
  # - $mdomain
  if $ssl and $ensure == 'present' {
    include apache::mod::ssl
    concat::fragment { "${name}-ssl":
      target  => "${priority_real}${filename}.conf",
      order   => 230,
      content => template('apache/vhost/_ssl.erb'),
    }

    if $ssl_reload_on_change {
      [$ssl_cert, $ssl_key, $ssl_ca, $ssl_chain, $ssl_crl].each |$ssl_file| {
        if $ssl_file {
          include apache::mod::ssl::reload
          $_ssl_file_copy = regsubst($ssl_file, '/', '_', 'G')
          file { "${filename}${_ssl_file_copy}":
            path    => "${apache::params::puppet_ssl_dir}/${filename}${_ssl_file_copy}",
            source  => "file://${ssl_file}",
            owner   => 'root',
            group   => $apache::params::root_group,
            mode    => '0640',
            seltype => 'cert_t',
            notify  => Class['apache::service'],
          }
        }
      }
    }
  }

  if $auth_kerb and $ensure == 'present' {
    include apache::mod::auth_kerb

    concat::fragment { "${name}-auth_kerb":
      target  => "${priority_real}${filename}.conf",
      order   => 230,
      content => stdlib::deferrable_epp('apache/vhost/_auth_kerb.epp', {
          'auth_kerb'              => $auth_kerb,
          'krb_method_negotiate'   => $krb_method_negotiate,
          'krb_method_k5passwd'    => Deferred('sprintf', [$krb_method_k5passwd]),
          'krb_authoritative'      => $krb_authoritative,
          'krb_auth_realms'        => $krb_auth_realms,
          'krb_5keytab'            => $krb_5keytab,
          'krb_local_user_mapping' => $krb_local_user_mapping,
          'krb_verify_kdc'         => $krb_verify_kdc,
          'krb_servicename'        => $krb_servicename,
          'krb_save_credentials'   => $krb_save_credentials,
      }),
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

  if $wsgi_daemon_process_options {
    deprecation('apache::vhost::wsgi_daemon_process_options', 'This parameter is deprecated. Please add values inside Hash `wsgi_daemon_process`.')
  }
  if ($wsgi_application_group or $wsgi_daemon_process or ($wsgi_import_script and $wsgi_import_script_options) or $wsgi_process_group or ($wsgi_script_aliases and ! empty($wsgi_script_aliases)) or $wsgi_pass_authorization) and $ensure == 'present' {
    include apache::mod::wsgi
    $wsgi_params = {
      'wsgi_application_group' => $wsgi_application_group,
      'wsgi_daemon_process' => $wsgi_daemon_process,
      'wsgi_import_script' => $wsgi_import_script,
      'wsgi_process_group' => $wsgi_process_group,
      'wsgi_daemon_process_options'=> $wsgi_daemon_process_options,
      'wsgi_import_script_options' => $wsgi_import_script_options,
      'wsgi_script_aliases' => $wsgi_script_aliases,
      'wsgi_pass_authorization' => $wsgi_pass_authorization,
      'wsgi_chunked_request' => $wsgi_chunked_request,
      'wsgi_script_aliases_match' => $wsgi_script_aliases_match,
    }

    concat::fragment { "${name}-wsgi":
      target  => "${priority_real}${filename}.conf",
      order   => 260,
      content => epp('apache/vhost/_wsgi.epp', $wsgi_params),
    }
  }

  if $custom_fragment {
    $custom_fragment_params = {
      'custom_fragment' => $custom_fragment,
    }
    concat::fragment { "${name}-custom_fragment":
      target  => "${priority_real}${filename}.conf",
      order   => 270,
      content => epp('apache/vhost/_custom_fragment.epp', $custom_fragment_params),
    }
  }

  if $suexec_user_group and $ensure == 'present' {
    include apache::mod::suexec

    concat::fragment { "${name}-suexec":
      target  => "${priority_real}${filename}.conf",
      order   => 290,
      content => "  SuexecUserGroup ${suexec_user_group}\n",
    }
  }

  if ('h2' in $protocols or 'h2c' in $protocols or $h2_copy_files != undef or $h2_direct != undef or $h2_early_hints != undef or $h2_max_session_streams != undef or $h2_modern_tls_only != undef or $h2_push != undef or $h2_push_diary_size != undef or $h2_push_priority != [] or $h2_push_resource != [] or $h2_serialize_headers != undef or $h2_stream_max_mem_size != undef or $h2_tls_cool_down_secs != undef or $h2_tls_warm_up_size != undef or $h2_upgrade != undef or $h2_window_size != undef) and $ensure == 'present' {
    include apache::mod::http2
    $http2_params = {
      'h2_copy_files'          => $h2_copy_files,
      'h2_direct'              => $h2_direct,
      'h2_early_hints'         => $h2_early_hints,
      'h2_max_session_streams' => $h2_max_session_streams,
      'h2_modern_tls_only'     => $h2_modern_tls_only,
      'h2_push'                => $h2_push,
      'h2_push_diary_size'     => $h2_push_diary_size,
      'h2_push_priority'       => $h2_push_priority,
      'h2_push_resource'       => $h2_push_resource,
      'h2_serialize_headers'   => $h2_serialize_headers,
      'h2_stream_max_mem_size' => $h2_stream_max_mem_size,
      'h2_tls_cool_down_secs'  => $h2_tls_cool_down_secs,
      'h2_tls_warm_up_size'    => $h2_tls_warm_up_size,
      'h2_upgrade'             => $h2_upgrade,
      'h2_window_size'         => $h2_window_size,
    }

    concat::fragment { "${name}-http2":
      target  => "${priority_real}${filename}.conf",
      order   => 300,
      content => epp('apache/vhost/_http2.epp', $http2_params),
    }
  }

  if $mdomain and $ensure == 'present' {
    include apache::mod::md
  }

  if $userdir and $ensure == 'present' {
    include apache::mod::userdir

    concat::fragment { "${name}-userdir":
      target  => "${priority_real}${filename}.conf",
      order   => 300,
      content => epp('apache/vhost/_userdir.epp', { 'userdir' => $userdir }),
    }
  }

  if ($passenger_enabled != undef or $passenger_start_timeout != undef or $passenger_ruby != undef or $passenger_python != undef or $passenger_nodejs != undef or $passenger_meteor_app_settings != undef or $passenger_app_env != undef or $passenger_app_root != undef or $passenger_app_group_name != undef or $passenger_app_start_command != undef or $passenger_app_type != undef or$passenger_startup_file != undef or $passenger_restart_dir != undef or $passenger_spawn_method != undef or $passenger_load_shell_envvars != undef or $passenger_preload_bundler != undef or $passenger_rolling_restarts != undef or $passenger_resist_deployment_errors != undef or $passenger_min_instances != undef or $passenger_max_instances != undef or $passenger_max_preloader_idle_time != undef or $passenger_force_max_concurrent_requests_per_process != undef or $passenger_concurrency_model != undef or $passenger_thread_count != undef or $passenger_high_performance != undef or $passenger_max_request_queue_size != undef or $passenger_max_request_queue_time != undef or $passenger_user != undef or $passenger_group != undef or $passenger_friendly_error_pages != undef or $passenger_buffer_upload != undef or $passenger_buffer_response != undef or $passenger_allow_encoded_slashes != undef or $passenger_lve_min_uid != undef or $passenger_base_uri != undef or $passenger_error_override != undef or $passenger_sticky_sessions != undef or $passenger_sticky_sessions_cookie_name != undef or $passenger_sticky_sessions_cookie_attributes != undef or $passenger_app_log_file != undef or $passenger_debugger != undef or $passenger_max_requests != undef or $passenger_max_request_time != undef or $passenger_memory_limit != undef or $passenger_dump_config_manifest != undef) and $ensure == 'present' {
    include apache::mod::passenger
    $passenger_params = {
      'passenger_enabled'                                   => $passenger_enabled,
      'passenger_base_uri'                                  => $passenger_base_uri,
      'passenger_ruby'                                      => $passenger_ruby,
      'passenger_python'                                    => $passenger_python,
      'passenger_nodejs'                                    => $passenger_nodejs,
      'passenger_meteor_app_settings'                       => $passenger_meteor_app_settings,
      'passenger_app_env'                                   => $passenger_app_env,
      'passenger_app_root'                                  => $passenger_app_root,
      'passenger_app_group_name'                            => $passenger_app_group_name,
      'passenger_app_start_command'                         => $passenger_app_start_command,
      'passenger_app_type'                                  => $passenger_app_type,
      'passenger_startup_file'                              => $passenger_startup_file,
      'passenger_restart_dir'                               => $passenger_restart_dir,
      'passenger_spawn_method'                              => $passenger_spawn_method,
      'passenger_load_shell_envvars'                        => $passenger_load_shell_envvars,
      'passenger_preload_bundler'                           => $passenger_preload_bundler,
      'passenger_rolling_restarts'                          => $passenger_rolling_restarts,
      'passenger_resist_deployment_errors'                  => $passenger_resist_deployment_errors,
      'passenger_user'                                      => $passenger_user,
      'passenger_group'                                     => $passenger_group,
      'passenger_friendly_error_pages'                      => $passenger_friendly_error_pages,
      'passenger_min_instances'                             => $passenger_min_instances,
      'passenger_max_instances'                             => $passenger_max_instances,
      'passenger_max_preloader_idle_time'                   => $passenger_max_preloader_idle_time,
      'passenger_force_max_concurrent_requests_per_process' => $passenger_force_max_concurrent_requests_per_process,
      'passenger_start_timeout'                             => $passenger_start_timeout,
      'passenger_concurrency_model'                         => $passenger_concurrency_model,
      'passenger_thread_count'                              => $passenger_thread_count,
      'passenger_max_requests'                              => $passenger_max_requests,
      'passenger_max_request_time'                          => $passenger_max_request_time,
      'passenger_memory_limit'                              => $passenger_memory_limit,
      'passenger_stat_throttle_rate'                        => $passenger_stat_throttle_rate,
      'passenger_high_performance'                          => $passenger_high_performance,
      'passenger_buffer_upload'                             => $passenger_buffer_upload,
      'passenger_buffer_response'                           => $passenger_buffer_response,
      'passenger_error_override'                            => $passenger_error_override,
      'passenger_max_request_queue_size'                    => $passenger_max_request_queue_size,
      'passenger_max_request_queue_time'                    => $passenger_max_request_queue_time,
      'passenger_sticky_sessions'                           => $passenger_sticky_sessions,
      'passenger_sticky_sessions_cookie_name'               => $passenger_sticky_sessions_cookie_name,
      'passenger_sticky_sessions_cookie_attributes'         => $passenger_sticky_sessions_cookie_attributes,
      'passenger_allow_encoded_slashes'                     => $passenger_allow_encoded_slashes,
      'passenger_app_log_file'                              => $passenger_app_log_file,
      'passenger_debugger'                                  => $passenger_debugger,
      'passenger_lve_min_uid'                               => $passenger_lve_min_uid,
    }

    concat::fragment { "${name}-passenger":
      target  => "${priority_real}${filename}.conf",
      order   => 300,
      content => epp('apache/vhost/_passenger.epp', $passenger_params),
    }
  }

  if $add_default_charset {
    $charsets_params = {
      'add_default_charset' => $add_default_charset,
    }
    concat::fragment { "${name}-charsets":
      target  => "${priority_real}${filename}.conf",
      order   => 310,
      content => epp('apache/vhost/_charsets.epp', $charsets_params),
    }
  }

  if $modsec_disable_vhost or $modsec_disable_ids or !empty($modsec_disable_ips) or $modsec_disable_msgs or $modsec_disable_tags or $modsec_audit_log_destination or ($modsec_inbound_anomaly_threshold and $modsec_outbound_anomaly_threshold) or $modsec_allowed_methods {
    $security_params = {
      'modsec_disable_vhost'              => $modsec_disable_vhost,
      'modsec_audit_log_destination'      => $modsec_audit_log_destination,
      '_modsec_disable_ids'               => $modsec_disable_ids,
      'modsec_disable_ips'                => $modsec_disable_ips,
      '_modsec_disable_msgs'              => $modsec_disable_msgs,
      '_modsec_disable_tags'              => $modsec_disable_tags,
      'modsec_body_limit'                 => $modsec_body_limit,
      'modsec_inbound_anomaly_threshold'  => $modsec_inbound_anomaly_threshold,
      'modsec_outbound_anomaly_threshold' => $modsec_outbound_anomaly_threshold,
      'modsec_allowed_methods'            => $modsec_allowed_methods,
    }
    concat::fragment { "${name}-security":
      target  => "${priority_real}${filename}.conf",
      order   => 320,
      content => epp('apache/vhost/_security.epp', $security_params),
    }
  }

  if ! empty($filters) and $ensure == 'present' {
    include apache::mod::filter

    concat::fragment { "${name}-filters":
      target  => "${priority_real}${filename}.conf",
      order   => 330,
      content => epp('apache/vhost/_filters.epp', { 'filters' => $filters }),
    }
  }

  if !empty($jk_mounts) and $ensure == 'present' {
    include apache::mod::jk

    concat::fragment { "${name}-jk_mounts":
      target  => "${priority_real}${filename}.conf",
      order   => 340,
      content => epp('apache/vhost/_jk_mounts.epp', { 'jk_mounts' => $jk_mounts }),
    }
  }

  if $keepalive or $keepalive_timeout or $max_keepalive_requests {
    $keep_alive_params = {
      'keepalive' => $keepalive,
      'keepalive_timeout' => $keepalive_timeout,
      'max_keepalive_requests' => $max_keepalive_requests,
    }
    concat::fragment { "${name}-keepalive_options":
      target  => "${priority_real}${filename}.conf",
      order   => 350,
      content => epp('apache/vhost/_keepalive_options.epp', $keep_alive_params),
    }
  }

  if $cas_enabled {
    $auth_cas_params = {
      'cas_enabled'               => $cas_enabled,
      'cas_cookie_path'           => $cas_cookie_path,
      'cas_login_url'             => $cas_login_url,
      'cas_validate_url'          => $cas_validate_url,
      'cas_version'               => $apache::mod::auth_cas::cas_version,
      'cas_debug'                 => $apache::mod::auth_cas::cas_debug,
      'cas_certificate_path'      => $apache::mod::auth_cas::cas_certificate_path,
      'cas_proxy_validate_url'    => $apache::mod::auth_cas::cas_proxy_validate_url,
      'cas_validate_depth'        => $apache::mod::auth_cas::cas_validate_depth,
      'cas_root_proxied_as'       => $cas_root_proxied_as,
      'cas_cookie_entropy'        => $apache::mod::auth_cas::cas_cookie_entropy,
      'cas_timeout'               => $apache::mod::auth_cas::cas_timeout,
      'cas_idle_timeout'          => $apache::mod::auth_cas::cas_idle_timeout,
      'cas_cache_clean_interval'  => $apache::mod::auth_cas::cas_cache_clean_interval,
      'cas_cookie_domain'         => $apache::mod::auth_cas::cas_cookie_domain,
      'cas_cookie_http_only'      => $apache::mod::auth_cas::cas_cookie_http_only,
      'cas_authoritative'         => $apache::mod::auth_cas::cas_authoritative,
      'cas_sso_enabled'           => $cas_sso_enabled,
      'cas_validate_saml'         => $cas_validate_saml,
      'cas_attribute_prefix'      => $cas_attribute_prefix,
      'cas_attribute_delimiter'   => $cas_attribute_delimiter,
      'cas_scrub_request_headers' => $cas_scrub_request_headers,
    }
    concat::fragment { "${name}-auth_cas":
      target  => "${priority_real}${filename}.conf",
      order   => 350,
      content => epp('apache/vhost/_auth_cas.epp', $auth_cas_params),
    }
  }

  if $http_protocol_options {
    concat::fragment { "${name}-http_protocol_options":
      target  => "${priority_real}${filename}.conf",
      order   => 350,
      content => epp('apache/vhost/_http_protocol_options.epp', { 'http_protocol_options' => $http_protocol_options }),
    }
  }

  if $auth_oidc and $ensure == 'present' {
    include apache::mod::auth_openidc

    concat::fragment { "${name}-auth_oidc":
      target  => "${priority_real}${filename}.conf",
      order   => 360,
      content => stdlib::deferrable_epp('apache/vhost/_auth_oidc.epp', {
          'auth_oidc'     => $auth_oidc,
          'oidc_settings' => $oidc_settings,
      }),
    }
  }

  if $shibboleth_enabled {
    concat::fragment { "${name}-shibboleth":
      target  => "${priority_real}${filename}.conf",
      order   => 370,
      content => epp('apache/vhost/_shib.epp', { 'shib_compat_valid_user' => $shib_compat_valid_user }),
    }
  }

  if $use_canonical_name {
    concat::fragment { "${name}-use_canonical_name":
      target  => "${priority_real}${filename}.conf",
      order   => 360,
      content => "  UseCanonicalName ${use_canonical_name}\n",
    }
  }

  $file_footer_params = {
    'define'              => $define,
    'passenger_pre_start' => $passenger_pre_start,
  }
  concat::fragment { "${name}-file_footer":
    target  => "${priority_real}${filename}.conf",
    order   => 999,
    content => epp('apache/vhost/_file_footer.epp', $file_footer_params),
  }
}
