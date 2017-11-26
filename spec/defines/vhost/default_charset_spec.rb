require 'spec_helper'

describe 'apache::vhost::default_charset', type: :define do
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

  context 'With a add_default_charset parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { add_default_charset: 'foo' }
    end

    it 'creates a add_default_charset entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-charsets')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  AddDefaultCharset foo\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { add_default_charset: 'foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-charsets')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { add_default_charset: 'foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::default_charset { "rspec.example.com": add_default_charset => "foo" }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
