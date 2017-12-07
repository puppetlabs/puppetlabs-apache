require 'spec_helper'

describe 'apache::vhost::scriptalias', type: :define do
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

    it 'fails to compile' do
      is_expected.to compile.and_raise_error(%r{expects a value for})
    end
  end

  context 'With a scriptalias parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { scriptalias: 'foo' }
    end

    it 'creates a ScriptAlias entry with the specified alias for `/cgi-bin`' do
      is_expected.to contain_concat__fragment('rspec.example.com-scriptalias')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ScriptAlias /cgi-bin "foo"\n})
    end
  end

  context 'With a scriptaliases parameter with alias' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { scriptaliases: { alias: '/cgi', path: 'foo' } }
    end

    it 'creates a ScriptAlias entry with the specified values' do
      is_expected.to contain_concat__fragment('rspec.example.com-scriptalias')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ScriptAlias /cgi "foo"\n})
    end
  end

  context 'With a scriptaliases parameter with aliasmatch' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { scriptaliases: { aliasmatch: '([^/]*)\.cgi', path: 'foo/$1' } }
    end

    it 'creates a ScriptAliasMatch entry with the specified values' do
      is_expected.to contain_concat__fragment('rspec.example.com-scriptalias')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ScriptAliasMatch \(\[\^/\]\*\)\\\.cgi "foo/\$1"\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { scriptalias: 'foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-scriptalias-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { scriptalias: 'foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::scriptalias { "rspec.example.com": scriptalias => "foo" }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-scriptalias')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-scriptalias-test_title')
    end
  end
end
