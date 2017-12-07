require 'spec_helper'

describe 'apache::vhost::http_protocol_options', type: :define do
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

  context 'With a http_protocol_options parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { http_protocol_options: 'Strict' }
    end

    it 'creates an HttpPrototocolOptions entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-http_protocol_options')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{HttpProtocolOptions Strict\n})
    end
  end

  context 'With an invalid http_protocol_options parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { http_protocol_options: 'foo' }
    end

    it 'fails' do
      is_expected.to compile.and_raise_error(%r{expects a match for Pattern})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { http_protocol_options: 'Strict',
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat' do
      is_expected.to contain_concat__fragment('rspec.example.com-http_protocol_options')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { http_protocol_options: 'Strict',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::http_protocol_options { "rspec.example.com": http_protocol_options => "Unsafe" }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
