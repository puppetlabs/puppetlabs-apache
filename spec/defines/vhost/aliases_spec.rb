require 'spec_helper'

describe 'apache::vhost::aliases', type: :define do
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
      is_expected.to compile.and_raise_error(%r{expects a value for parameter})
    end
  end

  context 'With an aliases parameter containing an `alias`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { aliases: [{ alias: '/alias', path: '/foo' }] }
    end

    it 'creates an Alias entry with the specified alias' do
      is_expected.to contain_concat__fragment('rspec.example.com-aliases')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{\n  Alias /alias "/foo"\n})
    end
  end

  context 'With an aliases parameter containing an `aliasmatch`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { aliases: [{ aliasmatch: '/aliasmatch', path: '/foo' }] }
    end

    it 'creates an AliasMatch entry with the specified alias' do
      is_expected.to contain_concat__fragment('rspec.example.com-aliases')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{\n  AliasMatch /aliasmatch "/foo"\n})
    end
  end

  context 'With an aliases parameter containing a `scriptalias`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { aliases: [{ scriptalias: '/scriptalias', path: '/foo' }] }
    end

    it 'creates an ScriptAlias entry with the specified alias' do
      is_expected.to contain_concat__fragment('rspec.example.com-aliases')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{\n  ScriptAlias /scriptalias "/foo"\n})
    end
  end

  context 'With an aliases parameter containing an `scriptaliasmatch`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { aliases: [{ scriptaliasmatch: '/scriptaliasmatch', path: '/foo' }] }
    end

    it 'creates an ScriptAliasMatch entry with the specified alias' do
      is_expected.to contain_concat__fragment('rspec.example.com-aliases')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{\n  ScriptAliasMatch /scriptaliasmatch "/foo"\n})
    end
  end

  context 'With an empty aliases parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { aliases: [] }
    end

    it 'creates an empty fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-aliases')
        .with_target('apache::vhost::rspec.example.com')
        .with_content('')
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { aliases: [{ alias: '/alias', path: '/foo' }],
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-aliases-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { aliases: [{ alias: '/alias', path: '/foo' }],
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::aliases { "rspec.example.com": aliases => [] }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-aliases')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-aliases-test_title')
    end
  end
end
