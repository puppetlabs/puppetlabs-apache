require 'spec_helper'

describe 'apache::vhost::wsgi_script_aliases', type: :define do
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
    it 'does not create the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-wsgi_script_aliases')
    end
  end

  context 'With a hash for `wsgi_script_aliases`' do
    let(:title) { 'rspec.example.com' }
    let(:params) do
      { wsgi_script_aliases: { '/bar' => '/path/to/bar', '/baz' => '/path/to/baz' } }
    end

    it 'creates a WSGIScriptAlias directive for each entry in the hash (in any order)' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi_script_aliases')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIScriptAlias /bar "/path/to/bar"})
        .with_content(%r{WSGIScriptAlias /baz "/path/to/baz"})
    end
  end

  context 'With an array for a value in `wsgi_script_aliases`' do
    let(:title) { 'rspec.example.com' }
    let(:params) do
      { wsgi_script_aliases: { '/bar' => ['"/path/to/bar"', 'application-group=%{GLOBAL}'] } }
    end

    it 'creates a WSGIScriptAlias directive with the array joined together' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi_script_aliases')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIScriptAlias /bar "/path/to/bar" application-group=%\{GLOBAL\}})
    end
  end

  context 'With a hash for `wsgi_script_aliases_match`' do
    let(:title) { 'rspec.example.com' }
    let(:params) do
      { wsgi_script_aliases_match: { '[Bb]ar' => '/path/to/bar', '[Bb]az' => '/path/to/baz' } }
    end

    it 'creates a WSGIScriptAliasMatch directive for each entry in the hash (in any order)' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi_script_aliases')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{WSGIScriptAliasMatch \[Bb\]ar "/path/to/bar"})
        .with_content(%r{WSGIScriptAliasMatch \[Bb\]az "/path/to/baz"})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { wsgi_script_aliases: { '/bar' => '/path/to/bar/' },
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi_script_aliases-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { wsgi_script_aliases: { '/bar' => '/path/to/bar/' },
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::wsgi_script_aliases { "rspec.example.com": wsgi_script_aliases => { "/foo" => "/path/to/foo/" } }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi_script_aliases')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-wsgi_script_aliases-test_title')
    end
  end
end
