require 'spec_helper'

describe 'apache::vhost::fastcgi_dir', type: :define do
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

  context 'With a fastcgi_dir parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { fastcgi_dir: '/foo' }
    end

    it 'creates a Directory entry with the specified directory set to use the fastcgi-script handler' do
      is_expected.to contain_concat__fragment('rspec.example.com-fastcgi_dir')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  <Directory "/foo">\n})
        .with_content(%r{  SetHandler fastcgi-script})
    end
  end

  context 'In Apache 2.2' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { fastcgi_dir: '/foo',
        apache_version: '2.2' }
    end

    it 'creates use Order and Allow From' do
      is_expected.to contain_concat__fragment('rspec.example.com-fastcgi_dir')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  Order allow,deny\n})
        .with_content(%r{  Allow From All})
    end
  end

  context 'In Apache 2.4' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { fastcgi_dir: '/foo',
        apache_version: '2.4' }
    end

    it 'creates use Require' do
      is_expected.to contain_concat__fragment('rspec.example.com-fastcgi_dir')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  Require all granted})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { fastcgi_dir: '/foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-fastcgi_dir-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { fastcgi_dir: '/foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::fastcgi_dir { "rspec.example.com": fastcgi_dir => "/bar" }'
    end

    it 'contains the first fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-fastcgi_dir')
    end
    it 'contains the second fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-fastcgi_dir-test_title')
    end
  end
end
