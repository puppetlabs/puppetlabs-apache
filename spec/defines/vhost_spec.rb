# frozen_string_literal: true

require 'spec_helper'

describe 'apache::vhost', type: :define do
  describe 'os-independent items' do
    on_supported_os.each do |os, os_facts|
      let(:apache_name) { (facts[:os]['family'] == 'RedHat') ? 'httpd' : 'apache2' }

      let :pre_condition do
        "class {'apache': default_vhost => false, default_mods => false, vhost_enable_dir => '/etc/#{apache_name}/sites-enabled'}"
      end

      let :title do
        'rspec.example.com'
      end

      let :default_params do
        {
          docroot: '/rspec/docroot',
          port: 84
        }
      end

      context "on #{os}" do
        let :facts do
          os_facts
        end

        describe 'basic assumptions' do
          let(:params) { default_params }

          it { is_expected.to contain_class('apache') }
          it { is_expected.to contain_class('apache::params') }
          it { is_expected.to contain_apache__listen(params[:port]) }
        end

        context 'set everything!' do
          let :params do
            {
              'docroot' => '/var/www/foo',
              'manage_docroot' => false,
              'virtual_docroot' => true,
              'virtual_use_default_docroot' => false,
              'port' => 8080,
              'ip' => '127.0.0.1',
              'ip_based' => true,
              'add_listen' => false,
              'docroot_owner' => 'user',
              'docroot_group' => 'wheel',
              'docroot_mode' => '0664',
              'serveradmin' => 'foo@localhost',
              'ssl' => true,
              'ssl_cert' => '/ssl/cert',
              'ssl_key' => '/ssl/key',
              'ssl_chain' => '/ssl/chain',
              'ssl_crl_path' => '/ssl/crl',
              'ssl_crl' => '/ssl/foo.crl',
              'ssl_certs_dir' => '/ssl/certs',
              'ssl_protocol' => 'SSLv2',
              'ssl_cipher' => 'HIGH',
              'ssl_honorcipherorder' => 'Off',
              'ssl_verify_client' => 'optional',
              'ssl_verify_depth' => 3,
              'ssl_options' => '+ExportCertData',
              'ssl_openssl_conf_cmd' => 'DHParameters "foo.pem"',
              'ssl_proxy_verify' => 'require',
              'ssl_proxy_check_peer_cn' => 'on',
              'ssl_proxy_check_peer_name' => 'on',
              'ssl_proxy_check_peer_expire' => 'on',
              'ssl_proxyengine' => true,
              'ssl_proxy_cipher_suite' => 'HIGH',
              'ssl_proxy_protocol' => 'TLSv1.2',
              'ssl_user_name' => 'SSL_CLIENT_S_DN_CN',
              'ssl_reload_on_change' => true,
              'priority' => 30,
              'default_vhost' => true,
              'servername' => 'example.com',
              'serveraliases' => ['test-example.com'],
              'options' => ['MultiView'],
              'override' => ['All'],
              'directoryindex' => 'index.html',
              'vhost_name' => 'test',
              'logroot' => '/var/www/logs',
              'logroot_ensure' => 'directory',
              'logroot_mode' => '0600',
              'logroot_owner' => 'root',
              'logroot_group' => 'root',
              'log_level' => 'crit',
              'aliases' => [
                {
                  'alias' => '/image',
                  'path' => '/rspec/image'
                },
              ],
              'access_log' => false,
              'access_log_file' => 'httpd_access_log',
              'access_log_syslog' => true,
              'access_log_format' => '%h %l %u %t \"%r\" %>s %b',
              'access_log_env_var' => '',
              'directories' => [
                {
                  'path' => '/var/www/files',
                  'provider' => 'files',
                  'require' => ['valid-user', 'all denied']
                },
                {
                  'path' => '/var/www/files',
                  'provider' => 'files',
                  'additional_includes' => ['/custom/path/includes', '/custom/path/another_includes']
                },
                {
                  'path' => '/var/www/files',
                  'provider' => 'files',
                  'require' => 'all granted'
                },
                {
                  'path' => '/var/www/files',
                  'provider' => 'files',
                  'require' =>
                  {
                    'enforce' => 'all',
                    'requires' => ['all-valid1', 'all-valid2']
                  }
                },
                {
                  'path' => '/var/www/files',
                  'provider' => 'files',
                  'require' =>
                  {
                    'enforce' => 'none',
                    'requires' => ['none-valid1', 'none-valid2']
                  }
                },
                {
                  'path' => '/var/www/files',
                  'provider' => 'files',
                  'require' =>
                  {
                    'enforce' => 'any',
                    'requires' => ['any-valid1', 'any-valid2']
                  }
                },
                {
                  'path' => '*',
                  'provider' => 'proxy'
                },
                { 'path' => '/var/www/files/indexed_directory',
                  'directoryindex' => 'disabled',
                  'options' => ['Indexes', 'FollowSymLinks', 'MultiViews'],
                  'index_options' => ['FancyIndexing'],
                  'index_style_sheet' => '/styles/style.css' },
                { 'path' => '/var/www/files/output_filtered',
                  'set_output_filter' => 'output_filter' },
                { 'path' => '/var/www/files/input_filtered',
                  'set_input_filter' => 'input_filter' },
                { 'path' => '/var/www/files',
                  'provider' => 'location',
                  'limit' => [
                    { 'methods' => 'GET HEAD',
                      'require' => ['valid-user'] },
                  ] },
                { 'path' => '/var/www/files',
                  'provider' => 'location',
                  'limit_except' => [
                    { 'methods' => 'GET HEAD',
                      'require' => ['valid-user'] },
                  ] },
                { 'path' => '/var/www/dav',
                  'dav' => 'filesystem',
                  'dav_depth_infinity' => true,
                  'dav_min_timeout' => 600 },
                {
                  'path' => '/var/www/http2',
                  'h2_copy_files' => true,
                  'h2_push_resource' => [
                    '/foo.css',
                    '/foo.js',
                  ]
                },
                {
                  'path' => '/',
                  'provider' => 'location',
                  'auth_ldap_referrals' => 'off',
                  'auth_basic_fake' => 'demo demopass',
                  'auth_user_file' => '/path/to/authz_user_file',
                  'auth_group_file' => '/path/to/authz_group_file',
                  'setenv' => ['SPECIAL_PATH /foo/bin']
                },
                {
                  'path' => '/proxy',
                  'provider' => 'location',
                  'proxy_pass' => [
                    {
                      'url' => 'http://backend-b/',
                      'keywords' => ['noquery', 'interpolate'],
                      'params' => {
                        'retry' => 0,
                        'timeout' => 5
                      }
                    },
                  ]
                },
                {
                  'path' => '^/proxy',
                  'provider' => 'locationmatch',
                  'proxy_pass_match' => [
                    {
                      'url' => 'http://backend-b/',
                      'keywords' => ['noquery', 'interpolate'],
                      'params' => {
                        'retry' => 0,
                        'timeout' => 5
                      }
                    },
                  ]
                },
                {
                  'path' => '/var/www/node-app/public',
                  'passenger_enabled' => true,
                  'passenger_base_uri' => '/app',
                  'passenger_ruby' => '/path/to/ruby',
                  'passenger_python' => '/path/to/python',
                  'passenger_nodejs' => '/path/to/nodejs',
                  'passenger_meteor_app_settings' => '/path/to/file.json',
                  'passenger_app_env' => 'demo',
                  'passenger_app_root' => '/var/www/node-app',
                  'passenger_app_group_name' => 'foo_bar',
                  'passenger_app_start_command' => 'start-command',
                  'passenger_app_type' => 'node',
                  'passenger_startup_file' => 'start.js',
                  'passenger_restart_dir' => 'temp',
                  'passenger_load_shell_envvars' => false,
                  'passenger_preload_bundler' => false,
                  'passenger_rolling_restarts' => false,
                  'passenger_resist_deployment_errors' => false,
                  'passenger_user' => 'nodeuser',
                  'passenger_group' => 'nodegroup',
                  'passenger_friendly_error_pages' => true,
                  'passenger_min_instances' => 7,
                  'passenger_max_instances' => 9,
                  'passenger_force_max_concurrent_requests_per_process' => 12,
                  'passenger_start_timeout' => 10,
                  'passenger_concurrency_model' => 'thread',
                  'passenger_thread_count' => 20,
                  'passenger_max_requests' => 2000,
                  'passenger_max_request_time' => 1,
                  'passenger_memory_limit' => 32,
                  'passenger_high_performance' => false,
                  'passenger_buffer_upload' => false,
                  'passenger_buffer_response' => false,
                  'passenger_error_override' => false,
                  'passenger_max_request_queue_size' => 120,
                  'passenger_max_request_queue_time' => 5,
                  'passenger_sticky_sessions' => true,
                  'passenger_sticky_sessions_cookie_name' => '_delicious_cookie',
                  'passenger_sticky_sessions_cookie_attributes' => 'SameSite=Lax; Secure;',
                  'passenger_allow_encoded_slashes' => false,
                  'passenger_app_log_file' => '/tmp/app.log',
                  'passenger_debugger' => false,
                  'gssapi' => {
                    'acceptor_name' => '{HOSTNAME}',
                    'allowed_mech' => ['krb5', 'iakerb', 'ntlmssp'],
                    'authname' => 'Kerberos 5',
                    'authtype' => 'GSSAPI',
                    'basic_auth' => true,
                    'basic_auth_mech' => ['krb5', 'iakerb', 'ntlmssp'],
                    'basic_ticket_timeout' => 300,
                    'connection_bound' => true,
                    'cred_store' => {
                      'ccache' => ['/path/to/directory'],
                      'client_keytab' => ['/path/to/example.keytab'],
                      'keytab' => ['/path/to/example.keytab']
                    },
                    'deleg_ccache_dir' => '/path/to/directory',
                    'deleg_ccache_env_var' => 'KRB5CCNAME',
                    'deleg_ccache_perms' => {
                      'mode' => '0600',
                      'uid' => 'example-user',
                      'gid' => 'example-group'
                    },
                    'deleg_ccache_unique' => true,
                    'impersonate' => true,
                    'local_name' => true,
                    'name_attributes' => 'json',
                    'negotiate_once' => true,
                    'publish_errors' => true,
                    'publish_mech' => true,
                    'required_name_attributes' =>	'auth-indicators=high',
                    'session_key' => 'file:/path/to/example.key',
                    'signal_persistent_auth' => true,
                    'ssl_only' => true,
                    'use_s4u2_proxy' => true,
                    'use_sessions' => true
                  }
                },
                {
                  'path' => '/private_1',
                  'provider' => 'location',
                  'ssl_options' => ['+ExportCertData', '+StdEnvVars'],
                  'ssl_verify_client' => 'optional',
                  'ssl_verify_depth' => 10
                },
                {
                  'path' => '/private_2',
                  'provider' => 'location',
                  'mellon_enable' => 'auth',
                  'mellon_sp_private_key_file' => '/etc/httpd/mellon/example.com_mellon.key',
                  'mellon_sp_cert_file' => '/etc/httpd/mellon/example.com_mellon.crt',
                  'mellon_sp_metadata_file' => '/etc/httpd/mellon/example.com_sp_mellon.xml',
                  'mellon_idp_metadata_file' => '/etc/httpd/mellon/example.com_idp_mellon.xml',
                  'mellon_set_env' => { 'isMemberOf' => 'urn:oid:1.3.6.1.4.1.5923.1.5.1.1' },
                  'mellon_set_env_no_prefix' => { 'isMemberOf' => 'urn:oid:1.3.6.1.4.1.5923.1.5.1.1' },
                  'mellon_user' => 'urn:oid:0.9.2342.19200300.100.1.1',
                  'mellon_saml_response_dump' => 'Off',
                  'mellon_cond' => ['isMemberOf "cn=example-access,ou=Groups,o=example,o=com" [MAP]'],
                  'mellon_session_length' => '300'
                },
              ],
              'error_log' => false,
              'error_log_file' => 'httpd_error_log',
              'error_log_syslog' => true,
              'error_log_format' => ['[%t] [%l] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i'],
              'error_documents' => 'true',
              'fallbackresource' => '/index.php',
              'scriptalias' => '/usr/lib/cgi-bin',
              'limitreqfieldsize' => 8190,
              'limitreqfields' => 100,
              'limitreqline' => 8190,
              'limitreqbody' => 0,
              'proxy_dest' => '/',
              'proxy_pass' => [
                {
                  'path' => '/a',
                  'url' => 'http://backend-a/',
                  'keywords' => ['noquery', 'interpolate'],
                  'no_proxy_uris' => ['/a/foo', '/a/bar'],
                  'no_proxy_uris_match' => ['/a/foomatch'],
                  'reverse_cookies' => [
                    {
                      'path' => '/a',
                      'url' => 'http://backend-a/'
                    },
                    {
                      'domain' => 'foo',
                      'url' => 'http://foo'
                    },
                  ],
                  'params' => {
                    'retry' => 0,
                    'timeout' => 5
                  },
                  'setenv' => ['proxy-nokeepalive 1', 'force-proxy-request-1.0 1']
                },
              ],
              'proxy_pass_match' => [
                {
                  'path' => '/a',
                  'url' => 'http://backend-a/',
                  'keywords' => ['noquery', 'interpolate'],
                  'no_proxy_uris' => ['/a/foo', '/a/bar'],
                  'no_proxy_uris_match' => ['/a/foomatch'],
                  'params' => {
                    'retry' => 0,
                    'timeout' => 5
                  },
                  'setenv' => ['proxy-nokeepalive 1', 'force-proxy-request-1.0 1']
                },
              ],
              'proxy_requests' => false,
              'php_admin_flags' => ['foo', 'bar'],
              'php_admin_values' => ['true', 'false'],
              'no_proxy_uris' => '/foo',
              'no_proxy_uris_match' => '/foomatch',
              'proxy_preserve_host' => true,
              'proxy_add_headers' => true,
              'proxy_error_override' => true,
              'redirect_source' => '/bar',
              'redirect_dest' => '/',
              'redirect_status' => 'temp',
              'redirectmatch_status' => ['404'],
              'redirectmatch_regexp' => ['\.git$'],
              'redirectmatch_dest' => ['http://www.example.com'],
              'headers' => ['Set X-Robots-Tag "noindex, noarchive, nosnippet"'],
              'request_headers' => ['append MirrorID "mirror 12"'],
              'rewrites' => [
                {
                  'rewrite_rule' => ['^index.html$ rewrites.html']
                },
              ],
              'filters' => [
                'FilterDeclare COMPRESS',
                'FilterProvider COMPRESS  DEFLATE resp=Content-Type $text/html',
                'FilterProvider COMPRESS  DEFLATE resp=Content-Type $text/css',
                'FilterProvider COMPRESS  DEFLATE resp=Content-Type $text/plain',
                'FilterProvider COMPRESS  DEFLATE resp=Content-Type $text/xml',
                'FilterChain COMPRESS',
                'FilterProtocol COMPRESS  DEFLATE change=yes;byteranges=no',
              ],
              'rewrite_base' => '/',
              'rewrite_rule' => '^index.html$ welcome.html',
              'rewrite_cond' => ['%{HTTP_USER_AGENT} ^MSIE'],
              'rewrite_inherit' => true,
              'setenv' => ['FOO=/bin/true'],
              'setenvif' => 'Request_URI "\.gif$" object_is_image=gif',
              'setenvifnocase' => 'REMOTE_ADDR ^127.0.0.1 localhost=true',
              'block' => 'scm',
              'wsgi_application_group' => '%{GLOBAL}',
              'wsgi_daemon_process' => { 'foo' => { 'python-home' => '/usr' }, 'bar' => {} },
              'wsgi_daemon_process_options' => {
                'processes' => 2,
                'threads' => 15,
                'display-name' => '%{GROUP}'
              },
              'wsgi_import_script' => '/var/www/demo.wsgi',
              'wsgi_import_script_options' => {
                'process-group' => 'wsgi',
                'application-group' => '%{GLOBAL}'
              },
              'wsgi_process_group' => 'wsgi',
              'wsgi_script_aliases' => {
                '/' => '/var/www/demo.wsgi'
              },
              'wsgi_script_aliases_match' => {
                '^/test/(^[/*)' => '/var/www/demo.wsgi'
              },
              'wsgi_pass_authorization' => 'On',
              'custom_fragment' => '#custom string',
              'itk' => {
                'user' => 'someuser',
                'group' => 'somegroup'
              },
              'wsgi_chunked_request' => 'On',
              'action' => 'foo',
              'additional_includes' => '/custom/path/includes',
              'use_optional_includes' => true,
              'suexec_user_group' => 'root root',
              'allow_encoded_slashes' => 'nodecode',
              'use_canonical_name' => 'dns',

              'h2_copy_files' => false,
              'h2_direct' => true,
              'h2_early_hints' => false,
              'h2_max_session_streams' => 100,
              'h2_modern_tls_only' => true,
              'h2_push' => true,
              'h2_push_diary_size' => 256,
              'h2_push_priority' => [
                'application/json 32',
              ],
              'h2_push_resource' => [
                '/css/main.css',
                '/js/main.js',
              ],
              'h2_serialize_headers' => false,
              'h2_stream_max_mem_size' => 65_536,
              'h2_tls_cool_down_secs' => 1,
              'h2_tls_warm_up_size' => 1_048_576,
              'h2_upgrade' => true,
              'h2_window_size' => 65_535,

              'passenger_enabled' => false,
              'passenger_base_uri' => '/app',
              'passenger_ruby' => '/usr/bin/ruby1.9.1',
              'passenger_python' => '/usr/local/bin/python',
              'passenger_nodejs' => '/usr/bin/node',
              'passenger_meteor_app_settings' => '/path/to/some/file.json',
              'passenger_app_env' => 'test',
              'passenger_app_root' => '/usr/share/myapp',
              'passenger_app_group_name' => 'app_customer',
              'passenger_app_start_command' => 'start-my-app',
              'passenger_app_type' => 'rack',
              'passenger_startup_file' => 'bin/www',
              'passenger_restart_dir' => 'tmp',
              'passenger_spawn_method' => 'direct',
              'passenger_load_shell_envvars' => false,
              'passenger_preload_bundler' => false,
              'passenger_rolling_restarts' => false,
              'passenger_resist_deployment_errors' => true,
              'passenger_user' => 'sandbox',
              'passenger_group' => 'sandbox',
              'passenger_friendly_error_pages' => false,
              'passenger_min_instances' => 1,
              'passenger_max_instances' => 30,
              'passenger_max_preloader_idle_time' => 600,
              'passenger_force_max_concurrent_requests_per_process' => 10,
              'passenger_start_timeout' => 600,
              'passenger_concurrency_model' => 'thread',
              'passenger_thread_count' => 5,
              'passenger_max_requests' => 1000,
              'passenger_max_request_time' => 2,
              'passenger_memory_limit' => 64,
              'passenger_stat_throttle_rate' => 5,
              'passenger_pre_start' => 'http://localhost/myapp',
              'passenger_high_performance' => true,
              'passenger_buffer_upload' => false,
              'passenger_buffer_response' => false,
              'passenger_error_override' => true,
              'passenger_max_request_queue_size' => 10,
              'passenger_max_request_queue_time' => 2,
              'passenger_sticky_sessions' => true,
              'passenger_sticky_sessions_cookie_name' => '_nom_nom_nom',
              'passenger_sticky_sessions_cookie_attributes' => 'Nom=nom; Secure;',
              'passenger_allow_encoded_slashes' => true,
              'passenger_app_log_file' => '/app/log/file',
              'passenger_debugger' => true,
              'passenger_lve_min_uid' => 500,
              'add_default_charset' => 'UTF-8',
              'jk_mounts' => [
                { 'mount'   => '/*',     'worker' => 'tcnode1' },
                { 'unmount' => '/*.jpg', 'worker' => 'tcnode1' },
              ],
              'auth_kerb' => true,
              'krb_method_negotiate' => 'off',
              'krb_method_k5passwd' => 'off',
              'krb_authoritative' => 'off',
              'krb_auth_realms' => ['EXAMPLE.ORG', 'EXAMPLE.NET'],
              'krb_5keytab' => '/tmp/keytab5',
              'krb_local_user_mapping' => 'off',
              'http_protocol_options' => 'Strict LenientMethods Allow0.9',
              'keepalive' => 'on',
              'keepalive_timeout' => 100,
              'max_keepalive_requests' => 1000,
              'protocols' => ['h2', 'http/1.1'],
              'protocols_honor_order' => true,
              'auth_oidc' => true,
              'oidc_settings' => { 'ProviderMetadataURL' => 'https://login.example.com/.well-known/openid-configuration',
                                   'ClientID' => 'test',
                                   'RedirectURI' => 'https://login.example.com/redirect_uri',
                                   'ProviderTokenEndpointAuth' => 'client_secret_basic',
                                   'RemoteUserClaim' => 'sub',
                                   'ClientSecret' => 'aae053a9-4abf-4824-8956-e94b2af335c8',
                                   'CryptoPassphrase' => '4ad1bb46-9979-450e-ae58-c696967df3cd' },
              'mdomain' => 'example.com example.net auto',
              'userdir' => 'disabled'
            }
          end

          it { is_expected.to compile }
          it { is_expected.not_to contain_file('/var/www/foo') }
          it { is_expected.to contain_class('apache::mod::ssl') }

          it {
            expect(subject).to contain_file('ssl.conf').with(
              content: %r{^\s+SSLHonorCipherOrder On$},
            )
          }

          it {
            expect(subject).to contain_file('ssl.conf').with(
              content: %r{^\s+SSLPassPhraseDialog builtin$},
            )
          }

          it {
            expect(subject).to contain_file('ssl.conf').with(
              content: %r{^\s+SSLSessionCacheTimeout 300$},
            )
          }

          it { is_expected.to contain_file('rspec.example.com_ssl_cert') }
          it { is_expected.to contain_file('rspec.example.com_ssl_key') }
          it { is_expected.to contain_file('rspec.example.com_ssl_chain') }
          it { is_expected.to contain_file('rspec.example.com_ssl_foo.crl') }

          it {
            expect(subject).to contain_file('/var/www/logs').with('ensure' => 'directory',
                                                                  'mode' => '0600')
          }

          it { is_expected.to contain_class('apache::mod::alias') }
          it { is_expected.to contain_class('apache::mod::auth_basic') }
          it { is_expected.to contain_class('apache::mod::authn_file') }
          it { is_expected.to contain_class('apache::mod::authz_groupfile') }
          it { is_expected.to contain_class('apache::mod::auth_gssapi') }
          it { is_expected.to contain_class('apache::mod::env') }
          it { is_expected.to contain_class('apache::mod::filter') }
          it { is_expected.to contain_class('apache::mod::headers') }
          it { is_expected.to contain_class('apache::mod::mime') }
          it { is_expected.to contain_class('apache::mod::passenger') }
          it { is_expected.to contain_class('apache::mod::proxy') }
          it { is_expected.to contain_class('apache::mod::proxy_http') }
          it { is_expected.to contain_class('apache::mod::rewrite') }
          it { is_expected.to contain_class('apache::mod::setenvif') }
          it { is_expected.to contain_class('apache::mod::suexec') }
          it { is_expected.to contain_class('apache::mod::vhost_alias') }
          it { is_expected.to contain_class('apache::mod::wsgi') }

          it {
            expect(subject).to contain_concat('30-rspec.example.com.conf').with('owner' => 'root',
                                                                                'mode' => '0644',
                                                                                'require' => 'Package[httpd]',
                                                                                'notify' => 'Class[Apache::Service]')
          }

          if os_facts[:os]['release']['major'].to_i >= 18 && os_facts[:os]['name'] == 'Ubuntu'
            it {
              expect(subject).to contain_file('30-rspec.example.com.conf symlink').with('ensure' => 'link',
                                                                                        'path' => "/etc/#{apache_name}/sites-enabled/30-rspec.example.com.conf")
            }
          end
          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header')
              .with_content(%r{^\s+LimitRequestFieldSize 8190$})
              .with_content(%r{^\s+LimitRequestFields 100$})
              .with_content(%r{^\s+LimitRequestLine 8190$})
              .with_content(%r{^\s+LimitRequestBody 0$})
          }

          it { is_expected.to contain_concat__fragment('rspec.example.com-docroot') }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-aliases').with(
              content: %r{^\s+Alias /image "/rspec/image"$},
            )
          }

          it { is_expected.to contain_concat__fragment('rspec.example.com-itk') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-fallbackresource') }

          # rubocop:disable RSpec/ExampleLength
          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-directories')
              .with_content(%r{^\s+<Proxy "\*">$})
              .with_content(%r{^\s+Include\s'/custom/path/includes'$})
              .with_content(%r{^\s+Include\s'/custom/path/another_includes'$})
              .with_content(%r{^\s+H2CopyFiles\sOn$})
              .with_content(%r{^\s+H2PushResource\s/foo.css$})
              .with_content(%r{^\s+H2PushResource\s/foo.js$})
              .with_content(%r{^\s+Require valid-user$})
              .with_content(%r{^\s+Require all denied$})
              .with_content(%r{^\s+Require all granted$})
              .with_content(%r{^\s+<RequireAll>$})
              .with_content(%r{^\s+</RequireAll>$})
              .with_content(%r{^\s+Require all-valid1$})
              .with_content(%r{^\s+Require all-valid2$})
              .with_content(%r{^\s+<RequireNone>$})
              .with_content(%r{^\s+</RequireNone>$})
              .with_content(%r{^\s+Require none-valid1$})
              .with_content(%r{^\s+Require none-valid2$})
              .with_content(%r{^\s+<RequireAny>$})
              .with_content(%r{^\s+</RequireAny>$})
              .with_content(%r{^\s+Require any-valid1$})
              .with_content(%r{^\s+Require any-valid2$})
              .with_content(%r{^\s+LDAPReferrals off$})
              .with_content(%r{^\s+ProxyPass http://backend-b/ retry=0 timeout=5 noquery interpolate$})
              .with_content(%r{^\s+ProxyPassMatch http://backend-b/ retry=0 timeout=5 noquery interpolate$})
              .with_content(%r{^\s+Options\sIndexes\sFollowSymLinks\sMultiViews$})
              .with_content(%r{^\s+IndexOptions\sFancyIndexing$})
              .with_content(%r{^\s+IndexStyleSheet\s'/styles/style\.css'$})
              .with_content(%r{^\s+DirectoryIndex\sdisabled$})
              .with_content(%r{^\s+SetOutputFilter\soutput_filter$})
              .with_content(%r{^\s+SetInputFilter\sinput_filter$})
              .with_content(%r{^\s+<Limit GET HEAD>$})
              .with_content(%r{\s+<Limit GET HEAD>\s*Require valid-user\s*</Limit>}m)
              .with_content(%r{^\s+<LimitExcept GET HEAD>$})
              .with_content(%r{\s+<LimitExcept GET HEAD>\s*Require valid-user\s*</LimitExcept>}m)
              .with_content(%r{^\s+Dav\sfilesystem$})
              .with_content(%r{^\s+DavDepthInfinity\sOn$})
              .with_content(%r{^\s+DavMinTimeout\s600$})
              .with_content(%r{^\s+PassengerEnabled\sOn$})
              .with_content(%r{^\s+PassengerBaseURI\s/app$})
              .with_content(%r{^\s+PassengerRuby\s/path/to/ruby$})
              .with_content(%r{^\s+PassengerPython\s/path/to/python$})
              .with_content(%r{^\s+PassengerNodejs\s/path/to/nodejs$})
              .with_content(%r{^\s+PassengerMeteorAppSettings\s/path/to/file\.json$})
              .with_content(%r{^\s+PassengerAppEnv\sdemo$})
              .with_content(%r{^\s+PassengerAppRoot\s/var/www/node-app$})
              .with_content(%r{^\s+PassengerAppGroupName\sfoo_bar$})
              .with_content(%r{^\s+PassengerAppType\snode$})
              .with_content(%r{^\s+PassengerStartupFile\sstart\.js$})
              .with_content(%r{^\s+PassengerRestartDir\stemp$})
              .with_content(%r{^\s+PassengerLoadShellEnvvars\sOff$})
              .with_content(%r{^\s+PassengerPreloadBundler\sOff$})
              .with_content(%r{^\s+PassengerRollingRestarts\sOff$})
              .with_content(%r{^\s+PassengerResistDeploymentErrors\sOff$})
              .with_content(%r{^\s+PassengerUser\snodeuser$})
              .with_content(%r{^\s+PassengerGroup\snodegroup$})
              .with_content(%r{^\s+PassengerFriendlyErrorPages\sOn$})
              .with_content(%r{^\s+PassengerMinInstances\s7$})
              .with_content(%r{^\s+PassengerMaxInstances\s9$})
              .with_content(%r{^\s+PassengerForceMaxConcurrentRequestsPerProcess\s12$})
              .with_content(%r{^\s+PassengerStartTimeout\s10$})
              .with_content(%r{^\s+PassengerConcurrencyModel\sthread$})
              .with_content(%r{^\s+PassengerThreadCount\s20$})
              .with_content(%r{^\s+PassengerMaxRequests\s2000$})
              .with_content(%r{^\s+PassengerMaxRequestTime\s1$})
              .with_content(%r{^\s+PassengerMemoryLimit\s32$})
              .with_content(%r{^\s+PassengerHighPerformance\sOff$})
              .with_content(%r{^\s+PassengerBufferUpload\sOff$})
              .with_content(%r{^\s+PassengerBufferResponse\sOff$})
              .with_content(%r{^\s+PassengerErrorOverride\sOff$})
              .with_content(%r{^\s+PassengerMaxRequestQueueSize\s120$})
              .with_content(%r{^\s+PassengerMaxRequestQueueTime\s5$})
              .with_content(%r{^\s+PassengerStickySessions\sOn$})
              .with_content(%r{^\s+PassengerStickySessionsCookieName\s_delicious_cookie$})
              .with_content(%r{^\s+PassengerAllowEncodedSlashes\sOff$})
              .with_content(%r{^\s+PassengerDebugger\sOff$})
              .with_content(%r{^\s+GssapiAcceptorName\s{HOSTNAME}$})
              .with_content(%r{^\s+GssapiAllowedMech\skrb5$})
              .with_content(%r{^\s+GssapiAllowedMech\siakerb$})
              .with_content(%r{^\s+GssapiAllowedMech\sntlmssp$})
              .with_content(%r{^\s+GssapiBasicAuth\sOn$})
              .with_content(%r{^\s+GssapiBasicAuthMech\skrb5$})
              .with_content(%r{^\s+GssapiBasicAuthMech\siakerb$})
              .with_content(%r{^\s+GssapiBasicAuthMech\sntlmssp$})
              .with_content(%r{^\s+GssapiBasicTicketTimeout\s300$})
              .with_content(%r{^\s+GssapiConnectionBound\sOn$})
              .with_content(%r{^\s+GssapiCredStore\sccache:FILE:/path/to/directory$})
              .with_content(%r{^\s+GssapiCredStore\sclient_keytab:/path/to/example\.keytab$})
              .with_content(%r{^\s+GssapiCredStore\skeytab:/path/to/example\.keytab$})
              .with_content(%r{^\s+GssapiDelegCcacheDir\s/path/to/directory$})
              .with_content(%r{^\s+GssapiDelegCcacheEnvVar\sKRB5CCNAME$})
              .with_content(%r{^\s+GssapiDelegCcachePerms\smode:0600\suid:example-user\sgid:example-group$})
              .with_content(%r{^\s+GssapiDelegCcacheUnique\sOn$})
              .with_content(%r{^\s+GssapiImpersonate\sOn$})
              .with_content(%r{^\s+GssapiLocalName\sOn$})
              .with_content(%r{^\s+GssapiNameAttributes\sjson$})
              .with_content(%r{^\s+GssapiNegotiateOnce\sOn$})
              .with_content(%r{^\s+GssapiPublishErrors\sOn$})
              .with_content(%r{^\s+GssapiPublishMech\sOn$})
              .with_content(%r{^\s+GssapiRequiredNameAttributes\s"auth-indicators=high"$})
              .with_content(%r{^\s+GssapiSessionKey\sfile:/path/to/example\.key$})
              .with_content(%r{^\s+GssapiSignalPersistentAuth\sOn$})
              .with_content(%r{^\s+GssapiSSLonly\sOn$})
              .with_content(%r{^\s+GssapiUseS4U2Proxy\sOn$})
              .with_content(%r{^\s+GssapiUseSessions\sOn$})
              .with_content(%r{^\s+SSLVerifyClient\soptional$})
              .with_content(%r{^\s+SSLVerifyDepth\s10$})
              .with_content(%r{^\s+MellonEnable\s"auth"$})
              .with_content(%r{^\s+MellonSPPrivateKeyFile\s"/etc/httpd/mellon/example\.com_mellon\.key"$})
              .with_content(%r{^\s+MellonSPCertFile\s"/etc/httpd/mellon/example\.com_mellon\.crt"$})
              .with_content(%r{^\s+MellonSPMetadataFile\s"/etc/httpd/mellon/example\.com_sp_mellon\.xml"$})
              .with_content(%r{^\s+MellonIDPMetadataFile\s"/etc/httpd/mellon/example\.com_idp_mellon\.xml"$})
              .with_content(%r{^\s+MellonSetEnv\s"isMemberOf"\s"urn:oid:1\.3\.6\.1\.4\.1\.5923\.1\.5\.1\.1"$})
              .with_content(%r{^\s+MellonSetEnvNoPrefix\s"isMemberOf"\s"urn:oid:1\.3\.6\.1\.4\.1\.5923\.1\.5\.1\.1"$})
              .with_content(%r{^\s+MellonUser\s"urn:oid:0\.9\.2342\.19200300\.100\.1\.1"$})
              .with_content(%r{^\s+MellonCond\sisMemberOf\s"cn=example-access,ou=Groups,o=example,o=com"\s\[MAP\]$})
              .with_content(%r{^\s+MellonSessionLength\s"300"$})
          }
          # rubocop:enable RSpec/ExampleLength

          it { is_expected.to contain_concat__fragment('rspec.example.com-additional_includes') }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-logging')
              .with_content(%r{^\s+ErrorLogFormat "\[%t\] \[%l\] %7F: %E: \[client\\ %a\] %M% ,\\ referer\\ %\{Referer\}i"$})
          }

          it { is_expected.to contain_concat__fragment('rspec.example.com-serversignature') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-access_log') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-action') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-block') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-error_document') }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-proxy')
              .with_content(%r{retry=0})
              .with_content(%r{timeout=5})
              .with_content(%r{SetEnv force-proxy-request-1.0 1})
              .with_content(%r{SetEnv proxy-nokeepalive 1})
              .with_content(%r{noquery interpolate})
              .with_content(%r{ProxyPreserveHost On})
              .with_content(%r{ProxyAddHeaders On})
              .with_content(%r{ProxyPassReverseCookiePath\s+/a\s+http://})
              .with_content(%r{ProxyPassReverseCookieDomain\s+foo\s+http://foo})
          }

          it { is_expected.to contain_concat__fragment('rspec.example.com-redirect') }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-rewrite')
              .with_content(%r{^\s+RewriteEngine On$})
              .with_content(%r{^\s+RewriteOptions Inherit$})
              .with_content(%r{^\s+RewriteBase /})
              .with_content(%r{^\s+RewriteRule \^index\.html\$ rewrites.html$})
          }

          it { is_expected.to contain_concat__fragment('rspec.example.com-scriptalias') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-serveralias') }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-setenv')
              .with_content(%r{SetEnv FOO=/bin/true})
              .with_content(%r{SetEnvIf Request_URI "\\.gif\$" object_is_image=gif})
              .with_content(%r{SetEnvIfNoCase REMOTE_ADDR \^127.0.0.1 localhost=true})
          }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-ssl')
              .with_content(%r{^\s+SSLOpenSSLConfCmd\s+DHParameters "foo.pem"$})
              .with_content(%r{^\s+SSLHonorCipherOrder\s+Off$})
              .with_content(%r{^\s+SSLUserName\s+SSL_CLIENT_S_DN_CN$})
          }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-sslproxy')
              .with_content(%r{^\s+SSLProxyEngine On$})
              .with_content(%r{^\s+SSLProxyCheckPeerCN\s+on$})
              .with_content(%r{^\s+SSLProxyCheckPeerName\s+on$})
              .with_content(%r{^\s+SSLProxyCheckPeerExpire\s+on$})
              .with_content(%r{^\s+SSLProxyCipherSuite\s+HIGH$})
              .with_content(%r{^\s+SSLProxyProtocol\s+TLSv1.2$})
          }

          it { is_expected.to contain_concat__fragment('rspec.example.com-php_admin') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-header') }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-filters').with(
              content: %r{^\s+FilterDeclare COMPRESS$},
            )
          }

          it { is_expected.to contain_concat__fragment('rspec.example.com-requestheader') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-wsgi') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-custom_fragment') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-suexec') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-allow_encoded_slashes') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-passenger') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-charsets') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-security') }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-file_footer')
              .with_content(%r{^PassengerPreStart\shttp://localhost/myapp$})
          }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-jk_mounts')
              .with_content(%r{^\s+JkMount\s+/\*\s+tcnode1$})
              .with_content(%r{^\s+JkUnMount\s+/\*\.jpg\s+tcnode1$})
          }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-auth_kerb')
              .with_content(%r{^\s+KrbMethodNegotiate\soff$})
              .with_content(%r{^\s+KrbAuthoritative\soff$})
              .with_content(%r{^\s+KrbAuthRealms\sEXAMPLE.ORG\sEXAMPLE.NET$})
              .with_content(%r{^\s+Krb5Keytab\s/tmp/keytab5$})
              .with_content(%r{^\s+KrbLocalUserMapping\soff$})
              .with_content(%r{^\s+KrbServiceName\sHTTP$})
              .with_content(%r{^\s+KrbSaveCredentials\soff$})
              .with_content(%r{^\s+KrbVerifyKDC\son$})
          }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-http_protocol_options').with(
              content: %r{^\s*HttpProtocolOptions\s+Strict\s+LenientMethods\s+Allow0\.9$},
            )
          }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-keepalive_options')
              .with_content(%r{^\s+KeepAlive\son$})
              .with_content(%r{^\s+KeepAliveTimeout\s100$})
              .with_content(%r{^\s+MaxKeepAliveRequests\s1000$})
          }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header')
              .with_content(%r{^\s+Protocols\sh2 http/1.1$})
              .with_content(%r{^\s+ProtocolsHonorOrder\sOn$})
          }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-http2')
              .with_content(%r{^\s+H2CopyFiles\sOff$})
              .with_content(%r{^\s+H2Direct\sOn$})
              .with_content(%r{^\s+H2EarlyHints\sOff$})
              .with_content(%r{^\s+H2MaxSessionStreams\s100$})
              .with_content(%r{^\s+H2ModernTLSOnly\sOn$})
              .with_content(%r{^\s+H2Push\sOn$})
              .with_content(%r{^\s+H2PushDiarySize\s256$})
              .with_content(%r{^\s+H2PushPriority\sapplication/json 32$})
              .with_content(%r{^\s+H2PushResource\s/css/main.css$})
              .with_content(%r{^\s+H2PushResource\s/js/main.js$})
              .with_content(%r{^\s+H2SerializeHeaders\sOff$})
              .with_content(%r{^\s+H2StreamMaxMemSize\s65536$})
              .with_content(%r{^\s+H2TLSCoolDownSecs\s1$})
              .with_content(%r{^\s+H2TLSWarmUpSize\s1048576$})
              .with_content(%r{^\s+H2Upgrade\sOn$})
              .with_content(%r{^\s+H2WindowSize\s65535$})
          }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-passenger')
              .with_content(%r{^\s+PassengerEnabled\sOff$})
              .with_content(%r{^\s+PassengerBaseURI\s/app$})
              .with_content(%r{^\s+PassengerRuby\s/usr/bin/ruby1\.9\.1$})
              .with_content(%r{^\s+PassengerPython\s/usr/local/bin/python$})
              .with_content(%r{^\s+PassengerNodejs\s/usr/bin/node$})
              .with_content(%r{^\s+PassengerMeteorAppSettings\s/path/to/some/file.json$})
              .with_content(%r{^\s+PassengerAppEnv\stest$})
              .with_content(%r{^\s+PassengerAppRoot\s/usr/share/myapp$})
              .with_content(%r{^\s+PassengerAppGroupName\sapp_customer$})
              .with_content(%r{^\s+PassengerAppType\srack$})
              .with_content(%r{^\s+PassengerStartupFile\sbin/www$})
              .with_content(%r{^\s+PassengerRestartDir\stmp$})
              .with_content(%r{^\s+PassengerSpawnMethod\sdirect$})
              .with_content(%r{^\s+PassengerLoadShellEnvvars\sOff$})
              .with_content(%r{^\s+PassengerPreloadBundler\sOff$})
              .with_content(%r{^\s+PassengerRollingRestarts\sOff$})
              .with_content(%r{^\s+PassengerResistDeploymentErrors\sOn$})
              .with_content(%r{^\s+PassengerUser\ssandbox$})
              .with_content(%r{^\s+PassengerGroup\ssandbox$})
              .with_content(%r{^\s+PassengerFriendlyErrorPages\sOff$})
              .with_content(%r{^\s+PassengerMinInstances\s1$})
              .with_content(%r{^\s+PassengerMaxInstances\s30$})
              .with_content(%r{^\s+PassengerMaxPreloaderIdleTime\s600$})
              .with_content(%r{^\s+PassengerForceMaxConcurrentRequestsPerProcess\s10$})
              .with_content(%r{^\s+PassengerStartTimeout\s600$})
              .with_content(%r{^\s+PassengerConcurrencyModel\sthread$})
              .with_content(%r{^\s+PassengerThreadCount\s5$})
              .with_content(%r{^\s+PassengerMaxRequests\s1000$})
              .with_content(%r{^\s+PassengerMaxRequestTime\s2$})
              .with_content(%r{^\s+PassengerMemoryLimit\s64$})
              .with_content(%r{^\s+PassengerStatThrottleRate\s5$})
              .with_content(%r{^\s+PassengerHighPerformance\sOn$})
              .with_content(%r{^\s+PassengerBufferUpload\sOff$})
              .with_content(%r{^\s+PassengerBufferResponse\sOff$})
              .with_content(%r{^\s+PassengerErrorOverride\sOn$})
              .with_content(%r{^\s+PassengerMaxRequestQueueSize\s10$})
              .with_content(%r{^\s+PassengerMaxRequestQueueTime\s2$})
              .with_content(%r{^\s+PassengerStickySessions\sOn$})
              .with_content(%r{^\s+PassengerStickySessionsCookieName\s_nom_nom_nom$})
              .with_content(%r{^\s+PassengerAllowEncodedSlashes\sOn$})
              .with_content(%r{^\s+PassengerDebugger\sOn$})
              .with_content(%r{^\s+PassengerLveMinUid\s500$})
          }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-auth_oidc')
              .with_content(%r{^\s+OIDCProviderMetadataURL\shttps://login.example.com/\.well-known/openid-configuration$})
              .with_content(%r{^\s+OIDCClientID\stest$})
              .with_content(%r{^\s+OIDCRedirectURI\shttps://login\.example.com/redirect_uri$})
              .with_content(%r{^\s+OIDCProviderTokenEndpointAuth\sclient_secret_basic$})
              .with_content(%r{^\s+OIDCRemoteUserClaim\ssub$})
              .with_content(%r{^\s+OIDCClientSecret\saae053a9-4abf-4824-8956-e94b2af335c8$})
              .with_content(%r{^\s+OIDCCryptoPassphrase\s4ad1bb46-9979-450e-ae58-c696967df3cd$})
          }

          it { is_expected.to contain_class('apache::mod::md') }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{^MDomain example\.com example\.net auto$},
            )
          }
        end

        context 'vhost with proxy_add_headers true' do
          let :params do
            {
              'docroot' => '/var/www/foo',
              'manage_docroot' => false,
              'virtual_docroot' => true,
              'virtual_use_default_docroot' => false,
              'port' => 8080,
              'ip' => '127.0.0.1',
              'ip_based' => true,
              'add_listen' => false,
              'serveradmin' => 'foo@localhost',
              'priority' => 30,
              'default_vhost' => true,
              'servername' => 'example.com',
              'serveraliases' => ['test-example.com'],
              'options' => ['MultiView'],
              'override' => ['All'],
              'directoryindex' => 'index.html',
              'vhost_name' => 'test',
              'proxy_add_headers' => true
            }
          end

          it { is_expected.to compile }
          it { is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(%r{ProxyAddHeaders On}) }
        end

        context 'vhost with proxy_add_headers false' do
          let :params do
            {
              'docroot' => '/var/www/foo',
              'manage_docroot' => false,
              'virtual_docroot' => true,
              'virtual_use_default_docroot' => false,
              'port' => 8080,
              'ip' => '127.0.0.1',
              'ip_based' => true,
              'add_listen' => false,
              'serveradmin' => 'foo@localhost',
              'priority' => 30,
              'default_vhost' => true,
              'servername' => 'example.com',
              'serveraliases' => ['test-example.com'],
              'options' => ['MultiView'],
              'override' => ['All'],
              'directoryindex' => 'index.html',
              'vhost_name' => 'test',
              'proxy_add_headers' => false
            }
          end

          it { is_expected.to compile }
          it { is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(%r{ProxyAddHeaders Off}) }
        end

        context 'vhost without proxy' do
          let :params do
            {
              'docroot' => '/var/www/foo',
              'manage_docroot' => false,
              'virtual_docroot' => true,
              'virtual_use_default_docroot' => false,
              'port' => 8080,
              'ip' => '127.0.0.1',
              'ip_based' => true,
              'add_listen' => false,
              'serveradmin' => 'foo@localhost',
              'priority' => 30,
              'default_vhost' => true,
              'servername' => 'example.com',
              'serveraliases' => ['test-example.com'],
              'options' => ['MultiView'],
              'override' => ['All'],
              'directoryindex' => 'index.html',
              'vhost_name' => 'test'
            }
          end

          it { is_expected.to compile }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-proxy') }
        end

        context 'vhost without proxy_add_headers' do
          let :params do
            {
              'docroot' => '/var/www/foo',
              'manage_docroot' => false,
              'virtual_docroot' => true,
              'virtual_use_default_docroot' => false,
              'port' => 8080,
              'ip' => '127.0.0.1',
              'ip_based' => true,
              'add_listen' => false,
              'serveradmin' => 'foo@localhost',
              'priority' => 30,
              'default_vhost' => true,
              'servername' => 'example.com',
              'serveraliases' => ['test-example.com'],
              'options' => ['MultiView'],
              'override' => ['All'],
              'directoryindex' => 'index.html',
              'vhost_name' => 'test',
              'proxy_preserve_host' => true
            }
          end

          it { is_expected.to compile }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-proxy').with_content(%r{ProxyAddHeaders}) }
        end

        context 'vhost with scheme and port in servername and use_servername_for_filenames' do
          let :params do
            {
              'port' => 80,
              'ip' => '127.0.0.1',
              'ip_based' => true,
              'servername' => 'https://www.example.com:443',
              'docroot' => '/var/www/html',
              'add_listen' => true,
              'ensure' => 'present',
              'use_servername_for_filenames' => true
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{^\s+ServerName https://www\.example\.com:443$},
            )
          }

          it {
            expect(subject).to contain_concat('25-www.example.com.conf')
          }
        end

        context 'vhost with scheme in servername and use_servername_for_filenames' do
          let :params do
            {
              'port' => 80,
              'ip' => '127.0.0.1',
              'ip_based' => true,
              'servername' => 'https://www.example.com',
              'docroot' => '/var/www/html',
              'add_listen' => true,
              'ensure' => 'present',
              'use_servername_for_filenames' => true
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{^\s+ServerName https://www\.example\.com$},
            )
          }

          it {
            expect(subject).to contain_concat('25-www.example.com.conf')
          }
        end

        context 'vhost with port in servername and use_servername_for_filenames' do
          let :params do
            {
              'port' => 80,
              'ip' => '127.0.0.1',
              'ip_based' => true,
              'servername' => 'www.example.com:443',
              'docroot' => '/var/www/html',
              'add_listen' => true,
              'ensure' => 'present',
              'use_servername_for_filenames' => true
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{^\s+ServerName www\.example\.com:443$},
            )
          }

          it {
            expect(subject).to contain_concat('25-www.example.com.conf')
          }
        end

        context 'vhost with servername and use_servername_for_filenames' do
          let :params do
            {
              'port' => 80,
              'ip' => '127.0.0.1',
              'ip_based' => true,
              'servername' => 'www.example.com',
              'docroot' => '/var/www/html',
              'add_listen' => true,
              'ensure' => 'present',
              'use_servername_for_filenames' => true
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{^\s+ServerName www\.example\.com$},
            )
          }

          it {
            expect(subject).to contain_concat('25-www.example.com.conf')
          }
        end

        context 'vhost with multiple ip addresses' do
          let :params do
            {
              'port' => 80,
              'ip' => ['127.0.0.1', '::1'],
              'ip_based' => true,
              'servername' => 'example.com',
              'docroot' => '/var/www/html',
              'add_listen' => true,
              'ensure' => 'present'
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{[./m]*<VirtualHost 127.0.0.1:80 \[::1\]:80>[./m]*$},
            )
          }

          it { is_expected.to contain_concat__fragment('Listen 127.0.0.1:80') }
          it { is_expected.to contain_concat__fragment('Listen [::1]:80') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost 127.0.0.1:80') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost [::1]:80') }
        end

        context 'vhost with multiple ports' do
          let :params do
            {
              'port' => [80, 8080],
              'ip' => '127.0.0.1',
              'ip_based' => true,
              'servername' => 'example.com',
              'docroot' => '/var/www/html',
              'add_listen' => true,
              'ensure' => 'present'
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{[./m]*<VirtualHost 127.0.0.1:80 127.0.0.1:8080>[./m]*$},
            )
          }

          it { is_expected.to contain_concat__fragment('Listen 127.0.0.1:80') }
          it { is_expected.to contain_concat__fragment('Listen 127.0.0.1:8080') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost 127.0.0.1:80') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost 127.0.0.1:8080') }
        end

        context 'vhost with multiple ip addresses, multiple ports' do
          let :params do
            {
              'port' => [80, 8080],
              'ip' => ['127.0.0.1', '::1'],
              'ip_based' => true,
              'servername' => 'example.com',
              'docroot' => '/var/www/html',
              'add_listen' => true,
              'ensure' => 'present'
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{[./m]*<VirtualHost 127.0.0.1:80 127.0.0.1:8080 \[::1\]:80 \[::1\]:8080>[./m]*$},
            )
          }

          it { is_expected.to contain_concat__fragment('Listen 127.0.0.1:80') }
          it { is_expected.to contain_concat__fragment('Listen 127.0.0.1:8080') }
          it { is_expected.to contain_concat__fragment('Listen [::1]:80') }
          it { is_expected.to contain_concat__fragment('Listen [::1]:8080') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost 127.0.0.1:80') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost 127.0.0.1:8080') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost [::1]:80') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost [::1]:8080') }
        end

        context 'vhost with ipv6 address' do
          let :params do
            {
              'port' => 80,
              'ip' => '::1',
              'ip_based' => true,
              'servername' => 'example.com',
              'docroot' => '/var/www/html',
              'add_listen' => true,
              'ensure' => 'present'
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{[./m]*<VirtualHost \[::1\]:80>[./m]*$},
            )
          }

          it { is_expected.to contain_concat__fragment('Listen [::1]:80') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost [::1]:80') }
        end

        context 'vhost with wildcard ip address' do
          let :params do
            {
              'port' => 80,
              'ip' => '*',
              'ip_based' => true,
              'servername' => 'example.com',
              'docroot' => '/var/www/html',
              'add_listen' => true,
              'ensure' => 'present'
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{[./m]*<VirtualHost \*:80>[./m]*$},
            )
          }

          it { is_expected.to contain_concat__fragment('Listen *:80') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost *:80') }
        end

        context 'vhost with backwards compatible virtual_docroot' do
          let :params do
            {
              'docroot' => '/var/www/html',
              'virtual_docroot' => '/var/www/sites/%0'
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-docroot').with(
              content: %r{^\s+VirtualDocumentRoot "/var/www/sites/%0"$},
            )
          }

          it {
            expect(subject).not_to contain_concat__fragment('rspec.example.com-docroot').with(
              content: %r{^\s+DocumentRoot "/var/www/html"$},
            )
          }
        end

        context 'vhost with virtual_docroot and docroot' do
          let :params do
            {
              'docroot' => '/var/www/html',
              'virtual_use_default_docroot' => true,
              'virtual_docroot' => '/var/www/sites/%0'
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-docroot').with(
              content: %r{^\s+VirtualDocumentRoot "/var/www/sites/%0"$},
            )
          }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-docroot').with(
              content: %r{^\s+DocumentRoot "/var/www/html"$},
            )
          }
        end

        context 'modsec_audit_log' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'modsec_audit_log' => true
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-security').with(
              content: %r{^\s*SecAuditLog "/var/log/#{apache_name}/rspec\.example\.com_security\.log"$},
            )
          }
        end

        context 'modsec_audit_log_file' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'modsec_audit_log_file' => 'foo.log'
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-security').with(
              content: %r{\s*SecAuditLog "/var/log/#{apache_name}/foo.log"$},
            )
          }
        end

        context 'modsec_anomaly_threshold' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'modsec_inbound_anomaly_threshold' => 10_000,
              'modsec_outbound_anomaly_threshold' => 10_000
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-security').with(
              content: %r{
                ^\s+SecAction\ \\\n
                \s+"id:900110,\\\n
                \s+phase:1,\\\n
                \s+nolog,\\\n
                \s+pass,\\\n
                \s+t:none,\\\n
                \s+setvar:tx.inbound_anomaly_score_threshold=10000,\ \\\n
                \s+setvar:tx.outbound_anomaly_score_threshold=10000"$
              }x,
            )
          }
        end

        context 'modsec_allowed_methods' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'modsec_allowed_methods' => 'GET HEAD POST OPTIONS'
            }
          end

          it { is_expected.to compile }

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-security').with(
              content: %r{
              ^\s+SecAction\ \\\n
              \s+"id:900200,\\\n
              \s+phase:1,\\\n
              \s+nolog,\\\n\s+pass,\\\n
              \s+t:none,\\\n
              \s+setvar:'tx.allowed_methods=GET\ HEAD\ POST\ OPTIONS'"$
              }x,
            )
          }
        end

        context 'set only aliases' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'aliases' => [
                {
                  'alias' => '/alias',
                  'path' => '/rspec/docroot'
                },
              ]
            }
          end

          it { is_expected.to contain_class('apache::mod::alias') }
        end

        context 'proxy_pass_match' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'proxy_pass_match' => [
                {
                  'path' => '.*',
                  'url' => 'http://backend-a/',
                  'params' => { 'timeout' => 300 }
                },
              ]
            }
          end

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-proxy').with_content(
              %r{ProxyPassMatch .* http://backend-a/ timeout=300},
            ).with_content(%r{## Proxy rules})
          }
        end

        context 'proxy_dest_match and no proxy_dest_reverse_match' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'proxy_dest_match' => '/'
            }
          end

          it { is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(%r{## Proxy rules}) }
          it { is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(%r{ProxyPassMatch\s+/\s+//}) }
          it { is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(%r{ProxyPassReverse\s+/\s+/}) }
        end

        context 'proxy_dest_match and proxy_dest_reverse_match' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'proxy_dest_match' => '/',
              'proxy_dest_reverse_match' => 'http://localhost:8180'
            }
          end

          it { is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(%r{## Proxy rules}) }
          it { is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(%r{ProxyPassMatch\s+/\s+//}) }
          it { is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(%r{ProxyPassReverse\s+/\s+http://localhost:8180/}) }
        end

        context 'not everything can be set together...' do
          let :params do
            {
              'access_log_pipe' => '/dev/null',
              'error_log_pipe' => '/dev/null',
              'docroot' => '/var/www/foo',
              'ensure' => 'absent',
              'manage_docroot' => true,
              'logroot' => '/tmp/logroot',
              'logroot_ensure' => 'absent'
            }
          end

          it { is_expected.to compile }
          it { is_expected.not_to contain_class('apache::mod::ssl') }
          it { is_expected.not_to contain_class('apache::mod::mime') }
          it { is_expected.not_to contain_class('apache::mod::vhost_alias') }
          it { is_expected.not_to contain_class('apache::mod::wsgi') }
          it { is_expected.not_to contain_class('apache::mod::passenger') }
          it { is_expected.not_to contain_class('apache::mod::suexec') }
          it { is_expected.not_to contain_class('apache::mod::rewrite') }
          it { is_expected.not_to contain_class('apache::mod::alias') }
          it { is_expected.not_to contain_class('apache::mod::proxy') }
          it { is_expected.not_to contain_class('apache::mod::proxy_http') }
          it { is_expected.not_to contain_class('apache::mod::headers') }
          it { is_expected.not_to contain_file('rspec.example.com_ssl_cert') }
          it { is_expected.not_to contain_file('rspec.example.com_ssl_key') }
          it { is_expected.not_to contain_file('rspec.example.com_ssl_chain') }
          it { is_expected.not_to contain_file('rspec.example.com_ssl_foo.crl') }
          it { is_expected.to contain_file('/var/www/foo') }

          it {
            expect(subject).to contain_file('/tmp/logroot').with('ensure' => 'absent')
          }

          it {
            expect(subject).to contain_concat('25-rspec.example.com.conf').with('ensure' => 'absent')
          }

          it { is_expected.to contain_concat__fragment('rspec.example.com-apache-header') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-docroot') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-aliases') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-itk') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-fallbackresource') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-directories') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-additional_includes') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-logging') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-serversignature') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-access_log') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-action') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-block') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-error_document') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-proxy') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-redirect') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-rewrite') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-scriptalias') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-serveralias') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-setenv') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-ssl') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-sslproxy') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-php_admin') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-header') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-requestheader') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-wsgi') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-custom_fragment') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-suexec') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-charsets') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-limits') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-file_footer') }
        end

        context 'wsgi_application_group should set apache::mod::wsgi' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'wsgi_application_group' => '%{GLOBAL}'
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end

        context 'wsgi_daemon_process should set apache::mod::wsgi' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'wsgi_daemon_process' => { 'foo' => { 'python-home' => '/usr' }, 'bar' => {} }
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end

        context 'wsgi_import_script on its own should not set apache::mod::wsgi' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'wsgi_import_script' => '/var/www/demo.wsgi'
            }
          end

          it { is_expected.not_to contain_class('apache::mod::wsgi') }
        end

        context 'wsgi_import_script_options on its own should not set apache::mod::wsgi' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'wsgi_import_script_options' => {
                'process-group' => 'wsgi',
                'application-group' => '%{GLOBAL}'
              }
            }
          end

          it { is_expected.not_to contain_class('apache::mod::wsgi') }
        end

        context 'wsgi_import_script and wsgi_import_script_options should set apache::mod::wsgi' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'wsgi_import_script' => '/var/www/demo.wsgi',
              'wsgi_import_script_options' => {
                'process-group' => 'wsgi',
                'application-group' => '%{GLOBAL}'
              }
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end

        context 'wsgi_process_group should set apache::mod::wsgi' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'wsgi_daemon_process' => 'wsgi'
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end

        context 'wsgi_script_aliases with non-empty aliases should set apache::mod::wsgi' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'wsgi_script_aliases' => {
                '/' => '/var/www/demo.wsgi'
              }
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end

        context 'wsgi_script_aliases with empty aliases should set apache::mod::wsgi' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'wsgi_script_aliases' => {}
            }
          end

          it { is_expected.not_to contain_class('apache::mod::wsgi') }
        end

        context 'wsgi_pass_authorization should set apache::mod::wsgi' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'wsgi_pass_authorization' => 'On'
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end

        context 'when not setting nor managing the docroot' do
          let :params do
            {
              'docroot' => false,
              'manage_docroot' => false
            }
          end

          it { is_expected.to compile }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-docroot') }
        end

        context 'ssl_proxyengine without ssl' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'ssl' => false,
              'ssl_proxyengine' => true
            }
          end

          it { is_expected.to compile }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-ssl') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-sslproxy') }
        end

        context 'ssl_proxy_protocol without ssl_proxyengine' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'ssl' => true,
              'ssl_proxyengine' => false,
              'ssl_proxy_protocol' => 'TLSv1.2'
            }
          end

          it { is_expected.to compile }
          it { is_expected.to contain_concat__fragment('rspec.example.com-ssl') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-sslproxy') }
        end

        context 'ssl_honorcipherorder' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'ssl' => true
            }
          end

          context 'ssl_honorcipherorder default' do
            it { is_expected.to compile }
            it { is_expected.to contain_concat__fragment('rspec.example.com-ssl').without_content(%r{^\s*SSLHonorCipherOrder}i) }
          end

          context 'ssl_honorcipherorder on' do
            let :params do
              super().merge({ 'ssl_honorcipherorder' => 'on' })
            end

            it { is_expected.to compile }
            it { is_expected.to contain_concat__fragment('rspec.example.com-ssl').with_content(%r{^\s*SSLHonorCipherOrder\s+On$}) }
          end

          context 'ssl_honorcipherorder true' do
            let :params do
              super().merge({ 'ssl_honorcipherorder' => true })
            end

            it { is_expected.to compile }
            it { is_expected.to contain_concat__fragment('rspec.example.com-ssl').with_content(%r{^\s*SSLHonorCipherOrder\s+On$}) }
          end

          context 'ssl_honorcipherorder off' do
            let :params do
              super().merge({ 'ssl_honorcipherorder' => 'off' })
            end

            it { is_expected.to compile }
            it { is_expected.to contain_concat__fragment('rspec.example.com-ssl').with_content(%r{^\s*SSLHonorCipherOrder\s+Off$}) }
          end

          context 'ssl_honorcipherorder false' do
            let :params do
              super().merge({ 'ssl_honorcipherorder' => false })
            end

            it { is_expected.to compile }
            it { is_expected.to contain_concat__fragment('rspec.example.com-ssl').with_content(%r{^\s*SSLHonorCipherOrder\s+Off$}) }
          end
        end

        describe 'access logs' do
          context 'single log file' do
            let(:params) do
              {
                'docroot' => '/rspec/docroot',
                'access_log_file' => 'my_log_file'
              }
            end

            it {
              expect(subject).to contain_concat__fragment('rspec.example.com-access_log').with(
                content: %r{^\s+CustomLog.*my_log_file" combined\s*$},
              )
            }
          end

          context 'single log file with environment' do
            let(:params) do
              {
                'docroot' => '/rspec/docroot',
                'access_log_file' => 'my_log_file',
                'access_log_env_var' => 'prod'
              }
            end

            it {
              expect(subject).to contain_concat__fragment('rspec.example.com-access_log').with(
                content: %r{^\s+CustomLog.*my_log_file" combined\s+env=prod$},
              )
            }
          end

          context 'multiple log files' do
            let(:params) do
              {
                'docroot' => '/rspec/docroot',
                'access_logs' => [
                  { 'file' => '/tmp/log1', 'env' => 'dev' },
                  { 'file' => 'log2' },
                  { 'syslog' => 'syslog', 'format' => '%h %l' },
                ]
              }
            end

            it {
              expect(subject).to contain_concat__fragment('rspec.example.com-access_log').with(
                content: %r{^\s+CustomLog "/tmp/log1"\s+combined\s+env=dev$},
              )
            }

            it {
              expect(subject).to contain_concat__fragment('rspec.example.com-access_log').with(
                content: %r{^\s+CustomLog "/var/log/#{apache_name}/log2"\s+combined\s*$},
              )
            }

            it {
              expect(subject).to contain_concat__fragment('rspec.example.com-access_log').with(
                content: %r{^\s+CustomLog "syslog" "%h %l"\s*$},
              )
            }
          end
        end

        describe 'error logs format' do
          context 'single log format directive as a string' do
            let(:params) do
              {
                'docroot' => '/rspec/docroot',
                'error_log_format' => ['[%t] [%l] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i']
              }
            end

            it {
              expect(subject).to contain_concat__fragment('rspec.example.com-logging').with(
                content: %r{^\s+ErrorLogFormat "\[%t\] \[%l\] %7F: %E: \[client\\ %a\] %M% ,\\ referer\\ %\{Referer\}i"$},
              )
            }
          end

          context 'multiple log format directives' do
            let(:params) do
              {
                'docroot' => '/rspec/docroot',
                'error_log_format' => [
                  '[%{uc}t] [%-m:%-l] [R:%L] [C:%{C}L] %7F: %E: %M',
                  { '[%{uc}t] [R:%L] Request %k on C:%{c}L pid:%P tid:%T' => 'request' },
                  { "[%{uc}t] [R:%L] UA:'%+{User-Agent}i'" => 'request' },
                  { "[%{uc}t] [R:%L] Referer:'%+{Referer}i'" => 'request' },
                  { '[%{uc}t] [C:%{c}L] local\ %a remote\ %A' => 'connection' },
                ]
              }
            end

            it {
              expect(subject).to contain_concat__fragment('rspec.example.com-logging')
                .with_content(%r{^\s+ErrorLogFormat "\[%\{uc\}t\] \[%-m:%-l\] \[R:%L\] \[C:%\{C\}L\] %7F: %E: %M"$})
                .with_content(%r{^\s+ErrorLogFormat request "\[%\{uc\}t\] \[R:%L\] Request %k on C:%\{c\}L pid:%P tid:%T"$})
                .with_content(%r{^\s+ErrorLogFormat request "\[%\{uc\}t\] \[R:%L\] UA:'%\+\{User-Agent\}i'"$})
                .with_content(%r{^\s+ErrorLogFormat request "\[%\{uc\}t\] \[R:%L\] Referer:'%\+\{Referer\}i'"$})
                .with_content(%r{^\s+ErrorLogFormat connection "\[%\{uc\}t\] \[C:%\{c\}L\] local\\ %a remote\\ %A"$})
            }
          end
        end

        describe 'validation' do
          let(:params) do
            {
              'docroot' => '/rspec/docroot'
            }
          end

          [
            'ensure', 'ip_based', 'access_log', 'error_log',
            'ssl', 'default_vhost', 'ssl_proxyengine', 'rewrites', 'suexec_user_group',
            'wsgi_script_alias', 'wsgi_daemon_process_options',
            'wsgi_import_script_alias', 'itk', 'logroot_ensure', 'log_level',
            'fallbackresource'
          ].each do |parameter|
            context "bad #{parameter}" do
              let(:params) { super().merge(parameter => 'bogus') }

              it { is_expected.to raise_error(Puppet::Error) }
            end
          end

          context 'bad rewrites 2' do
            let(:params) { super().merge('rewrites' => ['bogus']) }

            it { is_expected.to raise_error(Puppet::Error) }
          end

          context 'empty rewrites' do
            let(:params) do
              super().merge(
                'rewrite_inherit' => false,
                'rewrites' => [],
              )
            end

            it {
              expect(subject).to compile
              expect(subject).not_to contain_concat__fragment('rspec.example.com-rewrite')
            }
          end

          context 'empty rewrites_with_rewrite_inherit' do
            let(:params) do
              super().merge(
                'rewrite_inherit' => true,
                'rewrites' => [],
              )
            end

            it {
              expect(subject).not_to contain_concat__fragment('rspec.example.com-rewrite')
                .with_content(%r{^\s+RewriteOptions Inherit$})
                .with_content(%r{^\s+RewriteEngine On$})
                .with_content(%r{^\s+RewriteRule \^index\.html\$ welcome.html$})
            }
          end

          context 'empty rewrites_without_rewrite_inherit' do
            let(:params) do
              super().merge(
                'rewrite_inherit' => false,
                'rewrites' => [],
              )
            end

            it {
              expect(subject).not_to contain_concat__fragment('rspec.example.com-rewrite')
                .with_content(%r{^\s+RewriteEngine On$})
                .with_content(%r{^\s+RewriteRule \^index\.html\$ welcome.html$})
                .without(content: %r{^\s+RewriteOptions Inherit$})
            }
          end

          context 'bad error_log_format flag' do
            let :params do
              super().merge(
                'error_log_format' => [
                  { 'some format' => 'bogus' },
                ],
              )
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end

          context 'access_log_file and access_log_pipe' do
            let :params do
              super().merge(
                'access_log_file' => 'bogus',
                'access_log_pipe' => 'bogus',
              )
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end

          context 'error_log_file and error_log_pipe' do
            let :params do
              super().merge(
                'error_log_file' => 'bogus',
                'error_log_pipe' => 'bogus',
              )
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end

          context 'bad custom_fragment' do
            let(:params) { super().merge('custom_fragment' => true) }

            it { is_expected.to raise_error(Puppet::Error) }
          end

          context 'bad access_logs' do
            let(:params) { super().merge('access_logs' => '/var/log/somewhere') }

            it { is_expected.to raise_error(Puppet::Error) }
          end

          context 'default of require all granted' do
            let :params do
              {
                'docroot' => '/var/www/foo',
                'directories' => [
                  {
                    'path' => '/var/www/foo/files',
                    'provider' => 'files'
                  },
                ]

              }
            end

            it { is_expected.to compile }
            it { is_expected.to contain_concat('25-rspec.example.com.conf') }

            if os_facts[:os]['family'] == 'RedHat' || os_facts[:os]['name'] == 'SLES'
              it {
                expect(subject).to contain_concat__fragment('rspec.example.com-directories').with(
                  content: %r{^\s+Require all granted$},
                )
              }
            else
              it { is_expected.to contain_concat__fragment('rspec.example.com-directories') }
            end
          end

          context 'require unmanaged' do
            let :params do
              {
                'docroot' => '/var/www/foo',
                'directories' => [
                  {
                    'path' => '/var/www/foo',
                    'require' => 'unmanaged'
                  },
                ]

              }
            end

            it { is_expected.to compile }
            it { is_expected.to contain_concat('25-rspec.example.com.conf') }

            it {
              expect(subject).not_to contain_concat__fragment('rspec.example.com-directories').with(
                content: %r{^\s+Require all granted$},
              )
            }
          end

          describe 'redirectmatch_*' do
            let(:params) { super().merge(port: 84) }

            context 'dest and regexp' do
              let(:params) { super().merge(redirectmatch_dest: 'http://other.example.com$1.jpg', redirectmatch_regexp: '(.*).gif$') }

              it { is_expected.to contain_concat__fragment('rspec.example.com-redirect') }
              it { is_expected.to contain_class('apache::mod::alias') }
            end

            context 'none' do
              it { is_expected.not_to contain_concat__fragment('rspec.example.com-redirect') }
              it { is_expected.not_to contain_class('apache::mod::alias') }
            end
          end
        end

        context 'oidc_settings RedirectURL' do
          describe 'with VALID relative URI' do
            let :params do
              default_params.merge(
                'auth_oidc' => true,
                'oidc_settings' => { 'ProviderMetadataURL' => 'https://login.example.com/.well-known/openid-configuration',
                                     'ClientID' => 'test',
                                     'RedirectURI' => '/some/valid/relative/uri',
                                     'ProviderTokenEndpointAuth' => 'client_secret_basic',
                                     'RemoteUserClaim' => 'sub',
                                     'ClientSecret' => 'aae053a9-4abf-4824-8956-e94b2af335c8',
                                     'CryptoPassphrase' => '4ad1bb46-9979-450e-ae58-c696967df3cd' },
              )
            end

            it { is_expected.to compile }

            it {
              expect(subject).to contain_concat__fragment('rspec.example.com-auth_oidc').with(
                content: %r{^\s+OIDCRedirectURI\s/some/valid/relative/uri$},
              )
            }
          end

          describe 'with INVALID relative URI' do
            let :params do
              default_params.merge(
                'auth_oidc' => true,
                'oidc_settings' => { 'ProviderMetadataURL' => 'https://login.example.com/.well-known/openid-configuration',
                                     'ClientID' => 'test',
                                     'RedirectURI' => 'invalid_uri',
                                     'ProviderTokenEndpointAuth' => 'client_secret_basic',
                                     'RemoteUserClaim' => 'sub',
                                     'ClientSecret' => 'aae053a9-4abf-4824-8956-e94b2af335c8',
                                     'CryptoPassphrase' => '4ad1bb46-9979-450e-ae58-c696967df3cd' },
              )
            end

            it { is_expected.not_to compile }
          end
        end

        context 'mdomain' do
          let :params do
            default_params.merge(
              'mdomain' => true,
            )
          end

          it {
            expect(subject).to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{^MDomain rspec.example.com$},
            )
          }
        end

        context 'userdir' do
          let :params do
            default_params.merge(
              'userdir' => [
                'disabled',
                'enabled bob',
              ],
            )

            it {
              expect(subject).to contain_concat__fragment('rspec.example.com-apache-userdir')
                .with(content: %r{^\s+UserDir disabled$})
                .with(content: %r{^\s+UUserDir enabled bob$})
            }
          end
        end
      end
    end
  end
end
