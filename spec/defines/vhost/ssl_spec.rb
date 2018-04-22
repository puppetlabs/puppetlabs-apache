require 'spec_helper'

describe 'apache::vhost::ssl', type: :define do
  let :facts do
    {
      osfamily: 'RedHat',
      operatingsystemrelease: '6',
      concat_basedir: '/dne',
      operatingsystem: 'RedHat',
      id: 'root',
      kernel: 'Linux',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      is_pe: false,
    }
  end
  let :pre_condition do
    'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}'
  end

  context 'With no parameters' do
    let(:title) { 'rspec.example.com' }

    it 'compiles' do
      is_expected.to compile
    end
    it 'does not create a concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-ssl')
    end
  end

  context 'With just `ssl=>true`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true }
    end

    it 'creates the concat fragment with default values' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLEngine on})
        .with_content(%r{SSLCertificateFile +"/etc/pki/tls/certs/localhost.crt"})
        .with_content(%r{SSLCertificateKeyFile +"/etc/pki/tls/private/localhost.key"})
    end
  end

  context 'With an SSL certificate' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_cert: 'my-certificate.crt' }
    end

    it 'creates the SSLCertificateFile directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLCertificateFile +"my-certificate.crt"})
    end
  end

  context 'With an SSL key' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_key: 'my-private-key.pem' }
    end

    it 'creates the SSLCertificateKeyFile directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLCertificateKeyFile +"my-private-key.pem"})
    end
  end

  context 'With an SSL chain' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_chain: 'my-cert-chain.pem' }
    end

    it 'creates the SSLCertificateChain directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLCertificateChainFile +"my-cert-chain.pem"})
    end
  end

  context 'With a value for SSL verify client' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_verify_client: 'optional' }
    end

    it 'creates the SSLVerifyClient directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLVerifyClient +optional})
    end
  end

  context 'With an SSL CA certificate' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_verify_client: 'optional',
        ssl_ca: 'my-ca-cert.crt' }
    end

    it 'creates the SSLCACertificateFile directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLCACertificateFile +"my-ca-cert.crt"})
    end
  end

  context 'With an SSL CA CRL path' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_verify_client: 'optional',
        ssl_crl_path: 'my-ca-crl-path' }
    end

    it 'creates the SSLCARevocationPath directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLCARevocationPath +"my-ca-crl-path"})
    end
  end

  context 'With an SSL CA CRL file' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_verify_client: 'optional',
        ssl_crl: 'my-ca-crl.crl' }
    end

    it 'creates the SSLCARevocationFile directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLCARevocationFile +"my-ca-crl.crl"})
    end
  end

  context 'With an SSL CA CRL check parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_verify_client: 'optional',
        ssl_crl_check: 'chain' }
    end

    context 'On apache < 2.4' do
      let :params do
        super().merge(
          apache_version: '2.2',
        )
      end

      it 'does NOT create the SSLCARevocationCheck directive' do
        is_expected.to contain_concat__fragment('rspec.example.com-ssl')
          .with_target('apache::vhost::rspec.example.com')
          .without_content(%r{SSLCARevocationCheck})
      end
    end

    context 'On apache 2.4' do
      let :params do
        super().merge(
          apache_version: '2.4',
        )
      end

      it 'creates the SSLCARevocationCheck directive' do
        is_expected.to contain_concat__fragment('rspec.example.com-ssl')
          .with_target('apache::vhost::rspec.example.com')
          .with_content(%r{SSLCARevocationCheck +"chain"})
      end
    end
  end

  context 'With an SSL certs directory' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_verify_client: 'optional',
        ssl_certs_dir: 'my-certs-dir' }
    end

    it 'creates the SSLCACertificatePath directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLCACertificatePath +"my-certs-dir"})
    end
  end

  context 'With a string value for SSL protocol' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_protocol: 'TLSv1.2' }
    end

    it 'creates the SSLProtocol directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLProtocol +TLSv1.2})
    end
  end

  context 'With an array value for SSL protocol' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_protocol: ['ALL', '-SSLv3'] }
    end

    it 'creates the SSLProtocol directive with all array values' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLProtocol +ALL -SSLv3})
    end
  end

  context 'With a value for SSL cipher' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_cipher: 'RSA:!EXP:!NULL:+HIGH:+MEDIUM:-LOW' }
    end

    it 'creates the SSLCipherSuite directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLCipherSuite +RSA:!EXP:!NULL:\+HIGH:\+MEDIUM:-LOW})
    end
  end

  context 'With a string value for SSL honor cipher order' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_honorcipherorder: 'on' }
    end

    it 'creates the SSLHonorCipherorder directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLHonorCipherOrder +on})
    end
  end

  context 'With a boolean value for SSL honor cipher order' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_honorcipherorder: 'on' }
    end

    it 'creates the SSLHonorCipherorder directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLHonorCipherOrder +on})
    end
  end

  context 'With a value for SSL verify depth' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_verify_client: 'optional',
        ssl_verify_depth: 2 }
    end

    it 'creates the SSLVerifyDepth directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLVerifyDepth +2})
    end
  end

  context 'With a string value for SSL options' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_options: 'StdEnvVars' }
    end

    it 'creates the correct SSLOptions directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLOptions +StdEnvVars})
    end
  end

  context 'With an array value for SSL options' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_options: %w[StdEnvVars StrictRequire] }
    end

    it 'creates the SSLOptions directive with the given options in the given order' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLOptions +StdEnvVars StrictRequire})
    end
  end

  context 'With a value for SSL openssl conf cmd' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_openssl_conf_cmd: 'Options -SessionTicket,ServerPreference' }
    end

    it 'creates the SSLOpenSSLConfCmd directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SSLOpenSSLConfCmd +Options -SessionTicket,ServerPreference})
    end
  end

  context 'With a value for SSL stapling' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_stapling: true }
    end

    context 'On apache < 2.4' do
      let :params do
        super().merge(
          apache_version: '2.2',
        )
      end

      it 'does NOT create the SSLUseStapling directive' do
        is_expected.to contain_concat__fragment('rspec.example.com-ssl')
          .with_target('apache::vhost::rspec.example.com')
          .without_content(%r{SSLUseStapling})
      end
    end

    context 'On apache 2.4' do
      let :params do
        super().merge(
          apache_version: '2.4',
        )
      end

      it 'creates the SSLUseStapling directive' do
        is_expected.to contain_concat__fragment('rspec.example.com-ssl')
          .with_target('apache::vhost::rspec.example.com')
          .with_content(%r{SSLUseStapling +On})
      end
    end
  end

  context 'With a value for SSL stapling timeout' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_stapling_timeout: 5 }
    end

    context 'On apache < 2.4' do
      let :params do
        super().merge(
          apache_version: '2.2',
        )
      end

      it 'does NOT create the SSLStaplingResponderTimeout directive' do
        is_expected.to contain_concat__fragment('rspec.example.com-ssl')
          .with_target('apache::vhost::rspec.example.com')
          .without_content(%r{SSLStaplingResponderTimeout})
      end
    end

    context 'On apache 2.4' do
      let :params do
        super().merge(
          apache_version: '2.4',
        )
      end

      it 'creates the SSLStaplingResponderTimeout directive' do
        is_expected.to contain_concat__fragment('rspec.example.com-ssl')
          .with_target('apache::vhost::rspec.example.com')
          .with_content(%r{SSLStaplingResponderTimeout +5})
      end
    end
  end

  context 'With a value for SSL stapling return errors' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { ssl: true,
        ssl_stapling_return_errors: true }
    end

    context 'On apache < 2.4' do
      let :params do
        super().merge(
          apache_version: '2.2',
        )
      end

      it 'does NOT create the SSLStaplingReturnResponderErrors directive' do
        is_expected.to contain_concat__fragment('rspec.example.com-ssl')
          .with_target('apache::vhost::rspec.example.com')
          .without_content(%r{SSLStaplingReturnResponderErrors})
      end
    end

    context 'On apache 2.4' do
      let :params do
        super().merge(
          apache_version: '2.4',
        )
      end

      it 'creates the SSLStaplingReturnResponderErrors directive' do
        is_expected.to contain_concat__fragment('rspec.example.com-ssl')
          .with_target('apache::vhost::rspec.example.com')
          .with_content(%r{SSLStaplingReturnResponderErrors +On})
      end
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { ssl: true,
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-ssl')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { ssl: true,
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::ssl { "rspec.example.com": ssl => true }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
