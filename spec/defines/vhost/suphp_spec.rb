require 'spec_helper'

describe 'apache::vhost::suphp', type: :define do
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
      is_expected.not_to contain_concat__fragment('rspec.example.com-suphp')
    end
  end

  context 'With suphp_engine set to `off`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { suphp_engine: 'off' }
    end

    it 'does not create the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.example.com-suphp')
    end
  end

  context 'With suphp_engine set to `on`' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { suphp_engine: 'on' }
    end

    it 'creates the suPHP_Engine directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-suphp')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{suPHP_Engine +on})
    end
  end

  context 'With suphp_configpath parameter set' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { suphp_engine: 'on',
        suphp_configpath: '/path/to/server/config' }
    end

    it 'creates the suPHP_ConfigPath directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-suphp')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{suPHP_ConfigPath +"/path/to/server/config"})
    end
  end

  context 'With suphp_addhandler parameter set' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { suphp_engine: 'on',
        suphp_addhandler: 'application/x-httpd-php' }
    end

    it 'creates the suPHP_AddHandler directive' do
      is_expected.to contain_concat__fragment('rspec.example.com-suphp')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{suPHP_AddHandler +application/x-httpd-php})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { suphp_engine: 'on',
        vhost: 'rspec.example.com' }
    end

    it 'creates the same concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-suphp')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { suphp_engine: 'on',
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::suphp { "rspec.example.com": suphp_engine => on }'
    end

    it 'fails with duplicate resources' do
      is_expected.to compile.and_raise_error(%r{Duplicate declaration})
    end
  end
end
