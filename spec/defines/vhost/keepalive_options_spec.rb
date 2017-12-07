require 'spec_helper'

describe 'apache::vhost::keepalive_options', type: :define do
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

    it 'does not create a fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-keepalive_options')
    end
  end

  context 'With a keepalive parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { keepalive: 'on' }
    end

    it 'creates a KeepAlive entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-keepalive_options')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  KeepAlive on\n})
    end
  end

  context 'With a keepalive_timeout parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { keepalive_timeout: 5 }
    end

    it 'creates a KeepAliveTimeout1 entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-keepalive_options')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  KeepAliveTimeout 5\n})
    end
  end

  context 'With a max_keepalive_requests parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { max_keepalive_requests: 5 }
    end

    it 'creates a MaxKeepAliveRequests entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-keepalive_options')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  MaxKeepAliveRequests 5\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { keepalive: 'on',
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-keepalive_options')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { keepalive: 'on',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::keepalive_options { "rspec.example.com": keepalive_timeout => 5 }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
