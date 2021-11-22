# frozen_string_literal: true

require 'spec_helper_acceptance'
apache_hash = apache_settings_hash
describe 'apache ssl' do
  describe 'ssl parameters' do
    pp = <<-MANIFEST
        class { 'apache':
          service_ensure        => stopped,
          default_ssl_vhost     => true,
          default_ssl_cert      => '/tmp/ssl_cert',
          default_ssl_key       => '/tmp/ssl_key',
          default_ssl_chain     => '/tmp/ssl_chain',
          default_ssl_ca        => '/tmp/ssl_ca',
          default_ssl_crl_path  => '/tmp/ssl_crl_path',
          default_ssl_crl       => '/tmp/ssl_crl',
          default_ssl_crl_check => 'chain',
        }
    MANIFEST
    it 'runs without error' do
      idempotent_apply(pp)
    end

    describe file("#{apache_hash['mod_ssl_dir']}/ssl.conf") do
      it { is_expected.to be_file }
      if os[:family].include?('redhat') && os[:release].to_i == 8
        it { is_expected.to contain 'SSLProtocol all' }
      else
        it { is_expected.to contain 'SSLProtocol all -SSLv2 -SSLv3' }
      end
    end

    describe file("#{apache_hash['vhost_dir']}/15-default-ssl-443.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'SSLCertificateFile      "/tmp/ssl_cert"' }
      it { is_expected.to contain 'SSLCertificateKeyFile   "/tmp/ssl_key"' }
      it { is_expected.to contain 'SSLCertificateChainFile "/tmp/ssl_chain"' }
      it { is_expected.to contain 'SSLCACertificateFile    "/tmp/ssl_ca"' }
      it { is_expected.to contain 'SSLCARevocationPath     "/tmp/ssl_crl_path"' }
      it { is_expected.to contain 'SSLCARevocationFile     "/tmp/ssl_crl"' }
      if apache_hash['version'] == '2.4'
        it { is_expected.to contain 'SSLCARevocationCheck    chain' }
      else
        it { is_expected.not_to contain 'SSLCARevocationCheck' }
      end
    end
  end

  describe 'vhost ssl parameters' do
    pp = <<-MANIFEST
        file { [
          '/tmp/ssl_cert',
          '/tmp/ssl_key',
          '/tmp/ssl_chain',
          '/tmp/ssl_ca',
          '/tmp/ssl_crl',
          ]:
            ensure             => file,
            before             => Class['apache']
        }

        class { 'apache':
          service_ensure       => stopped,
        }

        apache::vhost { 'test_ssl':
          docroot              => '/tmp/test',
          ssl                  => true,
          ssl_cert             => '/tmp/ssl_cert',
          ssl_key              => '/tmp/ssl_key',
          ssl_chain            => '/tmp/ssl_chain',
          ssl_ca               => '/tmp/ssl_ca',
          ssl_crl_path         => '/tmp/ssl_crl_path',
          ssl_crl              => '/tmp/ssl_crl',
          ssl_crl_check        => 'chain flag',
          ssl_certs_dir        => '/tmp',
          ssl_reload_on_change => true,
          ssl_protocol         => 'test',
          ssl_cipher           => 'test',
          ssl_honorcipherorder => true,
          ssl_verify_client    => 'require',
          ssl_verify_depth     => 'test',
          ssl_options          => ['test', 'test1'],
          ssl_proxyengine      => true,
          ssl_proxy_protocol   => 'TLSv1.2',
        }
    MANIFEST
    it 'runs without error' do
      idempotent_apply(pp)
    end

    describe file("#{apache_hash['vhost_dir']}/25-test_ssl.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'SSLCertificateFile      "/tmp/ssl_cert"' }
      it { is_expected.to contain 'SSLCertificateKeyFile   "/tmp/ssl_key"' }
      it { is_expected.to contain 'SSLCertificateChainFile "/tmp/ssl_chain"' }
      it { is_expected.to contain 'SSLCACertificateFile    "/tmp/ssl_ca"' }
      it { is_expected.to contain 'SSLCACertificatePath    "/tmp"' }
      it { is_expected.to contain 'SSLCARevocationPath     "/tmp/ssl_crl_path"' }
      it { is_expected.to contain 'SSLCARevocationFile     "/tmp/ssl_crl"' }
      it { is_expected.to contain 'SSLProxyEngine On' }
      it { is_expected.to contain 'SSLProtocol             test' }
      it { is_expected.to contain 'SSLCipherSuite          test' }
      it { is_expected.to contain 'SSLHonorCipherOrder     On' }
      it { is_expected.to contain 'SSLVerifyClient         require' }
      it { is_expected.to contain 'SSLVerifyDepth          test' }
      it { is_expected.to contain 'SSLOptions test test1' }
      if apache_hash['version'] == '2.4'
        it { is_expected.to contain 'SSLCARevocationCheck    chain flag' }
      else
        it { is_expected.not_to contain 'SSLCARevocationCheck' }
      end
    end

    describe file("#{apache_hash['httpd_dir']}/puppet_ssl/test_ssl_tmp_ssl_cert") do
      it { is_expected.to be_file }
    end

    describe file("#{apache_hash['httpd_dir']}/puppet_ssl/test_ssl_tmp_ssl_key") do
      it { is_expected.to be_file }
    end

    describe file("#{apache_hash['httpd_dir']}/puppet_ssl/test_ssl_tmp_ssl_chain") do
      it { is_expected.to be_file }
    end

    describe file("#{apache_hash['httpd_dir']}/puppet_ssl/test_ssl_tmp_ssl_ca") do
      it { is_expected.to be_file }
    end

    describe file("#{apache_hash['httpd_dir']}/puppet_ssl/test_ssl_tmp_ssl_crl") do
      it { is_expected.to be_file }
    end
  end

  describe 'vhost ssl ssl_ca only' do
    pp = <<-MANIFEST
        class { 'apache':
          service_ensure       => stopped,
        }

        apache::vhost { 'test_ssl_ca_only':
          docroot              => '/tmp/test',
          ssl                  => true,
          ssl_cert             => '/tmp/ssl_cert',
          ssl_key              => '/tmp/ssl_key',
          ssl_ca               => '/tmp/ssl_ca',
          ssl_verify_client    => 'optional',
        }
    MANIFEST
    it 'runs without error' do
      idempotent_apply(pp)
    end

    describe file("#{apache_hash['vhost_dir']}/25-test_ssl_ca_only.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'SSLCertificateFile      "/tmp/ssl_cert"' }
      it { is_expected.to contain 'SSLCertificateKeyFile   "/tmp/ssl_key"' }
      it { is_expected.to contain 'SSLCACertificateFile    "/tmp/ssl_ca"' }
      it { is_expected.not_to contain 'SSLCACertificatePath' }
    end
  end

  describe 'vhost ssl ssl_certs_dir' do
    pp = <<-MANIFEST
        class { 'apache':
          service_ensure       => stopped,
        }

        apache::vhost { 'test_ssl_certs_dir_only':
          docroot              => '/tmp/test',
          ssl                  => true,
          ssl_cert             => '/tmp/ssl_cert',
          ssl_key              => '/tmp/ssl_key',
          ssl_certs_dir        => '/tmp',
          ssl_verify_client    => 'require',
        }
    MANIFEST
    it 'runs without error' do
      idempotent_apply(pp)
    end

    describe file("#{apache_hash['vhost_dir']}/25-test_ssl_certs_dir_only.conf") do
      it { is_expected.to be_file }
      it { is_expected.to contain 'SSLCertificateFile      "/tmp/ssl_cert"' }
      it { is_expected.to contain 'SSLCertificateKeyFile   "/tmp/ssl_key"' }
      it { is_expected.to contain 'SSLCACertificatePath    "/tmp"' }
      it { is_expected.to contain 'SSLVerifyClient         require' }
      it { is_expected.not_to contain 'SSLCACertificateFile' }
    end
  end
end
