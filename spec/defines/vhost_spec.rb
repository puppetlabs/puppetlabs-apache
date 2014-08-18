require 'spec_helper'

describe 'apache::vhost', :type => :define do
  let :pre_condition do
    'class { "apache": default_vhost => false, }'
  end
  let :title do
    'rspec.example.com'
  end
  let :default_params do
    {
      :docroot => '/rspec/docroot',
      :port    => '84',
    }
  end
  describe 'os-dependent items' do
    context "on RedHat based systems" do
      let :default_facts do
        {
          :osfamily               => 'RedHat',
          :operatingsystemrelease => '6',
          :concat_basedir         => '/dne',
          :operatingsystem        => 'RedHat',
          :id                     => 'root',
          :kernel                 => 'Linux',
          :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        }
      end
      let :params do default_params end
      let :facts do default_facts end
      it { is_expected.to contain_class("apache") }
      it { is_expected.to contain_class("apache::params") }
    end
    context "on Debian based systems" do
      let :default_facts do
        {
          :osfamily               => 'Debian',
          :operatingsystemrelease => '6',
          :concat_basedir         => '/dne',
          :lsbdistcodename        => 'squeeze',
          :operatingsystem        => 'Debian',
          :id                     => 'root',
          :kernel                 => 'Linux',
          :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        }
      end
      let :params do default_params end
      let :facts do default_facts end
      it { is_expected.to contain_class("apache") }
      it { is_expected.to contain_class("apache::params") }
      it { is_expected.to contain_file("25-rspec.example.com.conf").with(
        :ensure => 'present',
        :path   => '/etc/apache2/sites-available/25-rspec.example.com.conf'
      ) }
      it { is_expected.to contain_file("25-rspec.example.com.conf symlink").with(
        :ensure => 'link',
        :path   => '/etc/apache2/sites-enabled/25-rspec.example.com.conf',
        :target => '/etc/apache2/sites-available/25-rspec.example.com.conf'
      ) }
    end
    context "on FreeBSD systems" do
      let :default_facts do
        {
          :osfamily               => 'FreeBSD',
          :operatingsystemrelease => '9',
          :concat_basedir         => '/dne',
          :operatingsystem        => 'FreeBSD',
          :id                     => 'root',
          :kernel                 => 'FreeBSD',
          :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        }
      end
      let :params do default_params end
      let :facts do default_facts end
      it { is_expected.to contain_class("apache") }
      it { is_expected.to contain_class("apache::params") }
      it { is_expected.to contain_file("25-rspec.example.com.conf").with(
        :ensure => 'present',
        :path   => '/usr/local/etc/apache22/Vhosts/25-rspec.example.com.conf'
      ) }
    end
  end
  describe 'os-independent items' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :lsbdistcodename        => 'squeeze',
        :operatingsystem        => 'Debian',
        :id                     => 'root',
        :kernel                 => 'Linux',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end
    describe 'basic assumptions' do
      let :params do default_params end
      it { is_expected.to contain_class("apache") }
      it { is_expected.to contain_class("apache::params") }
      it { is_expected.to contain_apache__listen(params[:port]) }
      it { is_expected.to contain_apache__namevirtualhost("*:#{params[:port]}") }
    end
    context 'set everything!' do
      let :params do
        {
          'ensure'  => 'present',
          'docroot' => '/var/www/foo',
          'manage_docroot' => false,
          'virtual_docroot' => true,
          'port' => '8080',
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
          'ssl_crl' => 'foo.crl',
          'ssl_certs_dir' => '/ssl/certs',
          'ssl_protocol' => 'SSLv2',
          'ssl_cipher' => 'HIGH',
          'ssl_honorcipherorder' => 'Off',
          'ssl_verify_client' => 'optional',
          'ssl_verify_depth' => '3',
          'ssl_options' => '+ExportCertData',
          'ssl_proxyengine' => true,
          'priority' => '30',
          'default_vhost' => true,
          'servername' => 'example.com',
          'serveraliases' => ['test-example.com'],
          'options' => ['MultiView'],
          'override' => ['All'],
          'directoryindex' => 'index.html',
          'vhost_name' => 'test',
          'logroot' => '/var/www/logs',
          'logroot_mode' => '0600',
          'log_level' => 'crit',
          'access_log' => false,
          'access_log_file' => '',
          'access_log_pipe' => '',
          'access_log_syslog' => '',
          'access_log_format' => '',
          'access_log_env_var' => '',
          'aliases' => '/image',
          'directories' =>  { 'path'     => '/var/www/files',
                              'provider' => 'files',
                              'deny'     => 'from all'
          },
          'error_log' => false,
          'error_log_file' => '',
          'error_log_pipe' => '',
          'error_log_syslog' => '',
          'error_documents' => '',
          'fallbackresource' => '/index.php',
          'scriptalias' => '/usr/lib/cgi-bin',
          'scriptaliases' => [
            {
              'alias' => '/myscript',
              'path'  => '/usr/share/myscript',
            },
            {
              'aliasmatch' => '^/foo(.*)',
              'path'       => '/usr/share/fooscripts$1',
            },
          ],
          'proxy_dest' => '/',
          'proxy_pass' => [ { 'path' => '/a', 'url' => 'http://backend-a/' } ],
          'suphp_addhandler' => 'foo',
          'suphp_engine' => 'on',
          'suphp_configpath' => '/var/www/html',
          'php_admin_flags' => ['foo', 'bar'],
          'php_admin_values' => ['true', 'false'],
          'no_proxy_uris' => '/foo',
          'proxy_preserve_host' => true,
          'redirect_source' => '/bar',
          'redirect_dest' => '/',
          'redirect_status' => 'temp',
          'redirectmatch_status' => ['404'],
          'redirectmatch_regexp' => ['\.git$'],
          'rack_base_uris' => ['/rackapp1'],
          'headers' => 'Set X-Robots-Tag "noindex, noarchive, nosnippet"',
          'request_headers' => ['append MirrorID "mirror 12"'],
          'rewrites' => [ { 'rewrite_rule' => ['^index\.html$ welcome.html'] } ],
          'rewrite_base' => '/',
          'rewrite_rule' => '^index\.html$ welcome.html',
          'rewrite_cond' => '%{HTTP_USER_AGENT} ^MSIE',
          'setenv' => ['FOO=/bin/true'],
          'setenvif' => 'Request_URI "\.gif$" object_is_image=gif',
          'block' => 'scm',
          'wsgi_application_group' => '%{GLOBAL}',
          'wsgi_daemon_process' => 'wsgi',
          'wsgi_daemon_process_options' => {
            'processes'    => '2',
            'threads'      => '15',
            'display-name' => '%{GROUP}',
          },
          'wsgi_import_script' => '/var/www/demo.wsgi',
          'wsgi_import_script_options' => { 'process-group' => 'wsgi', 'application-group' => '%{GLOBAL}' },
          'wsgi_process_group' => 'wsgi',
          'wsgi_script_aliases' => { '/' => '/var/www/demo.wsgi' },
          'wsgi_pass_authorization' => 'On',
          'custom_fragment' => '#custom string',
          'itk' => { 'user' => 'someuser', 'group' => 'somegroup' },
          'action' => 'foo',
          'fastcgi_server' => 'localhost',
          'fastcgi_socket' => '/tmp/fastcgi.socket',
          'fastcgi_dir' => '/tmp',
          'additional_includes' => '/custom/path/includes',
          'apache_version' => '2.4',
          'suexec_user_group' => 'root root',
        }
      end
      let :facts do
        {
          :osfamily               => 'RedHat',
          :operatingsystemrelease => '6',
          :concat_basedir         => '/dne',
          :operatingsystem        => 'RedHat',
          :id                     => 'root',
          :kernel                 => 'Linux',
          :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          :kernelversion          => '3.6.2',
        }
      end

      it { should compile.with_all_deps }
    end
  end
  describe 'validation' do
    #TODO
  end
end
