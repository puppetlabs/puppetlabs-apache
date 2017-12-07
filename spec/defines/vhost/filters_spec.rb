require 'spec_helper'

describe 'apache::vhost::filters', type: :define do
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

  context 'With a filters parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { filters: 'foo' }
    end

    it 'creates the specified directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-filters')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  foo\n})
    end
  end

  context 'With a filters array' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { filters: %w[foo bar] }
    end

    it 'creates the specified directives' do
      is_expected.to contain_concat__fragment('rspec.example.com-filters')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  foo\n  bar\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { filters: 'foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat' do
      is_expected.to contain_concat__fragment('rspec.example.com-filters-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { filters: 'foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::filters { "rspec.example.com": filters => "bar" }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-filters')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-filters-test_title')
    end
  end
end
