require 'spec_helper'

describe 'apache::vhost::block', type: :define do
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

  context 'With a block parameter set to `scm`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { block: 'scm' }
    end

    it 'creates a DirectoryMatch entry matching svn among others' do
      is_expected.to contain_concat__fragment('rspec.example.com-block')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  <DirectoryMatch.*svn})
    end
  end

  context 'With a block parameter set to an array containing `scm`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { block: ['scm'] }
    end

    it 'creates a DirectoryMatch entry matching svn among others' do
      is_expected.to contain_concat__fragment('rspec.example.com-block')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  <DirectoryMatch.*svn})
    end
  end

  context 'With a block parameter set to an invalid value' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { block: 'foo' }
    end

    it 'creates a comment about ignoring unknown `block` directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-block')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{# Ignoring unknown `block` directive})
    end
  end

  context 'With a block parameter set to an array containing an invalid value' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { block: %w[foo] }
    end

    it 'creates a comment about ignoring unknown `block` directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-block')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{# Ignoring unknown `block` directive})
    end
  end

  context 'With a block parameter set to an array containing `scm` and an invalid value' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { block: %w[scm foo] }
    end

    it 'creates a DirectoryMatch entry matching svn among others' do
      is_expected.to contain_concat__fragment('rspec.example.com-block')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  <DirectoryMatch.*svn})
    end
    it 'creates a comment about ignoring unknown `block` directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-block')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{# Ignoring unknown `block` directive})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { block: 'scm',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-block-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { block: 'scm',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::block { "rspec.example.com": block => "scm" }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-block')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-block-test_title')
    end
  end
end
