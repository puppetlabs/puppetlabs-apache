require 'spec_helper'

describe 'apache::vhost::sslproxy', type: :define do
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

    it 'compiles' do
      is_expected.to compile
    end
    it 'does NOT create the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-sslproxy')
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { ssl_proxyengine: true,
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-sslproxy')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { ssl_proxyengine: true,
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::sslproxy { "rspec.example.com": ssl_proxyengine => true }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
