require 'spec_helper'

describe 'apache::vhost::rack_base_uris', type: :define do
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

  context 'With a rack_base_uris parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { rack_base_uris: 'foo' }
    end

    it 'creates a RackBaseURI entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-rack')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RackBaseURI foo\n})
    end
  end

  context 'With a rack_base_uris array' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { rack_base_uris: %w[foo bar] }
    end

    it 'creates a RackBaseURI entry for each value in the array' do
      is_expected.to contain_concat__fragment('rspec.example.com-rack')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RackBaseURI foo\n})
        .with_content(%r{  RackBaseURI bar\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { rack_base_uris: 'foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-rack-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { rack_base_uris: 'foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::rack_base_uris { "rspec.example.com": rack_base_uris => "foo" }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-rack')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-rack-test_title')
    end
  end
end
