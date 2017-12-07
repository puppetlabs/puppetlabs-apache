require 'spec_helper'

describe 'apache::vhost::redirect', type: :define do
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

  context 'With redirect_source and redirect_dest parameters' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { redirect_source: 'foo',
        redirect_dest: 'bar' }
    end

    it 'creates a Redirect entry with the specified values' do
      is_expected.to contain_concat__fragment('rspec.example.com-redirect')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  Redirect +foo +bar\n})
    end
  end

  context 'With redirect_status, redirect_source and redirect_dest parameters' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { redirect_status: 'quux',
        redirect_source: 'foo',
        redirect_dest: 'bar' }
    end

    it 'creates a Redirect entry with the specified values' do
      is_expected.to contain_concat__fragment('rspec.example.com-redirect')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  Redirect +quux +foo +bar\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { redirect_source: 'foo',
        redirect_dest: 'bar',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-redirect-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { redirect_source: 'foo',
        redirect_dest: 'bar',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::redirect { "rspec.example.com": redirect_source => "baz", redirect_dest => "quux" }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-redirect')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-redirect-test_title')
    end
  end
end
