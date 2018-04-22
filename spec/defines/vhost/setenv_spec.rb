require 'spec_helper'

describe 'apache::vhost::setenv', type: :define do
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
    it 'does not create a concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-setenv')
    end
  end

  context 'With a `setenv` parameter string value' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { setenv: 'FOO bar' }
    end

    it 'creates a concat fragment with a single `SetEnv` directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-setenv')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SetEnv FOO bar})
    end
  end

  context 'With a `setenv` parameter array value' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { setenv: ['FOO bar', 'BAZ quux'] }
    end

    it 'creates a concat fragment with two `SetEnv` directives in the given order' do
      is_expected.to contain_concat__fragment('rspec.example.com-setenv')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SetEnv FOO bar.*SetEnv BAZ quux}m)
    end
  end

  context 'With a `setenvif` parameter string value' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { setenvif: 'Header "match" FOO bar' }
    end

    it 'creates a concat fragment with a single `SetEnvIf` directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-setenv')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SetEnvIf Header "match" FOO bar})
    end
  end

  context 'With a `setenvif` parameter array value' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { setenvif: ['Header "match" FOO bar', 'Header2 "match2" BAZ quux'] }
    end

    it 'creates a concat fragment with two `SetEnvIf` directives in the given order' do
      is_expected.to contain_concat__fragment('rspec.example.com-setenv')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SetEnvIf Header "match" FOO bar.*SetEnvIf Header2 "match2" BAZ quux}m)
    end
  end

  context 'With a `setenvifnocase` parameter string value' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { setenvifnocase: 'Header "match" FOO bar' }
    end

    it 'creates a concat fragment with a single `SetEnvIfNoCase` directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-setenv')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SetEnvIfNoCase Header "match" FOO bar})
    end
  end

  context 'With a `setenvifnocase` parameter array value' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { setenvifnocase: ['Header "match" FOO bar', 'Header2 "match2" BAZ quux'] }
    end

    it 'creates a concat fragment with two `SetEnvIfNoCase` directives in the given order' do
      is_expected.to contain_concat__fragment('rspec.example.com-setenv')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{SetEnvIfNoCase Header "match" FOO bar.*SetEnvIfNoCase Header2 "match2" BAZ quux}m)
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { setenv: 'FOO bar',
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-setenv-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { setenv: 'BAZ quux', vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::setenv { "rspec.example.com": setenv => "FOO bar" }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-setenv')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-setenv-test_title')
    end
  end
end
