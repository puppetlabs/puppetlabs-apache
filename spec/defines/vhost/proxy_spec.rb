require 'spec_helper'

describe 'apache::vhost::proxy', type: :define do
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

    it 'does not create the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-proxy')
    end
  end

  context 'With a proxy_dest parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_dest: 'foo' }
    end

    it 'creates a ProxyRequests off entry and ProxyPass and ProxyPassReverse entries with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyRequests +Off\n})
        .with_content(%r{  ProxyPass +/ foo/\n})
        .with_content(%r{  ProxyPassReverse +/ foo/\n})
    end
  end

  context 'With a proxy_dest and no_proxy_uris parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_dest: 'foo',
        no_proxy_uris: 'bar' }
    end

    it 'creates a ProxyPass entry for the no_proxy_uris values' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPass +bar +!\n})
    end
  end

  context 'With a proxy_dest_match and proxy_dest_reverse_match parameters' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_dest_match: 'foo',
        proxy_dest_reverse_match: 'bar' }
    end

    it 'creates a ProxyRequests off entry and ProxyPassMatch and ProxyPassReverse entries with the specified values' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyRequests +Off\n})
        .with_content(%r{  ProxyPassMatch +/ foo/\n})
        .with_content(%r{  ProxyPassReverse +/ bar/\n})
    end
  end

  context 'With a proxy_dest_match and no_proxy_uris_match parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_dest_match: 'foo',
        no_proxy_uris_match: 'bar' }
    end

    it 'creates a ProxyPassMatch entry for the no_proxy_uris_match values' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPassMatch +bar +!\n})
    end
  end

  context 'With a simple proxy_pass parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass: [{ path: 'foo', url: 'bar' }] }
    end

    it 'creates a ProxyPass entry for the given path' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyRequests +Off\n})
        .with_content(%r{  ProxyPass +foo +bar\n})
        .with_content(%r{  ProxyPassReverse +foo +bar\n})
    end
  end

  context 'With a proxy_pass parameter with params' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass: [{ path: 'foo', url: 'bar', params: { baz: 'quux' } }] }
    end

    it 'creates a ProxyPass entry for the given path with the specific parameters' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPass +foo +bar +baz=quux\n})
    end
  end

  context 'With a proxy_pass parameter with keywords' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass: [{ path: 'foo', url: 'bar', keywords: %w[quux] }] }
    end

    it 'creates a ProxyPass entry for the given path with the specific parameters' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPass +foo +bar +quux\n})
    end
  end

  context 'With a proxy_pass parameter with no_proxy_uris' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass: [{ path: 'foo', url: 'bar', no_proxy_uris: 'baz' }] }
    end

    it 'creates special ProxyPass entries for the no_proxy_uris' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPass +baz +!\n})
    end
  end

  context 'With a proxy_pass parameter with no_proxy_uris_match' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass: [{ path: 'foo', url: 'bar', no_proxy_uris_match: 'baz' }] }
    end

    it 'creates special ProxyPassMatch entries for the no_proxy_uris_match' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPassMatch +baz +!\n})
    end
  end

  context 'With a proxy_pass parameter with a reverse_cookies path' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass: [{ path: 'foo', url: 'bar', reverse_cookies: [{ url: 'baz', path: 'quux' }] }] }
    end

    it 'creates ProxyPassReverseCookiePath entries for the reverse_cookies' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPassReverseCookiePath +quux +baz\n})
    end
  end

  context 'With a proxy_pass parameter with a reverse_cookies domain' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass: [{ path: 'foo', url: 'bar', reverse_cookies: [{ url: 'baz', domain: 'quux' }] }] }
    end

    it 'creates ProxyPassReverseCookieDomain entries for the reverse_cookies' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPassReverseCookieDomain +quux +baz\n})
    end
  end

  context 'With a proxy_pass parameter with reverse_urls' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass: [{ path: 'foo', url: 'bar', reverse_urls: %w[baz] }] }
    end

    it 'creates ProxyPassReverse entries for each reverse url' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPassReverse +foo +baz\n})
    end
  end

  context 'With a proxy_pass parameter with setenv' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass: [{ path: 'foo', url: 'bar', setenv: %w[baz] }] }
    end

    it 'creates SetEnv entries' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  SetEnv +baz\n})
    end
  end

  context 'With a simple proxy_pass_match parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass_match: [{ path: 'foo', url: 'bar' }] }
    end

    it 'creates a ProxyPassMatch entry for the given path' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyRequests +Off\n})
        .with_content(%r{  ProxyPassMatch +foo +bar\n})
        .with_content(%r{  ProxyPassReverse +foo +bar\n})
    end
  end

  context 'With a proxy_pass_match parameter with params' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass_match: [{ path: 'foo', url: 'bar', params: { baz: 'quux' } }] }
    end

    it 'creates a ProxyPassMatch entry for the given path with the specific parameters' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPassMatch +foo +bar +baz=quux\n})
    end
  end

  context 'With a proxy_pass_match parameter with keywords' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass_match: [{ path: 'foo', url: 'bar', keywords: %w[quux] }] }
    end

    it 'creates a ProxyPassMatch entry for the given path with the specific parameters' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPassMatch +foo +bar +quux\n})
    end
  end

  context 'With a proxy_pass_match parameter with no_proxy_uris' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass_match: [{ path: 'foo', url: 'bar', no_proxy_uris: 'baz' }] }
    end

    it 'creates special ProxyPass entries for the no_proxy_uris' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPass +baz +!\n})
    end
  end

  context 'With a proxy_pass_match parameter with no_proxy_uris_match' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass_match: [{ path: 'foo', url: 'bar', no_proxy_uris_match: 'baz' }] }
    end

    it 'creates special ProxyPassMatch entries for the no_proxy_uris_match' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPassMatch +baz +!\n})
    end
  end

  context 'With a proxy_pass_match parameter with reverse_urls' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass_match: [{ path: 'foo', url: 'bar', reverse_urls: %w[baz] }] }
    end

    it 'creates ProxyPassReverse entries for each reverse url' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPassReverse +foo +baz\n})
    end
  end

  context 'With a proxy_pass_match parameter with setenv' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_pass_match: [{ path: 'foo', url: 'bar', setenv: %w[baz] }] }
    end

    it 'creates SetEnv entries' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  SetEnv +baz\n})
    end
  end

  context 'With proxy_preserve_host parameter set to true' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_dest: 'foo',
        proxy_preserve_host: true }
    end

    it 'creates a ProxyPreserveHost entry with the appropriate value' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPreserveHost +On\n})
    end
  end

  context 'With proxy_preserve_host parameter set to false' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_dest: 'foo',
        proxy_preserve_host: false }
    end

    it 'creates a ProxyPreserveHost entry with the appropriate value' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyPreserveHost +Off\n})
    end
  end

  context 'With proxy_add_headers parameter set to true' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_dest: 'foo',
        proxy_add_headers: true }
    end

    it 'creates a ProxyAddHeaders entry with the appropriate value' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyAddHeaders +On\n})
    end
  end

  context 'With proxy_add_headers parameter set to false' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_dest: 'foo',
        proxy_add_headers: false }
    end

    it 'creates a ProxyAddHeaders entry with the appropriate value' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyAddHeaders +Off\n})
    end
  end

  context 'With proxy_error_override parameter set to true' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { proxy_dest: 'foo',
        proxy_error_override: true }
    end

    it 'creates a ProxyErrorOverride entry with the appropriate value' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ProxyErrorOverride +On\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { proxy_dest: 'foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-proxy')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { proxy_dest: 'foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::proxy { "rspec.example.com": proxy_dest => "bar" }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
