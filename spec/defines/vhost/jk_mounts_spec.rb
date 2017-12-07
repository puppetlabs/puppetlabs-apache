require 'spec_helper'

describe 'apache::vhost::jk_mounts', type: :define do
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

  context 'With a non-array jk_mounts parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { jk_mounts: 'foo' }
    end

    it 'fails to compile' do
      is_expected.to compile.and_raise_error(%r{expects an Array})
    end
  end

  context 'With a jk_mounts parameter of an array of non-hash values' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { jk_mounts: %w[foo] }
    end

    it 'fails to compile' do
      is_expected.to compile.and_raise_error(%r{expects a Hash})
    end
  end

  context 'With a jk_mounts parameter with `mount` entry' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { jk_mounts: [{ mount: 'foo', worker: 'bar' }] }
    end

    it 'creates a JkMount entry with the specified worker' do
      is_expected.to contain_concat__fragment('rspec.example.com-jk_mounts')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  JkMount +foo +bar\n})
    end
  end

  context 'With a jk_mounts parameter with `unmount` entry' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { jk_mounts: [{ unmount: 'foo', worker: 'bar' }] }
    end

    it 'creates a JkUnMount entry with the specified worker' do
      is_expected.to contain_concat__fragment('rspec.example.com-jk_mounts')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  JkUnMount +foo +bar\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { jk_mounts: [{ mount: 'foo', worker: 'bar' }],
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat' do
      is_expected.to contain_concat__fragment('rspec.example.com-jk_mounts-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { jk_mounts: [{ mount: 'foo', worker: 'bar' }],
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::jk_mounts { "rspec.example.com": jk_mounts => [ { unmount => baz, worker => quux } ] }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-jk_mounts')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-jk_mounts-test_title')
    end
  end
end
