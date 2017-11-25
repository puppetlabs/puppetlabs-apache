require 'spec_helper'

describe 'apache::vhost::additional_includes', type: :define do
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

  context 'With an additional_includes parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { additional_includes: 'foo' }
    end

    it 'creates an Include entry with the specified include' do
      is_expected.to contain_concat__fragment('rspec.example.com-additional_includes')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  Include "foo"\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { additional_includes: 'foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-additional_includes-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { additional_includes: 'foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::additional_includes { "rspec.example.com": additional_includes => "foo" }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-additional_includes')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-additional_includes-test_title')
    end
  end

  context 'With apache 2.2 and use_optional_includes' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { additional_includes: 'foo',
        use_optional_includes: true,
        apache_version: '2.2' }
    end

    it 'creates an Include entry with the specified include' do
      is_expected.to contain_concat__fragment('rspec.example.com-additional_includes')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  Include "foo"\n})
    end
  end

  context 'With apache 2.4 and use_optional_includes' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { additional_includes: 'foo',
        use_optional_includes: true,
        apache_version: '2.4' }
    end

    it 'creates an IncludeOptional entry with the specified include' do
      is_expected.to contain_concat__fragment('rspec.example.com-additional_includes')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  IncludeOptional "foo"\n})
    end
  end
end
