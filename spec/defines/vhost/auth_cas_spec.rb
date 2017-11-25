require 'spec_helper'

describe 'apache::vhost::auth_cas', type: :define do
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
    'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
     class { "apache::mod::auth_cas": cas_login_url => foo, cas_validate_url => foo, cas_cookie_path => "/tmp/foo", suppress_warning => true }'
  end

  context 'With no parameters' do
    let(:title) { 'rspec.example.com' }

    it 'does not create the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-auth_cas')
    end
  end

  context 'Without the cas module loaded' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_version: 'foo' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}'
    end

    it 'does not create the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-auth_cas')
    end
  end

  context 'With a cas_attribute_prefix parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_attribute_prefix: 'foo' }
    end

    it 'creates a CASAttributePrefix entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASAttributePrefix foo\n})
    end
  end

  context 'With a cas_attribute_delimiter parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_attribute_delimiter: 'foo' }
    end

    it 'creates a CASAttributeDelimiter entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASAttributeDelimiter foo\n})
    end
  end

  context 'With a cas_scrub_request_headers parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_scrub_request_headers: 'foo' }
    end

    it 'creates a CASScrubRequestHeaders entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASScrubRequestHeaders On\n})
    end
  end

  context 'With a cas_sso_enabled parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_sso_enabled: 'foo' }
    end

    it 'creates a CASSSOEnabled entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASSSOEnabled On\n})
    end
  end

  context 'With a cas_login_url parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_login_url: 'foo' }
    end

    it 'creates a CASLoginURL entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASLoginURL foo\n})
    end
  end

  context 'With a cas_validate_url parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_validate_url: 'foo' }
    end

    it 'creates a CASValidateURL entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASValidateURL foo\n})
    end
  end

  context 'With a cas_validate_saml parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_validate_saml: 'foo' }
    end

    it 'creates a CASValidateSAML entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASValidateSAML On\n})
    end
  end

  context 'With a cas_authoritative parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_authoritative: 'foo' }
    end

    it 'creates a CASAuthoritative entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASAuthoritative foo\n})
    end
  end

  context 'With a cas_cache_clean_interval parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_cache_clean_interval: 'foo' }
    end

    it 'creates a CASCacheCleanInterval entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASCacheCleanInterval foo\n})
    end
  end

  context 'With a cas_certificate_path parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_certificate_path: 'foo' }
    end

    it 'creates a CASCertificatePath entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASCertificatePath foo\n})
    end
  end

  context 'With a cas_cookie_domain parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_cookie_domain: 'foo' }
    end

    it 'creates a CASCookieDomain entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASCookieDomain foo\n})
    end
  end

  context 'With a cas_cookie_entropy parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_cookie_entropy: 'foo' }
    end

    it 'creates a CASCookieEntropy entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASCookieEntropy foo\n})
    end
  end

  context 'With a cas_cookie_http_only parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_cookie_http_only: 'foo' }
    end

    it 'creates a CASCookieHttpOnly entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASCookieHttpOnly foo\n})
    end
  end

  context 'With a cas_cookie_path parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_cookie_path: 'foo' }
    end

    it 'creates a CASCookiePath entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASCookiePath foo\n})
    end
  end

  context 'With a cas_debug parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_debug: 'foo' }
    end

    it 'creates a CASDebug entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASDebug foo\n})
    end
  end

  context 'With a cas_idle_timeout parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_idle_timeout: 'foo' }
    end

    it 'creates a CASIdleTimeout entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASIdleTimeout foo\n})
    end
  end

  context 'With a cas_proxy_validate_url parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_proxy_validate_url: 'foo' }
    end

    it 'creates a CASProxyValidateURL entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASProxyValidateURL foo\n})
    end
  end

  context 'With a cas_root_proxied_as parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_root_proxied_as: 'foo' }
    end

    it 'creates a CASRootProxiedAs entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASRootProxiedAs foo\n})
    end
  end

  context 'With a cas_timeout parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_timeout: 'foo' }
    end

    it 'creates a CASTimeout entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASTimeout foo\n})
    end
  end

  context 'With a cas_validate_depth parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_validate_depth: 'foo' }
    end

    it 'creates a CASValidateDepth entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASValidateDepth foo\n})
    end
  end

  context 'With a cas_version parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { cas_version: 'foo' }
    end

    it 'creates a CASVersion entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  CASVersion foo\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { cas_version: 'foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-auth_cas')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { cas_version: 'foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       class { "apache::mod::auth_cas": cas_login_url => foo, cas_validate_url => foo, cas_cookie_path => "/tmp/foo", suppress_warning => true }
       apache::vhost::auth_cas { "rspec.example.com": cas_version => "foo" }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
