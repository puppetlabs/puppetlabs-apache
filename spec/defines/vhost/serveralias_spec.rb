require 'spec_helper'

describe 'apache::vhost::serveralias', type: :define do
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
    it 'does not have a concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-serveralias')
    end
  end

  context 'With a string for serveraliases' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { serveraliases: 'alias.example.com' }
    end

    it 'has the single ServerAlias' do
      is_expected.to contain_concat__fragment('rspec.example.com-serveralias')
        .with_content(%r{ServerAlias alias\.example\.com})
        .without_content(%r{ServerAlias.*ServerAlias})
    end
  end

  context 'With an array for serveraliases' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { serveraliases: ['alias.example.com', 'another.example.com'] }
    end

    it 'has both ServerAliases' do
      is_expected.to contain_concat__fragment('rspec.example.com-serveralias')
        .with_content(%r{ServerAlias alias\.example\.com})
        .with_content(%r{ServerAlias another\.example\.com})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { serveraliases: 'alias.example.com',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-serveralias-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { serveraliases: 'alias.example.com',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::serveralias { "rspec.example.com": serveraliases => "another.example.com" }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-serveralias')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-serveralias-test_title')
    end
  end
end
