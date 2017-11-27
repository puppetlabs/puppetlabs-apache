require 'spec_helper'

describe 'apache::vhost::docroot', type: :define do
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
      is_expected.to compile.and_raise_error(%r{must be specified})
    end
  end

  context 'With a docroot parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { docroot: 'foo' }
    end

    it 'creates a DocumentRoot entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-docroot')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  DocumentRoot "foo"\n})
    end
  end

  context 'With a virtual_docroot parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { virtual_docroot: 'foo' }
    end

    it 'creates a VirtualDocumentRoot entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-docroot')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  VirtualDocumentRoot "foo"\n})
    end
  end

  context 'With both docroot and virtual_docroot parameters' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { docroot: 'foo',
        virtual_docroot: 'foo' }
    end

    # we should test for the warning, but no way to do that yet

    it 'creates a VirtualDocumentRoot entry with the specified value' do
      is_expected.to contain_concat__fragment('rspec.example.com-docroot')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  VirtualDocumentRoot "foo"\n})
    end
  end

  context 'With docroot set to false and no virtual_docroot' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { docroot: false }
    end

    it 'fails to compile' do
      is_expected.to compile.and_raise_error(%r{must be specified})
    end
  end

  context 'With virtual_docroot set to false and no docroot' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { virtual_docroot: false }
    end

    it 'fails to compile' do
      is_expected.to compile.and_raise_error(%r{must be specified})
    end
  end

  context 'With both docroot and virtual_docroot set to false' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { docroot: false,
        virtual_docroot: false }
    end

    it 'fails to compile' do
      is_expected.to compile.and_raise_error(%r{must be specified})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { docroot: 'foo',
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-docroot')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { virtual_docroot: 'foo',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::docroot { "rspec.example.com": docroot => "foo" }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
