require 'spec_helper'

describe 'apache::vhost::allow_encoded_slashes', type: :define do
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

  context 'With allow_encoded_slashes parameter set to `on`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { allow_encoded_slashes: 'on' }
    end

    it 'creates an AllowEncodedSlashes entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-allow_encoded_slashes')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  AllowEncodedSlashes on\n})
    end
  end

  context 'With allow_encoded_slashes parameter set to `off`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { allow_encoded_slashes: 'off' }
    end

    it 'creates an AllowEncodedSlashes entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-allow_encoded_slashes')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  AllowEncodedSlashes off\n})
    end
  end

  context 'With allow_encoded_slashes parameter set to `nodecode`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { allow_encoded_slashes: 'nodecode' }
    end

    it 'creates an AllowEncodedSlashes entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-allow_encoded_slashes')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  AllowEncodedSlashes nodecode\n})
    end
  end

  context 'With allow_encoded_slashes parameter set to an invalid value' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { allow_encoded_slashes: 'foobarbaz' }
    end

    it 'fails to compile' do
      is_expected.to compile.and_raise_error(%r{expects a match for})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { allow_encoded_slashes: 'on',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-allow_encoded_slashes')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { allow_encoded_slashes: 'on',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::allow_encoded_slashes { "rspec.example.com": allow_encoded_slashes => "off" }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
