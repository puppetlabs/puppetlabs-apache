require 'spec_helper'

describe 'apache::vhost', type: :define do
  describe 'os-independent items' do
    on_supported_os.each do |os, facts|
      # this setup uses fastcgi wich isn't available on RHEL 7 / RHEL 8 / Ubuntu 18.04
      next if facts[:os]['release']['major'] == '18.04'
      next if (facts[:os]['release']['major'] == '7' || facts[:os]['release']['major'] == '8') && facts[:os]['family']['RedHat']
      # next if facts[:os]['name'] == 'SLES'

      apache_name = case facts[:os]['family']
                    when 'RedHat'
                      'httpd'
                    when 'Debian'
                      'apache2'
                    else
                      'apache2'
                    end

      let :pre_condition do
        "class {'apache': default_vhost => false, default_mods => false, vhost_enable_dir => '/etc/#{apache_name}/sites-enabled'}"
      end

      let :title do
        'rspec.example.com'
      end

      let :default_params do
        {
          docroot: '/rspec/docroot',
          port: '84',
        }
      end

      context "on #{os} " do
        let :facts do
          facts
        end

        describe 'basic assumptions' do
          let(:params) { default_params }

          it { is_expected.to contain_class('apache') }
          it { is_expected.to contain_class('apache::params') }
          it { is_expected.to contain_apache__listen(params[:port]) }
          # namebased virualhost is only created on apache 2.2 and older
          if (facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'].to_i < 8) ||
             (facts[:os]['name'] == 'Amazon') ||
             (facts[:os]['name'] == 'SLES' && facts[:os]['release']['major'].to_i < 12)
            it { is_expected.to contain_apache__namevirtualhost("*:#{params[:port]}") }
          end
        end
        context 'set everything!' do
          let :params do
            {
              'docroot'                     => '/var/www/foo',
              'manage_docroot'              => false,
              'virtual_docroot'             => true,
              'port'                        => '8080',
              'ip'                          => '127.0.0.1',
              'ip_based'                    => true,
              'add_listen'                  => false,
              'docroot_owner'               => 'user',
              'docroot_group'               => 'wheel',
              'docroot_mode'                => '0664',
              'serveradmin'                 => 'foo@localhost',
              'ssl'                         => true,
              'ssl_cert'                    => '/ssl/cert',
              'ssl_key'                     => '/ssl/key',
              'ssl_chain'                   => '/ssl/chain',
              'ssl_crl_path'                => '/ssl/crl',
              'ssl_crl'                     => 'foo.crl',
              'ssl_certs_dir'               => '/ssl/certs',
              'ssl_protocol'                => 'SSLv2',
              'ssl_cipher'                  => 'HIGH',
              'ssl_honorcipherorder'        => 'Off',
              'ssl_verify_client'           => 'optional',
              'ssl_verify_depth'            => '3',
              'ssl_options'                 => '+ExportCertData',
              'ssl_openssl_conf_cmd'        => 'DHParameters "foo.pem"',
              'ssl_proxy_verify'            => 'require',
              'ssl_proxy_check_peer_cn'     => 'on',
              'ssl_proxy_check_peer_name'   => 'on',
              'ssl_proxy_check_peer_expire' => 'on',
              'ssl_proxyengine'             => true,
              'ssl_proxy_cipher_suite'      => 'HIGH',
              'ssl_proxy_protocol'          => 'TLSv1.2',
              'priority'                    => '30',
              'default_vhost'               => true,
              'servername'                  => 'example.com',
              'serveraliases'               => ['test-example.com'],
              'options'                     => ['MultiView'],
              'override'                    => ['All'],
              'directoryindex'              => 'index.html',
              'vhost_name'                  => 'test',
              'logroot'                     => '/var/www/logs',
              'logroot_ensure'              => 'directory',
              'logroot_mode'                => '0600',
              'logroot_owner'               => 'root',
              'logroot_group'               => 'root',
              'log_level'                   => 'crit',
              'access_log'                  => false,
              'access_log_file'             => 'httpd_access_log',
              'access_log_syslog'           => true,
              'access_log_format'           => '%h %l %u %t \"%r\" %>s %b',
              'access_log_env_var'          => '',
              'aliases'                     => '/image',
              'directories'                 => [
                {
                  'path'     => '/var/www/files',
                  'provider' => 'files',
                  'require'  => ['valid-user', 'all denied'],
                },
                {
                  'path'     => '/var/www/files',
                  'provider' => 'files',
                  'additional_includes' => ['/custom/path/includes', '/custom/path/another_includes'],
                },
                {
                  'path'     => '/var/www/files',
                  'provider' => 'files',
                  'require'  => 'all granted',
                },
                {
                  'path'     => '/var/www/files',
                  'provider' => 'files',
                  'require'  =>
                  {
                    'enforce'  => 'all',
                    'requires' => ['all-valid1', 'all-valid2'],
                  },
                },
                {
                  'path'     => '/var/www/files',
                  'provider' => 'files',
                  'require'  =>
                  {
                    'enforce'  => 'none',
                    'requires' => ['none-valid1', 'none-valid2'],
                  },
                },
                {
                  'path'     => '/var/www/files',
                  'provider' => 'files',
                  'require'  =>
                  {
                    'enforce'  => 'any',
                    'requires' => ['any-valid1', 'any-valid2'],
                  },
                },
                {
                  'path'     => '*',
                  'provider' => 'proxy',
                },
                { 'path'              => '/var/www/files/indexed_directory',
                  'directoryindex'    => 'disabled',
                  'options'           => ['Indexes', 'FollowSymLinks', 'MultiViews'],
                  'index_options'     => ['FancyIndexing'],
                  'index_style_sheet' => '/styles/style.css' },
                { 'path'              => '/var/www/files/output_filtered',
                  'set_output_filter' => 'output_filter' },
                { 'path'     => '/var/www/files',
                  'provider' => 'location',
                  'limit'    => [
                    { 'methods' => 'GET HEAD',
                      'require' => ['valid-user'] },
                  ] },
                { 'path'         => '/var/www/files',
                  'provider'     => 'location',
                  'limit_except' => [
                    { 'methods' => 'GET HEAD',
                      'require' => ['valid-user'] },
                  ] },
                { 'path'               => '/var/www/dav',
                  'dav'                => 'filesystem',
                  'dav_depth_infinity' => true,
                  'dav_min_timeout'    => '600' },
                {
                  'path'             => '/var/www/http2',
                  'h2_copy_files'    => true,
                  'h2_push_resource' => [
                    '/foo.css',
                    '/foo.js',
                  ],
                },
                {
                  'path'                => '/',
                  'provider'            => 'location',
                  'auth_ldap_referrals' => 'off',
                },
                {
                  'path'       => '/proxy',
                  'provider'   => 'location',
                  'proxy_pass' => [
                    {
                      'url'             => 'http://backend-b/',
                      'keywords'        => ['noquery', 'interpolate'],
                      'params' => {
                        'retry'   => '0',
                        'timeout' => '5',
                      },
                    },
                  ],
                },
                {
                  'path'                                                => '/var/www/node-app/public',
                  'passenger_enabled'                                   => true,
                  'passenger_base_uri'                                  => '/app',
                  'passenger_ruby'                                      => '/path/to/ruby',
                  'passenger_python'                                    => '/path/to/python',
                  'passenger_nodejs'                                    => '/path/to/nodejs',
                  'passenger_meteor_app_settings'                       => '/path/to/file.json',
                  'passenger_app_env'                                   => 'demo',
                  'passenger_app_root'                                  => '/var/www/node-app',
                  'passenger_app_group_name'                            => 'foo_bar',
                  'passenger_app_type'                                  => 'node',
                  'passenger_startup_file'                              => 'start.js',
                  'passenger_restart_dir'                               => 'temp',
                  'passenger_load_shell_envvars'                        => false,
                  'passenger_rolling_restarts'                          => false,
                  'passenger_resist_deployment_errors'                  => false,
                  'passenger_user'                                      => 'nodeuser',
                  'passenger_group'                                     => 'nodegroup',
                  'passenger_friendly_error_pages'                      => true,
                  'passenger_min_instances'                             => 7,
                  'passenger_max_instances'                             => 9,
                  'passenger_force_max_concurrent_requests_per_process' => 12,
                  'passenger_start_timeout'                             => 10,
                  'passenger_concurrency_model'                         => 'thread',
                  'passenger_thread_count'                              => 20,
                  'passenger_max_requests'                              => 2000,
                  'passenger_max_request_time'                          => 1,
                  'passenger_memory_limit'                              => 32,
                  'passenger_high_performance'                          => false,
                  'passenger_buffer_upload'                             => false,
                  'passenger_buffer_response'                           => false,
                  'passenger_error_override'                            => false,
                  'passenger_max_request_queue_size'                    => 120,
                  'passenger_max_request_queue_time'                    => 5,
                  'passenger_sticky_sessions'                           => true,
                  'passenger_sticky_sessions_cookie_name'               => '_delicious_cookie',
                  'passenger_allow_encoded_slashes'                     => false,
                  'passenger_debugger'                                  => false,
                },
              ],
              'error_log'                   => false,
              'error_log_file'              => 'httpd_error_log',
              'error_log_syslog'            => true,
              'error_log_format'            => [ '[%t] [%l] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i' ],
              'error_documents'             => 'true',
              'fallbackresource'            => '/index.php',
              'scriptalias'                 => '/usr/lib/cgi-bin',
              'scriptaliases'               => [
                {
                  'alias' => '/myscript',
                  'path'  => '/usr/share/myscript',
                },
                {
                  'aliasmatch' => '^/foo(.*)',
                  'path'       => '/usr/share/fooscripts$1',
                },
              ],
              'proxy_dest'                  => '/',
              'proxy_pass'                  => [
                {
                  'path'            => '/a',
                  'url'             => 'http://backend-a/',
                  'keywords'        => ['noquery', 'interpolate'],
                  'no_proxy_uris'       => ['/a/foo', '/a/bar'],
                  'no_proxy_uris_match' => ['/a/foomatch'],
                  'reverse_cookies' => [
                    {
                      'path' => '/a',
                      'url' => 'http://backend-a/',
                    },
                    {
                      'domain' => 'foo',
                      'url'    => 'http://foo',
                    },
                  ],
                  'params' => {
                    'retry'   => '0',
                    'timeout' => '5',
                  },
                  'setenv'   => ['proxy-nokeepalive 1', 'force-proxy-request-1.0 1'],
                },
              ],
              'proxy_pass_match' => [
                {
                  'path'     => '/a',
                  'url'      => 'http://backend-a/',
                  'keywords' => ['noquery', 'interpolate'],
                  'no_proxy_uris'       => ['/a/foo', '/a/bar'],
                  'no_proxy_uris_match' => ['/a/foomatch'],
                  'params' => {
                    'retry'   => '0',
                    'timeout' => '5',
                  },
                  'setenv' => ['proxy-nokeepalive 1', 'force-proxy-request-1.0 1'],
                },
              ],
              'proxy_requests'              => false,
              'suphp_addhandler'            => 'foo',
              'suphp_engine'                => 'on',
              'suphp_configpath'            => '/var/www/html',
              'php_admin_flags'             => ['foo', 'bar'],
              'php_admin_values'            => ['true', 'false'],
              'no_proxy_uris'               => '/foo',
              'no_proxy_uris_match'         => '/foomatch',
              'proxy_preserve_host'         => true,
              'proxy_add_headers'           => true,
              'proxy_error_override'        => true,
              'redirect_source'             => '/bar',
              'redirect_dest'               => '/',
              'redirect_status'             => 'temp',
              'redirectmatch_status'        => ['404'],
              'redirectmatch_regexp'        => ['\.git$'],
              'redirectmatch_dest'          => ['http://www.example.com'],
              'headers'                     => 'Set X-Robots-Tag "noindex, noarchive, nosnippet"',
              'request_headers'             => ['append MirrorID "mirror 12"'],
              'rewrites'                    => [
                {
                  'rewrite_rule' => ['^index\.html$ welcome.html'],
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
              'rewrite_base'                => '/',
              'rewrite_rule'                => '^index\.html$ welcome.html',
              'rewrite_cond'                => '%{HTTP_USER_AGENT} ^MSIE',
              'rewrite_inherit'             => true,
              'setenv'                      => ['FOO=/bin/true'],
              'setenvif'                    => 'Request_URI "\.gif$" object_is_image=gif',
              'setenvifnocase'              => 'REMOTE_ADDR ^127.0.0.1 localhost=true',
              'block'                       => 'scm',
              'wsgi_application_group'      => '%{GLOBAL}',
              'wsgi_daemon_process'         => { 'foo' => { 'python-home' => '/usr' }, 'bar' => {} },
              'wsgi_daemon_process_options' => {
                'processes'    => '2',
                'threads'      => '15',
                'display-name' => '%{GROUP}',
              },
              'wsgi_import_script'          => '/var/www/demo.wsgi',
              'wsgi_import_script_options'  => {
                'process-group'     => 'wsgi',
                'application-group' => '%{GLOBAL}',
              },
              'wsgi_process_group'          => 'wsgi',
              'wsgi_script_aliases'         => {
                '/' => '/var/www/demo.wsgi',
              },
              'wsgi_script_aliases_match' => {
                '^/test/(^[/*)' => '/var/www/demo.wsgi',
              },
              'wsgi_pass_authorization'     => 'On',
              'custom_fragment'             => '#custom string',
              'itk'                         => {
                'user'  => 'someuser',
                'group' => 'somegroup',
              },
              'wsgi_chunked_request'        => 'On',
              'action'                      => 'foo',
              'fastcgi_server'              => 'localhost',
              'fastcgi_socket'              => '/tmp/fastcgi.socket',
              'fastcgi_dir'                 => '/tmp',
              'fastcgi_idle_timeout'        => '120',
              'additional_includes'         => '/custom/path/includes',
              'apache_version'              => '2.4',
              'use_optional_includes'       => true,
              'suexec_user_group'           => 'root root',
              'allow_encoded_slashes'       => 'nodecode',
              'use_canonical_name'          => 'dns',

              'h2_copy_files'               => false,
              'h2_direct'                   => true,
              'h2_early_hints'              => false,
              'h2_max_session_streams'      => 100,
              'h2_modern_tls_only'          => true,
              'h2_push'                     => true,
              'h2_push_diary_size'          => 256,
              'h2_push_priority'            => [
                'application/json 32',
              ],
              'h2_push_resource' => [
                '/css/main.css',
                '/js/main.js',
              ],
              'h2_serialize_headers'        => false,
              'h2_stream_max_mem_size'      => 65_536,
              'h2_tls_cool_down_secs'       => 1,
              'h2_tls_warm_up_size'         => 1_048_576,
              'h2_upgrade'                  => true,
              'h2_window_size'              => 65_535,

              'passenger_enabled'                     => false,
              'passenger_base_uri'                    => '/app',
              'passenger_ruby'                        => '/usr/bin/ruby1.9.1',
              'passenger_python'                      => '/usr/local/bin/python',
              'passenger_nodejs'                      => '/usr/bin/node',
              'passenger_meteor_app_settings'         => '/path/to/some/file.json',
              'passenger_app_env'                     => 'test',
              'passenger_app_root'                    => '/usr/share/myapp',
              'passenger_app_group_name'              => 'app_customer',
              'passenger_app_type'                    => 'rack',
              'passenger_startup_file'                => 'bin/www',
              'passenger_restart_dir'                 => 'tmp',
              'passenger_spawn_method'                => 'direct',
              'passenger_load_shell_envvars'          => false,
              'passenger_rolling_restarts'            => false,
              'passenger_resist_deployment_errors'    => true,
              'passenger_user'                        => 'sandbox',
              'passenger_group'                       => 'sandbox',
              'passenger_friendly_error_pages'        => false,
              'passenger_min_instances'               => 1,
              'passenger_max_instances'               => 30,
              'passenger_max_preloader_idle_time'     => 600,
              'passenger_force_max_concurrent_requests_per_process' => 10,
              'passenger_start_timeout'               => 600,
              'passenger_concurrency_model'           => 'thread',
              'passenger_thread_count'                => 5,
              'passenger_max_requests'                => 1000,
              'passenger_max_request_time'            => 2,
              'passenger_memory_limit'                => 64,
              'passenger_stat_throttle_rate'          => 5,
              'passenger_pre_start'                   => 'http://localhost/myapp',
              'passenger_high_performance'            => true,
              'passenger_buffer_upload'               => false,
              'passenger_buffer_response'             => false,
              'passenger_error_override'              => true,
              'passenger_max_request_queue_size'      => 10,
              'passenger_max_request_queue_time'      => 2,
              'passenger_sticky_sessions'             => true,
              'passenger_sticky_sessions_cookie_name' => '_nom_nom_nom',
              'passenger_allow_encoded_slashes'       => true,
              'passenger_debugger'                    => true,
              'passenger_lve_min_uid'                 => 500,
              'add_default_charset'         => 'UTF-8',
              'jk_mounts'                   => [
                { 'mount'   => '/*',     'worker' => 'tcnode1' },
                { 'unmount' => '/*.jpg', 'worker' => 'tcnode1' },
              ],
              'auth_kerb'                   => true,
              'krb_method_negotiate'        => 'off',
              'krb_method_k5passwd'         => 'off',
              'krb_authoritative'           => 'off',
              'krb_auth_realms'             => ['EXAMPLE.ORG', 'EXAMPLE.NET'],
              'krb_5keytab'                 => '/tmp/keytab5',
              'krb_local_user_mapping'      => 'off',
              'http_protocol_options' => 'Strict LenientMethods Allow0.9',
              'keepalive'                   => 'on',
              'keepalive_timeout'           => '100',
              'max_keepalive_requests'      => '1000',
              'protocols'                   => ['h2', 'http/1.1'],
              'protocols_honor_order'       => true,
            }
          end

          it { is_expected.to compile }
          it { is_expected.not_to contain_file('/var/www/foo') }
          it { is_expected.to contain_class('apache::mod::ssl') }
          it {
            is_expected.to contain_file('ssl.conf').with(
              content: %r{^\s+SSLHonorCipherOrder On$},
            )
          }
          it {
            is_expected.to contain_file('ssl.conf').with(
              content: %r{^\s+SSLPassPhraseDialog builtin$},
            )
          }
          it {
            is_expected.to contain_file('ssl.conf').with(
              content: %r{^\s+SSLSessionCacheTimeout 300$},
            )
          }
          it { is_expected.to contain_class('apache::mod::mime') }
          it { is_expected.to contain_class('apache::mod::vhost_alias') }
          it { is_expected.to contain_class('apache::mod::wsgi') }
          it { is_expected.to contain_class('apache::mod::suexec') }
          it { is_expected.to contain_class('apache::mod::passenger') }
          it {
            is_expected.to contain_file('/var/www/logs').with('ensure' => 'directory',
                                                              'mode' => '0600')
          }
          it { is_expected.to contain_class('apache::mod::rewrite') }
          it { is_expected.to contain_class('apache::mod::alias') }
          it { is_expected.to contain_class('apache::mod::proxy') }
          it { is_expected.to contain_class('apache::mod::proxy_http') }
          it { is_expected.to contain_class('apache::mod::fastcgi') }
          it { is_expected.to contain_class('apache::mod::headers') }
          it { is_expected.to contain_class('apache::mod::filter') }
          it { is_expected.to contain_class('apache::mod::env') }
          it { is_expected.to contain_class('apache::mod::setenvif') }
          it {
            is_expected.to contain_concat('30-rspec.example.com.conf').with('owner' => 'root',
                                                                            'mode'    => '0644',
                                                                            'require' => 'Package[httpd]',
                                                                            'notify'  => 'Class[Apache::Service]')
          }
          if facts[:os]['release']['major'].to_i >= 18 && facts[:os]['name'] == 'Ubuntu'
            it {
              is_expected.to contain_file('30-rspec.example.com.conf symlink').with('ensure' => 'link',
                                                                                    'path' => "/etc/#{apache_name}/sites-enabled/30-rspec.example.com.conf")
            }
          end
          it { is_expected.to contain_concat__fragment('rspec.example.com-apache-header') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-docroot') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-aliases') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-itk') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-fallbackresource') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-directories') }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+<Proxy "\*">$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Include\s'\/custom\/path\/includes'$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Include\s'\/custom\/path\/another_includes'$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+H2CopyFiles\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+H2PushResource\s/foo.css$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+H2PushResource\s/foo.js$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Require valid-user$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Require all denied$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Require all granted$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+<RequireAll>$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+<\/RequireAll>$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Require all-valid1$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Require all-valid2$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+<RequireNone>$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+<\/RequireNone>$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Require none-valid1$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Require none-valid2$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+<RequireAny>$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+<\/RequireAny>$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Require any-valid1$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Require any-valid2$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+LDAPReferrals off$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+ProxyPass http://backend-b/ retry=0 timeout=5 noquery interpolate$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Options\sIndexes\sFollowSymLinks\sMultiViews$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+IndexOptions\sFancyIndexing$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+IndexStyleSheet\s'\/styles\/style\.css'$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+DirectoryIndex\sdisabled$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+SetOutputFilter\soutput_filter$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+<Limit GET HEAD>$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{\s+<Limit GET HEAD>\s*Require valid-user\s*<\/Limit>}m,
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+<LimitExcept GET HEAD>$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{\s+<LimitExcept GET HEAD>\s*Require valid-user\s*<\/LimitExcept>}m,
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+Dav\sfilesystem$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+DavDepthInfinity\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+DavMinTimeout\s600$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerEnabled\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerBaseURI\s/app$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerRuby\s/path/to/ruby$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerPython\s/path/to/python$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerNodejs\s/path/to/nodejs$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerMeteorAppSettings\s/path/to/file\.json$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerAppEnv\sdemo$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerAppRoot\s/var/www/node-app$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerAppGroupName\sfoo_bar$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerAppType\snode$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerStartupFile\sstart\.js$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerRestartDir\stemp$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerLoadShellEnvvars\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerRollingRestarts\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerResistDeploymentErrors\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerUser\snodeuser$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerGroup\snodegroup$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerFriendlyErrorPages\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerMinInstances\s7$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerMaxInstances\s9$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerForceMaxConcurrentRequestsPerProcess\s12$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerStartTimeout\s10$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerConcurrencyModel\sthread$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerThreadCount\s20$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerMaxRequests\s2000$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerMaxRequestTime\s1$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerMemoryLimit\s32$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerHighPerformance\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerBufferUpload\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerBufferResponse\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerErrorOverride\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerMaxRequestQueueSize\s120$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerMaxRequestQueueTime\s5$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerStickySessions\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerStickySessionsCookieName\s_delicious_cookie$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerAllowEncodedSlashes\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
              content: %r{^\s+PassengerDebugger\sOff$},
            )
          }
          it { is_expected.to contain_concat__fragment('rspec.example.com-additional_includes') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-logging') }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-logging')
              .with_content(%r{^\s+ErrorLogFormat "\[%t\] \[%l\] %7F: %E: \[client\\ %a\] %M% ,\\ referer\\ %\{Referer\}i"$})
          }
          it { is_expected.to contain_concat__fragment('rspec.example.com-serversignature') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-access_log') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-action') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-block') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-error_document') }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(
              %r{retry=0},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(
              %r{timeout=5},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(
              %r{SetEnv force-proxy-request-1.0 1},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(
              %r{SetEnv proxy-nokeepalive 1},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(
              %r{noquery interpolate},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(
              %r{ProxyPreserveHost On},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(
              %r{ProxyAddHeaders On},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(
              %r{ProxyPassReverseCookiePath\s+\/a\s+http:\/\/},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(
              %r{ProxyPassReverseCookieDomain\s+foo\s+http:\/\/foo},
            )
          }
          it { is_expected.to contain_concat__fragment('rspec.example.com-redirect') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-rewrite') }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-rewrite').with(
              content: %r{^\s+RewriteOptions Inherit$},
            )
          }
          it { is_expected.to contain_concat__fragment('rspec.example.com-scriptalias') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-serveralias') }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-setenv').with_content(
              %r{SetEnv FOO=/bin/true},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-setenv').with_content(
              %r{SetEnvIf Request_URI "\\.gif\$" object_is_image=gif},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-setenv').with_content(
              %r{SetEnvIfNoCase REMOTE_ADDR \^127.0.0.1 localhost=true},
            )
          }
          it { is_expected.to contain_concat__fragment('rspec.example.com-ssl') }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-ssl').with(
              content: %r{^\s+SSLOpenSSLConfCmd\s+DHParameters "foo.pem"$},
            )
          }
          it { is_expected.to contain_concat__fragment('rspec.example.com-sslproxy') }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-sslproxy').with(
              content: %r{^\s+SSLProxyEngine On$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-sslproxy').with(
              content: %r{^\s+SSLProxyCheckPeerCN\s+on$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-sslproxy').with(
              content: %r{^\s+SSLProxyCheckPeerName\s+on$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-sslproxy').with(
              content: %r{^\s+SSLProxyCheckPeerExpire\s+on$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-sslproxy').with(
              content: %r{^\s+SSLProxyCipherSuite\s+HIGH$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-sslproxy').with(
              content: %r{^\s+SSLProxyProtocol\s+TLSv1.2$},
            )
          }
          it { is_expected.to contain_concat__fragment('rspec.example.com-suphp') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-php_admin') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-header') }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-filters').with(
              content: %r{^\s+FilterDeclare COMPRESS$},
            )
          }
          it { is_expected.to contain_concat__fragment('rspec.example.com-requestheader') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-wsgi') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-custom_fragment') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-fastcgi') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-suexec') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-allow_encoded_slashes') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-passenger') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-charsets') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-security') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-file_footer') }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-jk_mounts').with(
              content: %r{^\s+JkMount\s+\/\*\s+tcnode1$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-jk_mounts').with(
              content: %r{^\s+JkUnMount\s+\/\*\.jpg\s+tcnode1$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb').with(
              content: %r{^\s+KrbMethodNegotiate\soff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb').with(
              content: %r{^\s+KrbAuthoritative\soff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb').with(
              content: %r{^\s+KrbAuthRealms\sEXAMPLE.ORG\sEXAMPLE.NET$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb').with(
              content: %r{^\s+Krb5Keytab\s\/tmp\/keytab5$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb').with(
              content: %r{^\s+KrbLocalUserMapping\soff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb').with(
              content: %r{^\s+KrbServiceName\sHTTP$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb').with(
              content: %r{^\s+KrbSaveCredentials\soff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb').with(
              content: %r{^\s+KrbVerifyKDC\son$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http_protocol_options').with(
              content: %r{^\s*HttpProtocolOptions\s+Strict\s+LenientMethods\s+Allow0\.9$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-keepalive_options').with(
              content: %r{^\s+KeepAlive\son$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-keepalive_options').with(
              content: %r{^\s+KeepAliveTimeout\s100$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-keepalive_options').with(
              content: %r{^\s+MaxKeepAliveRequests\s1000$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{^\s+Protocols\sh2 http/1.1$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{^\s+ProtocolsHonorOrder\sOn$},
            )
          }

          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2CopyFiles\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2Direct\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2EarlyHints\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2MaxSessionStreams\s100$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2ModernTLSOnly\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2Push\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2PushDiarySize\s256$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2PushPriority\sapplication/json 32$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2PushResource\s/css/main.css$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2PushResource\s/js/main.js$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2SerializeHeaders\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2StreamMaxMemSize\s65536$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2TLSCoolDownSecs\s1$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2TLSWarmUpSize\s1048576$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2Upgrade\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-http2').with(
              content: %r{^\s+H2WindowSize\s65535$},
            )
          }

          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerEnabled\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerBaseURI\s/app$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerRuby\s/usr/bin/ruby1\.9\.1$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerPython\s/usr/local/bin/python$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerNodejs\s/usr/bin/node$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerMeteorAppSettings\s/path/to/some/file.json$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerAppEnv\stest$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerAppRoot\s/usr/share/myapp$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerAppGroupName\sapp_customer$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerAppType\srack$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerStartupFile\sbin/www$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerRestartDir\stmp$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerSpawnMethod\sdirect$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerLoadShellEnvvars\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerRollingRestarts\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerResistDeploymentErrors\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerUser\ssandbox$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerGroup\ssandbox$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerFriendlyErrorPages\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerMinInstances\s1$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerMaxInstances\s30$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerMaxPreloaderIdleTime\s600$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerForceMaxConcurrentRequestsPerProcess\s10$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerStartTimeout\s600$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerConcurrencyModel\sthread$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerThreadCount\s5$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerMaxRequests\s1000$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerMaxRequestTime\s2$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerMemoryLimit\s64$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerStatThrottleRate\s5$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-file_footer').with(
              content: %r{^PassengerPreStart\shttp://localhost/myapp$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerHighPerformance\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerBufferUpload\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerBufferResponse\sOff$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerErrorOverride\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerMaxRequestQueueSize\s10$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerMaxRequestQueueTime\s2$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerStickySessions\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerStickySessionsCookieName\s_nom_nom_nom$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerAllowEncodedSlashes\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerDebugger\sOn$},
            )
          }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-passenger').with(
              content: %r{^\s+PassengerLveMinUid\s500$},
            )
          }
        end
        context 'vhost with multiple ip addresses' do
          let :params do
            {
              'port'                        => '80',
              'ip'                          => ['127.0.0.1', '::1'],
              'ip_based'                    => true,
              'servername'                  => 'example.com',
              'docroot'                     => '/var/www/html',
              'add_listen'                  => true,
              'ensure'                      => 'present',
            }
          end

          it { is_expected.to compile }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{[.\/m]*<VirtualHost 127.0.0.1:80 \[::1\]:80>[.\/m]*$},
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
              'port'                        => ['80', '8080'],
              'ip'                          => '127.0.0.1',
              'ip_based'                    => true,
              'servername'                  => 'example.com',
              'docroot'                     => '/var/www/html',
              'add_listen'                  => true,
              'ensure'                      => 'present',
            }
          end

          it { is_expected.to compile }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{[.\/m]*<VirtualHost 127.0.0.1:80 127.0.0.1:8080>[.\/m]*$},
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
              'port'                        => ['80', '8080'],
              'ip'                          => ['127.0.0.1', '::1'],
              'ip_based'                    => true,
              'servername'                  => 'example.com',
              'docroot'                     => '/var/www/html',
              'add_listen'                  => true,
              'ensure'                      => 'present',
            }
          end

          it { is_expected.to compile }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{[.\/m]*<VirtualHost 127.0.0.1:80 127.0.0.1:8080 \[::1\]:80 \[::1\]:8080>[.\/m]*$},
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
              'port'                        => '80',
              'ip'                          => '::1',
              'ip_based'                    => true,
              'servername'                  => 'example.com',
              'docroot'                     => '/var/www/html',
              'add_listen'                  => true,
              'ensure'                      => 'present',
            }
          end

          it { is_expected.to compile }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{[.\/m]*<VirtualHost \[::1\]:80>[.\/m]*$},
            )
          }
          it { is_expected.to contain_concat__fragment('Listen [::1]:80') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost [::1]:80') }
        end

        context 'vhost with wildcard ip address' do
          let :params do
            {
              'port'                        => '80',
              'ip'                          => '*',
              'ip_based'                    => true,
              'servername'                  => 'example.com',
              'docroot'                     => '/var/www/html',
              'add_listen'                  => true,
              'ensure'                      => 'present',
            }
          end

          it { is_expected.to compile }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-apache-header').with(
              content: %r{[.\/m]*<VirtualHost \*:80>[.\/m]*$},
            )
          }
          it { is_expected.to contain_concat__fragment('Listen *:80') }
          it { is_expected.not_to contain_concat__fragment('NameVirtualHost *:80') }
        end

        context 'modsec_audit_log' do
          let :params do
            {
              'docroot'          => '/rspec/docroot',
              'modsec_audit_log' => true,
            }
          end

          it { is_expected.to compile }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-security').with(
              content: %r{^\s*SecAuditLog "\/var\/log\/#{apache_name}\/rspec\.example\.com_security\.log"$},
            )
          }
        end
        context 'modsec_audit_log_file' do
          let :params do
            {
              'docroot'               => '/rspec/docroot',
              'modsec_audit_log_file' => 'foo.log',
            }
          end

          it { is_expected.to compile }
          it {
            is_expected.to contain_concat__fragment('rspec.example.com-security').with(
              content: %r{\s*SecAuditLog "\/var\/log\/#{apache_name}\/foo.log"$},
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
                  'path'  => '/rspec/docroot',
                },
              ],
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
                  'path'     => '.*',
                  'url'      => 'http://backend-a/',
                  'params'   => { 'timeout' => 300 },
                },
              ],
            }
          end

          it {
            is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(
              %r{ProxyPassMatch .* http:\/\/backend-a\/ timeout=300},
            ).with_content(%r{## Proxy rules})
          }
        end
        context 'proxy_dest_match' do
          let :params do
            {
              'docroot'          => '/rspec/docroot',
              'proxy_dest_match' => '/',
            }
          end

          it { is_expected.to contain_concat__fragment('rspec.example.com-proxy').with_content(%r{## Proxy rules}) }
        end
        context 'not everything can be set together...' do
          let :params do
            {
              'access_log_pipe' => '/dev/null',
              'error_log_pipe'  => '/dev/null',
              'docroot'         => '/var/www/foo',
              'ensure'          => 'absent',
              'manage_docroot'  => true,
              'logroot'         => '/tmp/logroot',
              'logroot_ensure'  => 'absent',
              'directories'     => [
                {
                  'path'     => '/var/www/files',
                  'provider' => 'files',
                  'allow'    => ['from 127.0.0.1', 'from 127.0.0.2'],
                  'deny'     => ['from 127.0.0.3', 'from 127.0.0.4'],
                  'satisfy'  => 'any',
                },
                {
                  'path'     => '/var/www/foo',
                  'provider' => 'files',
                  'allow'    => 'from 127.0.0.5',
                  'deny'     => 'from all',
                  'order'    => 'deny,allow',
                },
              ],

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
          it { is_expected.to contain_file('/var/www/foo') }
          it {
            is_expected.to contain_file('/tmp/logroot').with('ensure' => 'absent')
          }
          it {
            is_expected.to contain_concat('25-rspec.example.com.conf').with('ensure' => 'absent')
          }
          it { is_expected.to contain_concat__fragment('rspec.example.com-apache-header') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-docroot') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-aliases') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-itk') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-fallbackresource') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-directories') }
          # the following style is only present on Apache 2.2
          # That is used in SLES 11, RHEL6, Amazon Linux
          if (facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'].to_i < 7) ||
             (facts[:os]['name'] == 'Amazon') ||
             (facts[:os]['name'] == 'SLES' && facts[:os]['release']['major'].to_i < 12)
            it {
              is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
                content: %r{^\s+Allow from 127\.0\.0\.1$},
              )
            }
            it {
              is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
                content: %r{^\s+Allow from 127\.0\.0\.2$},
              )
            }
            it {
              is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
                content: %r{^\s+Allow from 127\.0\.0\.5$},
              )
            }
            it {
              is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
                content: %r{^\s+Deny from 127\.0\.0\.3$},
              )
            }
            it {
              is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
                content: %r{^\s+Deny from 127\.0\.0\.4$},
              )
            }
            it {
              is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
                content: %r{^\s+Deny from all$},
              )
            }
            it {
              is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
                content: %r{^\s+Satisfy any$},
              )
            }
            it {
              is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
                content: %r{^\s+Order deny,allow$},
              )
            }
          end
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
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-suphp') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-php_admin') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-header') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-requestheader') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-wsgi') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-custom_fragment') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-fastcgi') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-suexec') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-charsets') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-limits') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-file_footer') }
        end
        context 'wsgi_application_group should set apache::mod::wsgi' do
          let :params do
            {
              'docroot'                    => '/rspec/docroot',
              'wsgi_application_group'     => '%{GLOBAL}',
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end
        context 'wsgi_daemon_process should set apache::mod::wsgi' do
          let :params do
            {
              'docroot'                    => '/rspec/docroot',
              'wsgi_daemon_process' => { 'foo' => { 'python-home' => '/usr' }, 'bar' => {} },
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end
        context 'wsgi_import_script on its own should not set apache::mod::wsgi' do
          let :params do
            {
              'docroot'                    => '/rspec/docroot',
              'wsgi_import_script'         => '/var/www/demo.wsgi',
            }
          end

          it { is_expected.not_to contain_class('apache::mod::wsgi') }
        end
        context 'wsgi_import_script_options on its own should not set apache::mod::wsgi' do
          let :params do
            {
              'docroot' => '/rspec/docroot',
              'wsgi_import_script_options' => {
                'process-group'           => 'wsgi',
                'application-group'       => '%{GLOBAL}',
              },
            }
          end

          it { is_expected.not_to contain_class('apache::mod::wsgi') }
        end
        context 'wsgi_import_script and wsgi_import_script_options should set apache::mod::wsgi' do
          let :params do
            {
              'docroot'                     => '/rspec/docroot',
              'wsgi_import_script'          => '/var/www/demo.wsgi',
              'wsgi_import_script_options'  => {
                'process-group'           => 'wsgi',
                'application-group'       => '%{GLOBAL}',
              },
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end
        context 'wsgi_process_group should set apache::mod::wsgi' do
          let :params do
            {
              'docroot'                    => '/rspec/docroot',
              'wsgi_daemon_process'        => 'wsgi',
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end
        context 'wsgi_script_aliases with non-empty aliases should set apache::mod::wsgi' do
          let :params do
            {
              'docroot'                    => '/rspec/docroot',
              'wsgi_script_aliases'        => {
                '/' => '/var/www/demo.wsgi',
              },
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end
        context 'wsgi_script_aliases with empty aliases should set apache::mod::wsgi' do
          let :params do
            {
              'docroot'                    => '/rspec/docroot',
              'wsgi_script_aliases'        => {},
            }
          end

          it { is_expected.not_to contain_class('apache::mod::wsgi') }
        end
        context 'wsgi_pass_authorization should set apache::mod::wsgi' do
          let :params do
            {
              'docroot'                    => '/rspec/docroot',
              'wsgi_pass_authorization'    => 'On',
            }
          end

          it { is_expected.to contain_class('apache::mod::wsgi') }
        end
        context 'when not setting nor managing the docroot' do
          let :params do
            {
              'docroot'                     => false,
              'manage_docroot'              => false,
            }
          end

          it { is_expected.to compile }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-docroot') }
        end
        context 'ssl_proxyengine without ssl' do
          let :params do
            {
              'docroot'         => '/rspec/docroot',
              'ssl'             => false,
              'ssl_proxyengine' => true,
            }
          end

          it { is_expected.to compile }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-ssl') }
          it { is_expected.to contain_concat__fragment('rspec.example.com-sslproxy') }
        end
        context 'ssl_proxy_protocol without ssl_proxyengine' do
          let :params do
            {
              'docroot'            => '/rspec/docroot',
              'ssl'                => true,
              'ssl_proxyengine'    => false,
              'ssl_proxy_protocol' => 'TLSv1.2',
            }
          end

          it { is_expected.to compile }
          it { is_expected.to contain_concat__fragment('rspec.example.com-ssl') }
          it { is_expected.not_to contain_concat__fragment('rspec.example.com-sslproxy') }
        end
        describe 'access logs' do
          context 'single log file' do
            let(:params) do
              {
                'docroot'         => '/rspec/docroot',
                'access_log_file' => 'my_log_file',
              }
            end

            it {
              is_expected.to contain_concat__fragment('rspec.example.com-access_log').with(
                content: %r{^\s+CustomLog.*my_log_file" combined\s*$},
              )
            }
          end
          context 'single log file with environment' do
            let(:params) do
              {
                'docroot'            => '/rspec/docroot',
                'access_log_file'    => 'my_log_file',
                'access_log_env_var' => 'prod',
              }
            end

            it {
              is_expected.to contain_concat__fragment('rspec.example.com-access_log').with(
                content: %r{^\s+CustomLog.*my_log_file" combined\s+env=prod$},
              )
            }
          end
          context 'multiple log files' do
            let(:params) do
              {
                'docroot'     => '/rspec/docroot',
                'access_logs' => [
                  { 'file' => '/tmp/log1', 'env' => 'dev' },
                  { 'file' => 'log2' },
                  { 'syslog' => 'syslog', 'format' => '%h %l' },
                ],
              }
            end

            it {
              is_expected.to contain_concat__fragment('rspec.example.com-access_log').with(
                content: %r{^\s+CustomLog "\/tmp\/log1"\s+combined\s+env=dev$},
              )
            }
            it {
              is_expected.to contain_concat__fragment('rspec.example.com-access_log').with(
                content: %r{^\s+CustomLog "\/var\/log\/#{apache_name}\/log2"\s+combined\s*$},
              )
            }
            it {
              is_expected.to contain_concat__fragment('rspec.example.com-access_log').with(
                content: %r{^\s+CustomLog "syslog" "%h %l"\s*$},
              )
            }
          end
        end # access logs
        describe 'error logs format' do
          context 'on Apache 2.2' do
            let(:params) do
              {
                'docroot'         => '/rspec/docroot',
                'apache_version'  => '2.2',
                'error_log_format' => [ '[%t] [%l] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i' ],
              }
            end

            it {
              is_expected.to contain_concat__fragment('rspec.example.com-logging')
                .without_content(%r{ErrorLogFormat})
            }
          end

          context 'single log format directive as a string' do
            let(:params) do
              {
                'docroot'          => '/rspec/docroot',
                'apache_version'   => '2.4',
                'error_log_format' => [ '[%t] [%l] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i' ],
              }
            end

            it {
              is_expected.to contain_concat__fragment('rspec.example.com-logging').with(
                content: %r{^\s+ErrorLogFormat "\[%t\] \[%l\] %7F: %E: \[client\\ %a\] %M% ,\\ referer\\ %\{Referer\}i"$},
              )
            }
          end

          context 'multiple log format directives' do
            let(:params) do
              {
                'docroot'          => '/rspec/docroot',
                'apache_version'   => '2.4',
                'error_log_format' => [ 
                  '[%{uc}t] [%-m:%-l] [R:%L] [C:%{C}L] %7F: %E: %M',
                  { '[%{uc}t] [R:%L] Request %k on C:%{c}L pid:%P tid:%T' => 'request' }, 
                  { "[%{uc}t] [R:%L] UA:'%+{User-Agent}i'" => 'request' },
                  { "[%{uc}t] [R:%L] Referer:'%+{Referer}i'" => 'request' },
                  { '[%{uc}t] [C:%{c}L] local\ %a remote\ %A' => 'connection' },
                ],
              }
            end

            it {
              is_expected.to contain_concat__fragment('rspec.example.com-logging').with(
                content: %r{^\s+ErrorLogFormat "\[%\{uc\}t\] \[%-m:%-l\] \[R:%L\] \[C:%\{C\}L\] %7F: %E: %M"$},
              )
            }

            it {
              is_expected.to contain_concat__fragment('rspec.example.com-logging').with(
                content: %r{^\s+ErrorLogFormat request "\[%\{uc\}t\] \[R:%L\] Request %k on C:%\{c\}L pid:%P tid:%T"$},
              )
            }

            it {
              is_expected.to contain_concat__fragment('rspec.example.com-logging').with(
                content: %r{^\s+ErrorLogFormat request "\[%\{uc\}t\] \[R:%L\] UA:'%\+\{User-Agent\}i'"$},
              )
            }

            it {
              is_expected.to contain_concat__fragment('rspec.example.com-logging').with(
                content: %r{^\s+ErrorLogFormat request "\[%\{uc\}t\] \[R:%L\] Referer:'%\+\{Referer\}i'"$},
              )
            }

            it {
              is_expected.to contain_concat__fragment('rspec.example.com-logging').with(
                content: %r{^\s+ErrorLogFormat connection "\[%\{uc\}t\] \[C:%\{c\}L\] local\\ %a remote\\ %A"$},
              )
            }
          end
        end # error logs format
        describe 'validation' do
          context 'bad ensure' do
            let :params do
              {
                'docroot' => '/rspec/docroot',
                'ensure'  => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad suphp_engine' do
            let :params do
              {
                'docroot'      => '/rspec/docroot',
                'suphp_engine' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad ip_based' do
            let :params do
              {
                'docroot'  => '/rspec/docroot',
                'ip_based' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad access_log' do
            let :params do
              {
                'docroot'    => '/rspec/docroot',
                'access_log' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad error_log' do
            let :params do
              {
                'docroot'   => '/rspec/docroot',
                'error_log' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad_ssl' do
            let :params do
              {
                'docroot' => '/rspec/docroot',
                'ssl'     => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad default_vhost' do
            let :params do
              {
                'docroot'       => '/rspec/docroot',
                'default_vhost' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad ssl_proxyengine' do
            let :params do
              {
                'docroot'         => '/rspec/docroot',
                'ssl_proxyengine' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad rewrites' do
            let :params do
              {
                'docroot'  => '/rspec/docroot',
                'rewrites' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad rewrites 2' do
            let :params do
              {
                'docroot'  => '/rspec/docroot',
                'rewrites' => ['bogus'],
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'empty rewrites' do
            let :params do
              {
                'docroot'  => '/rspec/docroot',
                'rewrites' => [],
              }
            end

            it { is_expected.to compile }
          end
          context 'bad suexec_user_group' do
            let :params do
              {
                'docroot'           => '/rspec/docroot',
                'suexec_user_group' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad wsgi_script_alias' do
            let :params do
              {
                'docroot'           => '/rspec/docroot',
                'wsgi_script_alias' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad wsgi_daemon_process_options' do
            let :params do
              {
                'docroot'                     => '/rspec/docroot',
                'wsgi_daemon_process_options' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad wsgi_import_script_alias' do
            let :params do
              {
                'docroot'                  => '/rspec/docroot',
                'wsgi_import_script_alias' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad itk' do
            let :params do
              {
                'docroot' => '/rspec/docroot',
                'itk'     => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad logroot_ensure' do
            let :params do
              {
                'docroot'   => '/rspec/docroot',
                'log_level' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad log_level' do
            let :params do
              {
                'docroot'   => '/rspec/docroot',
                'log_level' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad error_log_format flag' do
            let :params do
              {
                'docroot'   => '/rspec/docroot',
                'error_log_format' => [
                  { 'some format' => 'bogus' },
                ],
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'access_log_file and access_log_pipe' do
            let :params do
              {
                'docroot'         => '/rspec/docroot',
                'access_log_file' => 'bogus',
                'access_log_pipe' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'error_log_file and error_log_pipe' do
            let :params do
              {
                'docroot'        => '/rspec/docroot',
                'error_log_file' => 'bogus',
                'error_log_pipe' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad fallbackresource' do
            let :params do
              {
                'docroot'          => '/rspec/docroot',
                'fallbackresource' => 'bogus',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad custom_fragment' do
            let :params do
              {
                'docroot'         => '/rspec/docroot',
                'custom_fragment' => true,
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'bad access_logs' do
            let :params do
              {
                'docroot'     => '/rspec/docroot',
                'access_logs' => '/var/log/somewhere',
              }
            end

            it { is_expected.to raise_error(Puppet::Error) }
          end
          context 'default of require all granted' do
            let :params do
              {
                'docroot'         => '/var/www/foo',
                'directories'     => [
                  {
                    'path'     => '/var/www/foo/files',
                    'provider' => 'files',
                  },
                ],

              }
            end

            it { is_expected.to compile }
            it { is_expected.to contain_concat('25-rspec.example.com.conf') }
            it { is_expected.to contain_concat__fragment('rspec.example.com-directories') }
            # this works only with apache 2.4 and newer
            if (facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'].to_i > 6) ||
               (facts[:os]['name'] == 'SLES' && facts[:os]['release']['major'].to_i > 11)
              it {
                is_expected.to contain_concat__fragment('rspec.example.com-directories').with(
                  content: %r{^\s+Require all granted$},
                )
              }
            end
          end
          context 'require unmanaged' do
            let :params do
              {
                'docroot'         => '/var/www/foo',
                'directories'     => [
                  {
                    'path'     => '/var/www/foo',
                    'require'  => 'unmanaged',
                  },
                ],

              }
            end

            it { is_expected.to compile }
            it { is_expected.to contain_concat('25-rspec.example.com.conf') }
            it { is_expected.to contain_concat__fragment('rspec.example.com-directories') }
            it {
              is_expected.not_to contain_concat__fragment('rspec.example.com-directories').with(
                content: %r{^\s+Require all granted$},
              )
            }
          end
          describe 'redirectmatch_*' do
            let :dparams do
              {
                docroot: '/rspec/docroot',
                port: '84',
              }
            end

            context 'status' do
              let(:params) { dparams.merge(redirectmatch_status: '404') }

              it { is_expected.to contain_class('apache::mod::alias') }
            end
            context 'dest' do
              let(:params) { dparams.merge(redirectmatch_dest: 'http://other.example.com$1.jpg') }

              it { is_expected.to contain_class('apache::mod::alias') }
            end
            context 'regexp' do
              let(:params) { dparams.merge(redirectmatch_regexp: "(.*)\.gif$") }

              it { is_expected.to contain_class('apache::mod::alias') }
            end
            context 'none' do
              let(:params) { dparams }

              it { is_expected.not_to contain_class('apache::mod::alias') }
            end
          end
        end
      end
    end
  end
end
