require 'spec_helper'

describe 'apache::vhost::php_admin', type: :define do
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

    it 'does not include the concat fragment' do
      is_expected.not_to contain_concat__fragment('rspec.exmaple.com-php_admin')
    end
  end

  context 'With a php_admin_flags parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { php_admin_flags: { foo: true, bar: false } }
    end

    it 'creates a php_admin_flag entry for each flag with the appropriate value' do
      is_expected.to contain_concat__fragment('rspec.example.com-php_admin')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  php_admin_flag foo on\n})
        .with_content(%r{  php_admin_flag bar off\n})
    end
  end

  context 'With a php_admin_values parameter' do
    let(:title) { 'rspec.example.com' }
    let :params do
      { php_admin_values: { foo: 'bar', baz: 'quux' } }
    end

    it 'creates a php_admin_value entry for each key with the appropriate value' do
      is_expected.to contain_concat__fragment('rspec.example.com-php_admin')
        .with_target('apache::vhost::rspec.example.com')
        .with_content(%r{  php_admin_value foo bar\n})
        .with_content(%r{  php_admin_value baz quux\n})
    end
  end

  context 'With a different vhost and title' do
    let(:title) { 'test_title' }
    let :params do
      { php_admin_flags: { foo: true },
        vhost: 'rspec.example.com' }
    end

    it 'creates an appropriately-named concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-php_admin-test_title')
        .with_target('apache::vhost::rspec.example.com')
    end
  end

  context 'With multiple definitions' do
    let(:title) { 'test_title' }
    let :params do
      { php_admin_flags: { foo: true },
        vhost: 'rspec.example.com' }
    end
    let :pre_condition do
      'class { "apache": default_vhost => false, default_mods => false, vhost_enable_dir => "/etc/apache2/sites-enabled"}
       apache::vhost::php_admin { "rspec.example.com": php_admin_values => { bar => baz } }'
    end

    it 'contains the first concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-php_admin')
    end
    it 'contains the second concat fragment' do
      is_expected.to contain_concat__fragment('rspec.example.com-php_admin-test_title')
    end
  end
end
