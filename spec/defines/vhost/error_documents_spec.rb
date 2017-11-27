require 'spec_helper'

describe 'apache::vhost::error_documents', type: :define do
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

  context 'With an error_documents parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { error_documents: [{ error_code: 404, document: '"foo"' }] }
    end

    it 'creates an ErrorDocument entry with the specified document' do
      is_expected.to contain_concat__fragment('rspec.example.com-error_document')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  ErrorDocument 404 "foo"\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { error_documents: [{ error_code: 404, document: '"foo"' }],
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-error_document-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { error_documents: [{ error_code: 404, document: '"foo"' }],
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::error_documents { "rspec.example.com": error_documents => [ { error_code => 500, document => "foo" } ] }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-error_document')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-error_document-test_title')
    end
  end
end
