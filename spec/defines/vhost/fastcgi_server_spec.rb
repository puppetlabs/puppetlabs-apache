require 'spec_helper'

describe 'apache::vhost::fastcgi_server', type: :define do
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

  context 'With only a fastcgi_server parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { fastcgi_server: 'foo' }
    end

    it 'fails to compile' do
      is_expected.to compile.and_raise_error(%r{expects a value for parameter})
    end
  end

  context 'With only a fastcgi_socket parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { fastcgi_socket: 'bar' }
    end

    it 'fails to compile' do
      is_expected.to compile.and_raise_error(%r{expects a value for parameter})
    end
  end

  context 'With both fastcgi_server and fastcgi_socket parameters' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { fastcgi_server: 'foo',
        fastcgi_socket: 'bar' }
    end

    it 'creates a FastCgiExternalServer entry with the specified values' do
      is_expected.to contain_concat__fragment('rspec.example.com-fastcgi')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  FastCgiExternalServer foo -socket bar\n})
    end
  end

  context 'With a fastcgi_idle_timeout parameter also' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { fastcgi_server: 'foo',
        fastcgi_socket: 'bar',
        fastcgi_idle_timeout: 'baz' }
    end

    it 'includes the -idle-timeout option' do
      is_expected.to contain_concat__fragment('rspec.example.com-fastcgi')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  FastCgiExternalServer foo -socket bar -idle-timeout baz\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { fastcgi_server: 'foo',
        fastcgi_socket: 'bar',
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-fastcgi')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { fastcgi_server: 'foo',
        fastcgi_socket: 'bar',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::fastcgi_server { "rspec.example.com": fastcgi_server => "baz", fastcgi_socket => "quux" }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
