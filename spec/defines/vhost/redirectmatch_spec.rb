require 'spec_helper'

describe 'apache::vhost::redirectmatch', type: :define do
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

  context 'With redirectmatch_regexp and redirectmatch_dest parameters' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { redirectmatch_regexp: 'foo',
        redirectmatch_dest: 'bar' }
    end

    it 'creates a RedirectMatch entry with the specified values' do
      is_expected.to contain_concat__fragment('rspec.example.com-redirectmatch')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RedirectMatch +foo +bar\n})
    end
  end

  context 'With redirectmatch_status, redirectmatch_regexp and redirectmatch_dest parameters' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { redirectmatch_status: 'quux',
        redirectmatch_regexp: 'foo',
        redirectmatch_dest: 'bar' }
    end

    it 'creates a RedirectMatch entry with the specified values' do
      is_expected.to contain_concat__fragment('rspec.example.com-redirectmatch')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  RedirectMatch +quux +foo +bar\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { redirectmatch_regexp: 'foo',
        redirectmatch_dest: 'bar',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-redirectmatch-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { redirectmatch_regexp: 'foo',
        redirectmatch_dest: 'bar',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::redirectmatch { "rspec.example.com": redirectmatch_regexp => "baz", redirectmatch_dest => "quux" }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-redirectmatch')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-redirectmatch-test_title')
    end
  end
end
