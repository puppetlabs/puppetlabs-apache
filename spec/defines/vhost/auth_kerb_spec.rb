require 'spec_helper'

describe 'apache::vhost::auth_kerb', type: :define do
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

    it 'does not create a fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-auth_kerb')
    end
  end

  context 'With only an auth_kerb parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { auth_kerb: true }
    end

    it 'creates a set of default Krb settings' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  KrbMethodNegotiate on})
        .with_content(%r{  KrbMethodK5Passwd on})
        .with_content(%r{  KrbAuthoritative on})
        .without_content(%r{  KrbAuthRealms })
        .without_content(%r{  Krb5Keytab })
        .without_content(%r{  KrbLocalUserMapping })
        .with_content(%r{  KrbVerifyKDC on})
        .with_content(%r{  KrbServiceName HTTP})
        .with_content(%r{  KrbSaveCredentials off})
    end
    # rubocop:enable RSpec/ExampleLength
  end

  context 'With a krb_method_negotiate parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { auth_kerb: true,
        krb_method_negotiate: 'foo' }
    end

    it 'creates the KrbMethodNegotiate setting' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  KrbMethodNegotiate foo})
    end
  end

  context 'With a krb_method_k5passwd parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { auth_kerb: true,
        krb_method_k5passwd: 'foo' }
    end

    it 'creates the KrbMethodK5Passwd setting' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  KrbMethodK5Passwd foo})
    end
  end

  context 'With a krb_authoritative parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { auth_kerb: true,
        krb_authoritative: 'foo' }
    end

    it 'creates the KrbAuthoritative setting' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  KrbAuthoritative foo})
    end
  end

  context 'With a krb_auth_realms parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { auth_kerb: true,
        krb_auth_realms: %w[foo bar] }
    end

    it 'creates the KrbAuthRealms setting' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  KrbAuthRealms foo bar})
    end
  end

  context 'With a krb_5keytab parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { auth_kerb: true,
        krb_5keytab: 'foo' }
    end

    it 'creates the Krb5Keytab setting' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  Krb5Keytab foo})
    end
  end

  context 'With a krb_local_user_mapping parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { auth_kerb: true,
        krb_local_user_mapping: 'foo' }
    end

    it 'creates the KrbLocalUserMapping setting' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  KrbLocalUserMapping foo})
    end
  end

  context 'With a krb_verify_kdc parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { auth_kerb: true,
        krb_verify_kdc: 'foo' }
    end

    it 'creates the KrbVerifyKDC setting' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  KrbVerifyKDC foo})
    end
  end

  context 'With a krb_servicename parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { auth_kerb: true,
        krb_servicename: 'foo' }
    end

    it 'creates the KrbServiceName setting' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  KrbServiceName foo})
    end
  end

  context 'With a krb_save_credentials parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { auth_kerb: true,
        krb_save_credentials: 'foo' }
    end

    it 'creates the KrbSaveCredentials setting' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  KrbSaveCredentials foo})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { auth_kerb: true,
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_kerb')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { auth_kerb: true,
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::auth_kerb { "rspec.example.com": auth_kerb => true }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
