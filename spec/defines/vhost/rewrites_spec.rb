require 'spec_helper'

describe 'apache::vhost::rewrites', type: :define do
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

  context 'With a rewrites parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { rewrites: [{ rewrite_rule: 'foo' }] }
    end

    it 'creates a RewriteRule entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RewriteEngine On\n})
        .with_content(%r{  RewriteRule foo\n})
    end
  end

  context 'With a rewrite_inherit parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { rewrites: [{}],
        rewrite_inherit: true }
    end

    it 'creates a RewriteOptions entry with Inherit' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RewriteOptions Inherit\n})
    end
  end

  context 'With a rewrite_base parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { rewrites: [{}],
        rewrite_base: 'foo' }
    end

    it 'creates a RewriteBase entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RewriteBase foo\n})
    end
  end

  context 'With a rewrites parameter with comment' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { rewrites: [{ comment: 'foo' }] }
    end

    it 'creates a comment with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  #foo\n})
    end
  end

  context 'With a rewrites parameter with rewrite_base' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { rewrites: [{ rewrite_base: 'foo' }] }
    end

    it 'creates a RewriteBase entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RewriteBase foo\n})
    end
  end

  context 'With a rewrites parameter with rewrite_cond' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { rewrites: [{ rewrite_cond: 'foo' }] }
    end

    it 'creates a RewriteCond entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RewriteCond foo\n})
    end
  end

  context 'With a rewrites parameter with rewrite_map' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { rewrites: [{ rewrite_map: 'foo' }] }
    end

    it 'creates a RewriteMap entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RewriteMap foo\n})
    end
  end

  context 'With a rewrite_rule parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { rewrite_rule: 'foo' }
    end

    it 'creates a RewriteRule entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RewriteRule foo\n})
    end
  end

  context 'With both rewrite_rule and rewrites parameters' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { rewrite_rule: 'foo',
        rewrites: [{ rewrite_rule: 'bar' }] }
    end

    it 'creates a RewriteRule entry with the `rewrites` value and ignore the `rewrite_rule` value' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RewriteRule bar\n})
        .without_content(%r{  RewriteRule foo\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { rewrite_rule: 'foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { rewrite_rule: 'foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::rewrites { "rspec.example.com": rewrite_rule => "foo" }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-rewrite-test_title')
    end
  end
end
