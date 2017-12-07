require 'spec_helper'

describe 'apache::vhost::header', type: :define do
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

  context 'With a headers parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { headers: 'foo' }
    end

    it 'creates a Header entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-header')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  Header foo\n})
    end
  end

  context 'With a headers array' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { headers: %w[foo bar] }
    end

    it 'creates Header entries for each specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-header')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  Header foo\n  Header bar\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { headers: 'foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat' do
      is_expected.to contain_concat__fragment('rspec.example.com-header-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { headers: 'foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::header { "rspec.example.com": headers => "bar" }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-header')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-header-test_title')
    end
  end
end
